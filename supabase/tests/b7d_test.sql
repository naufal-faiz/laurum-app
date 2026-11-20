begin;
create extension if not exists pgtap with schema extensions;
set search_path=public,extensions;
select no_plan();
select has_table('public','ai_conversation_contexts','Conversation context exists');
select has_table('public','ai_message_receipts','Message receipts exist');
create temporary table results(name text primary key, value jsonb);
grant select,insert on results to authenticated,service_role;
create function pg_temp.event(msg text, action text, draft jsonb default '{}', phone text default '081200000001',
  inst text default 'chat-a', at_time timestamptz default clock_timestamp(), extra jsonb default '{}')
returns jsonb language plpgsql as $$
declare ctx jsonb; payload jsonb;
begin
  ctx:=public.get_ai_conversation_context(inst,phone);
  payload:=jsonb_build_object('action',action,'phone',phone,'draft_context',draft,
    'conversation_generation',ctx->'conversation_generation','context_revision',ctx->'context_revision');
  if action='order' then payload:=payload||'{"source_text":"synthetic laundry request"}'::jsonb; end if;
  return public.ingest_ai_proposal(inst,msg,phone||'@s.whatsapp.net',at_time,payload||extra);
end $$;
create function pg_temp.denied(statement text) returns boolean language plpgsql as $$
begin execute statement; return false;
exception when insufficient_privilege or check_violation then return true; end $$;
create function pg_temp.accept(p_id uuid,p_new_order uuid) returns jsonb language plpgsql as $$
declare changes jsonb; hash text;
begin
 changes:=jsonb_build_array(jsonb_build_object('change_id',gen_random_uuid(),'table','orders','op','upsert',
   'schema_version',5,'row_id',p_new_order,'payload',jsonb_build_object('id',p_new_order,'order_no','A-2',
   'customer_id','a3333333-3333-4333-8333-333333333333','source','whatsapp_ai','proposal_id',p_id,
   'status','diproses','pay_term','sekarang','entered_at',now(),'estimated_at',now(),'subtotal',0,'total',0)),
   (select jsonb_build_object('change_id',gen_random_uuid(),'table','ai_proposals','op','upsert','schema_version',5,
   'row_id',p.id,'payload',(to_jsonb(p)-'decided_at')||jsonb_build_object('status','disetujui',
   'order_id',p_new_order,'confidence',0.01,'source_text','stale cached text')) from ai_proposals p where id=p_id));
 hash:=private.sha256_hex(private.canonical_json(changes));
 return public.sync_push(changes,gen_random_uuid(),hash,1,1,hash);
end $$;
insert into auth.users(id) values('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb');
insert into public.wa_connections(id,owner_id,instance_id,connected_at) values
('a1111111-1111-4111-8111-111111111111','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','chat-a','2000-01-01'),
('b1111111-1111-4111-8111-111111111111','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','chat-b','2000-01-01');
insert into public.services(id,owner_id,name,kind,price,duration_days) values
('a2222222-2222-4222-8222-222222222222','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','Cuci','kiloan',7000,2),
('b2222222-2222-4222-8222-222222222222','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','Cuci','kiloan',8000,2);
set local role service_role;
select set_config('request.jwt.claims','{"role":"service_role"}',true);
select is(public.get_ai_conversation_context('missing','081200000001')->>'code','unknown_instance','Unknown instance rejected');
select is(public.get_ai_conversation_context('chat-a','bad')->>'code','invalid','Invalid sender rejected');
select ok(not(public.get_ai_conversation_context('chat-a','081200000001')?'owner_id'),'LLM context hides owner');
select is(pg_temp.event('ignore-1','ignore')->>'code','ignored','Non-order ignored');
select is((select count(*) from ai_conversation_contexts),0::bigint,'Non-order creates no context');
select is((select count(*) from ai_message_receipts),0::bigint,'Non-order creates no receipt');
select is(pg_temp.event('bad-array','order','[]')->>'code','invalid','Array context is rejected without a server error');
select is(pg_temp.event('bad-field','order','{"address":{}}')->>'code','invalid','Wrong field type is rejected');
select ok(not has_table_privilege('service_role','public.ai_conversation_contexts','INSERT'),'Context writes require the RPC');
select ok(not has_table_privilege('service_role','public.ai_message_receipts','UPDATE'),'Receipt writes require the RPC');
select is(pg_temp.event('collect-1','collect','{"customer_name":"Ani"}')->>'code','collected','Incomplete intent collected');
select is((select count(*) from ai_proposals),0::bigint,'Incomplete intent makes no proposal');
select is(pg_temp.event('collect-2','collect','{"address":"Alamat uji"}')->>'code','collected','Second message extends context');
select is(public.get_ai_conversation_context('chat-a','081200000001')->'draft_context'->>'customer_name','Ani','Name retained across messages');
select is(public.get_ai_conversation_context('chat-a','081200000001')->'draft_context'->>'address','Alamat uji','Address retained');
insert into results values('first',pg_temp.event('order-1','order','{"service_hint":"Cuci","confidence":0.9}'));
select is((select value->>'code' from results where name='first'),'created','Clear intent creates proposal');
select is((select customer_name from ai_proposals),'Ani','Proposal carries accumulated name');
select is((select address from ai_proposals),'Alamat uji','Proposal carries accumulated address');
select is((select service_id::text from ai_proposals),'a2222222-2222-4222-8222-222222222222','Service belongs to owner');
select is(pg_temp.event('update-1','order','{"address":"Alamat baru"}')->>'code','updated','Continuation updates same proposal');
select is((select count(*) from ai_proposals),1::bigint,'Only one proposal exists');
select is((select address from ai_proposals),'Alamat baru','Updated data visible');
select is(pg_temp.event('order-1','order')->>'code','duplicate','Original event cannot be applied twice');
insert into results values('version',public.get_ai_conversation_context('chat-a','081200000001'));
select is(pg_temp.event('update-2','collect','{"customer_name":"Ani baru"}')->>'code','updated','Collect extends existing pending proposal');
select is(public.ingest_ai_proposal('chat-a','retry-1','081200000001@s.whatsapp.net',clock_timestamp(),
  jsonb_build_object('action','order','phone','081200000001','source_text','synthetic request',
  'conversation_generation',(select value->'conversation_generation' from results where name='version'),
  'context_revision',(select value->'context_revision' from results where name='version')))->>'code','retry','Stale revision asks worker to reevaluate');
select is((select count(*) from ai_message_receipts where wa_message_id='retry-1'),0::bigint,'Retry is not marked processed');
select is(pg_temp.event('retry-1','order')->>'code','updated','Retry with fresh context succeeds once');
select is(pg_temp.event('cancel-1','cancel')->>'code','closed','Cancellation withdraws proposal');
select is((select status from ai_proposals),'ditutup_otomatis','Withdrawn proposal goes to history');
select is((select count(*) from orders),0::bigint,'AI creates no order');
select is((select count(*) from payments),0::bigint,'AI writes no payments');
select is((select count(*) from savings_entries),0::bigint,'AI writes no savings');
select is(pg_temp.event('cancel-1','cancel')->>'code','duplicate','Duplicate cancellation is harmless');
insert into results values('second',pg_temp.event('order-2','order','{"customer_name":"Ani kedua"}'));
select is((select value->>'code' from results where name='second'),'created','Fresh order after withdrawal creates a new proposal');
select isnt((select value->>'proposal_id' from results where name='first'),
  (select value->>'proposal_id' from results where name='second'),'New proposal has a new ID');
select is(pg_temp.event('cancel-1','cancel')->>'code','duplicate','Old cancellation cannot withdraw fresh proposal');
select is(pg_temp.event('late-cancel','cancel','{}','081200000001','chat-a','2001-01-01')->>'code','stale','Late cancellation ignored');
select is((select count(*) from ai_proposals where status='menunggu'),1::bigint,'Fresh proposal still pending');
select is(pg_temp.event('inject','order','{"owner_id":"evil"}')->>'code','invalid','Draft rejects owner injection');
select is(pg_temp.event('unknown','order','{}','081200000001','missing')->>'code','unknown_instance','Ingest rejects unknown instance');
select is(pg_temp.event('b-order','order','{"customer_name":"B","service_hint":"Cuci"}',
  '081200000001','chat-b')->>'code','created','Same sender may order in another business');
select is((select count(*) from ai_proposals where owner_id='bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'),1::bigint,'B receives only its own proposal');
select ok(not exists(select 1 from ai_conversation_contexts where draft_context?'source_text'),'Context has no raw transcript');
select hasnt_column('public','ai_message_receipts','source_text','Receipts have no message text');
select hasnt_column('public','ai_message_receipts','payload','Receipts have no message payload');
reset role;
select set_config('request.jwt.claims','{"sub":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","role":"authenticated"}',true);
set local role authenticated;
select ok(pg_temp.denied('select * from public.ai_conversation_contexts'),'Client cannot read worker context');
select ok(pg_temp.denied('select * from public.ai_message_receipts'),'Client cannot read receipts');
select ok(not has_function_privilege('authenticated','public.get_ai_conversation_context(text,text)','execute'),'Client cannot call worker context RPC');
select ok(pg_temp.denied('update public.ai_proposals set status=''disetujui'' where status=''ditutup_otomatis'''),
  'Closed proposal cannot be approved without a corresponding order');
-- Valid acceptance from an offline cache must still commit through the real sync RPC.
reset role;
insert into public.customers(id,owner_id,name) values
('a3333333-3333-4333-8333-333333333333','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','Ani');
set local role authenticated;
insert into results values('offline_changes',jsonb_build_array(
  jsonb_build_object('change_id',gen_random_uuid(),'table','orders','op','upsert','schema_version',5,
    'row_id','a4444444-4444-4444-8444-444444444444','payload',jsonb_build_object(
      'id','a4444444-4444-4444-8444-444444444444','order_no','A-1',
      'customer_id','a3333333-3333-4333-8333-333333333333','source','whatsapp_ai',
      'proposal_id',(select value->>'proposal_id' from results where name='first'),
      'status','diproses','pay_term','sekarang','entered_at',now(),'estimated_at',now(),'subtotal',0,'total',0)),
  (select jsonb_build_object('change_id',gen_random_uuid(),'table','ai_proposals','op','upsert','schema_version',5,
    'row_id',p.id,'payload',(to_jsonb(p)-'decided_at')||jsonb_build_object('status','disetujui',
      'order_id','a4444444-4444-4444-8444-444444444444')) from ai_proposals p
    where p.id=(select (value->>'proposal_id')::uuid from results where name='first'))));
insert into results values('offline_receipt',public.sync_push(
  (select value from results where name='offline_changes'),gen_random_uuid(),
  private.sha256_hex(private.canonical_json((select value from results where name='offline_changes'))),
  1,1,private.sha256_hex(private.canonical_json((select value from results where name='offline_changes')))));
select is((select value->>'status' from results where name='offline_receipt'),'committed','Offline order and decision commit after AI withdrawal');
select is((select status from ai_proposals where id=(select (value->>'proposal_id')::uuid from results where name='first')),
  'disetujui','Owner acceptance wins for the accepted proposal');
select is((select count(*) from orders),1::bigint,'Accepted order remains');
select is((select count(*) from payments),0::bigint,'No automatic refund');
-- Stale AI metadata must not block a real owner decision on a refreshed pending draft.

select is(pg_temp.accept((select (value->>'proposal_id')::uuid from results where name='second'),
 'a5555555-5555-4555-8555-555555555555')->>'status','committed','Pending acceptance tolerates stale AI metadata');
select is((select source_text from ai_proposals where id=(select (value->>'proposal_id')::uuid from results where name='second')),
 'synthetic laundry request','Server retains immutable source text');
reset role;
set local role service_role;
select set_config('request.jwt.claims','{"role":"service_role"}',true);
select is(pg_temp.event('after-approval','order')->>'code','created','New request after approval creates new proposal');
insert into results values('before-reject',public.get_ai_conversation_context('chat-a','081200000001'));
reset role;
select set_config('request.jwt.claims','{"sub":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","role":"authenticated"}',true);
set local role authenticated;
select lives_ok($q$update ai_proposals set status='ditolak',confidence=0.01,source_text='stale rejection cache'
 where status='menunggu'$q$,'Owner rejection preserves server AI metadata instead of causing conflict');
reset role;
set local role service_role;
select set_config('request.jwt.claims','{"role":"service_role"}',true);
select is(public.ingest_ai_proposal('chat-a','owner-race','081200000001@s.whatsapp.net',clock_timestamp(),
 jsonb_build_object('action','order','phone','081200000001','source_text','synthetic request',
 'conversation_generation',(select value->'conversation_generation' from results where name='before-reject'),
 'context_revision',(select value->'context_revision' from results where name='before-reject')))->>'code','retry',
 'Owner decision invalidates an in-flight worker context');
select is(pg_temp.event('after-rejection','order')->>'code','created','New request after rejection creates new proposal');
update wa_connections set detect_cancellation=false where instance_id='chat-a';
select is(pg_temp.event('disabled-cancel','cancel')->>'code','ignored','Disabled cancellation leaves proposal alone');
update wa_connections set detect_cancellation=true where instance_id='chat-a';
select is(pg_temp.event('disabled-cancel','cancel')->>'code','duplicate','Ignored cancellation cannot replay after settings change');
select is((select count(*) from ai_proposals where owner_id='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa' and status='menunggu'),
 1::bigint,'Exactly one active proposal remains');
select ok(pg_temp.denied($q$update ai_proposals set customer_name='unauthorized refresh' where status='menunggu'$q$),
 'Direct worker writes cannot bypass validated ingress');
reset role;
select set_config('request.jwt.claims','{"sub":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","role":"authenticated"}',true);
set local role authenticated;
select lives_ok('select public.delete_my_account()','Account purge includes new tables');
reset role;
select is((select count(*) from ai_conversation_contexts where owner_id='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),0::bigint,'A contexts removed');
select is((select count(*) from ai_message_receipts where owner_id='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),0::bigint,'A receipts removed');
select is((select count(*) from ai_conversation_contexts where owner_id='bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'),1::bigint,'B context intact');
select * from finish();
rollback;
