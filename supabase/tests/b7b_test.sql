begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;
select no_plan();

-- Synthetic UUIDs only. No production data, credentials or tokens.
create temporary table ids(name text primary key, id uuid);
insert into ids values
  ('a','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),
  ('b','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'),
  ('c','cccccccc-cccc-4ccc-8ccc-cccccccccccc'),
  ('service_a','a5111111-1111-4111-8111-111111111111'),
  ('service_b','b5222222-2222-4222-8222-222222222222'),
  ('order_a','a5333333-3333-4333-8333-333333333333'),
  ('order_b','b5444444-4444-4444-8444-444444444444'),
  ('conn_a','a5555555-5555-4555-8555-555555555555'),
  ('conn_b','b5666666-6666-4666-8666-666666666666'),
  ('customer_a','a5777777-7777-4777-8777-777777777777');
grant select on ids to authenticated, service_role;
create function pg_temp.denied(statement text) returns boolean language plpgsql as $$
declare affected bigint;
begin
  execute statement;
  get diagnostics affected = row_count;
  return affected = 0;
exception when insufficient_privilege or check_violation or foreign_key_violation then return true;
end $$;
create function pg_temp.msg(p_key text) returns text language sql as $$
  select case p_key
    when 'base' then '{"source_text":"Cuci 3 kg","customer_name":"Siti","phone":"+62 812-3456-7890",
      "address":"Jl. Mawar 1","service_hint":"cuci kiloan","uncertain_address":true,
      "cancel_requested":false,"confidence":0.87}'
    when 'minimal' then '{"source_text":"Cuci 1 kg"}'
  end
$$;
create function pg_temp.hash(p_changes jsonb) returns text language sql as $$
  select private.sha256_hex(private.canonical_json(p_changes));
$$;
create function pg_temp.push(p_changes jsonb, p_gid uuid default gen_random_uuid())
returns jsonb language sql as $$
  select public.sync_push(p_changes,p_gid,pg_temp.hash(p_changes),1,1,pg_temp.hash(p_changes));
$$;

insert into auth.users(id) select id from ids where name in ('a','b','c');
insert into public.services(id,owner_id,name,kind,price,duration_days,is_active) values
  ((select id from ids where name='service_a'),(select id from ids where name='a'),
   'Cuci Kiloan','kiloan',7000,2,true),
  ((select id from ids where name='service_b'),(select id from ids where name='b'),
   'Cuci Kiloan','kiloan',8000,2,true);
insert into public.customers(id,owner_id,name,phone) values
  ((select id from ids where name='customer_a'),(select id from ids where name='a'),'Siti','081234567890');
insert into public.orders(id,owner_id,order_no,customer_id,status,pay_term,entered_at,estimated_at,
  subtotal,total) values
  ((select id from ids where name='order_a'),(select id from ids where name='a'),'A-1',
   (select id from ids where name='customer_a'),'diproses','sekarang',now(),now(),1000,1000);
insert into public.wa_connections(id,owner_id,instance_id,status,connected_at) values
  ((select id from ids where name='conn_a'),(select id from ids where name='a'),'laurum-a',
   'terhubung','2026-11-18T00:00:00Z'),
  ((select id from ids where name='conn_b'),(select id from ids where name='b'),'laurum-b',
   'terhubung','2026-11-18T00:00:00Z');

select has_table('public','ai_proposals','ai_proposals exists');
select has_table('public','wa_connections','wa_connections exists');
select has_index('public','ai_proposals','ai_proposals_pull','proposal pull index');
select has_index('public','wa_connections','wa_connections_pull','connection pull index');
select ok((select relrowsecurity from pg_class where oid='public.ai_proposals'::regclass),
  'RLS enabled on ai_proposals');
select ok((select relrowsecurity from pg_class where oid='public.wa_connections'::regclass),
  'RLS enabled on wa_connections');

-- Worker side: service_role only.
set local role service_role;
select set_config('request.jwt.claims','{"role":"service_role"}',true);
select is(public.ingest_ai_proposal('laurum-a','wam-1','62812@c.us','2026-11-18T01:00:00Z',
  pg_temp.msg('base')::jsonb)->>'code','created','Ingest creates a proposal');
select is((select owner_id::text from public.ai_proposals where wa_message_id='wam-1'),
  (select id::text from ids where name='a'),'Owner comes from the paired instance');
select is((select phone from public.ai_proposals where wa_message_id='wam-1'),
  '081234567890','Phone is normalized to local digits');
select is((select service_id::text from public.ai_proposals where wa_message_id='wam-1'),
  (select id::text from ids where name='service_a'),'Service hint resolved inside the owner');
select is((select confidence from public.ai_proposals where wa_message_id='wam-1'),
  0.87::numeric,'Confidence stored as given');
select is((select uncertain_address from public.ai_proposals where wa_message_id='wam-1'),
  true,'Uncertain address flag stored');
select is(public.ingest_ai_proposal('laurum-a','wam-1','62812@c.us','2026-11-18T01:00:00Z',
  pg_temp.msg('base')::jsonb)->>'code','duplicate','Same message id is duplicate');
select is((select count(*) from public.ai_proposals where wa_message_id='wam-1'),1::bigint,
  'Duplicate creates no row');
select is(public.ingest_ai_proposal('laurum-zzz','wam-x','1@c.us','2026-11-18T01:00:00Z',
  pg_temp.msg('base')::jsonb)->>'code','unknown_instance','Unknown instance is rejected');
select is(public.ingest_ai_proposal('laurum-a','wam-empty','1@c.us','2026-11-18T01:00:00Z',
  '{"source_text":"   "}'::jsonb)->>'code','invalid','Empty text is invalid');
select is(public.ingest_ai_proposal('laurum-a','wam-long','1@c.us','2026-11-18T01:00:00Z',
  jsonb_build_object('source_text',repeat('a',2001)))->>'code','invalid','Long text is invalid');
select is(public.ingest_ai_proposal('laurum-a','wam-key','1@c.us','2026-11-18T01:00:00Z',
  pg_temp.msg('base')::jsonb || '{"owner_id":"cccccccc-cccc-4ccc-8ccc-cccccccccccc"}')->>'code',
  'invalid','Payload cannot carry an owner');
select is(public.ingest_ai_proposal('laurum-a','wam-conf','1@c.us','2026-11-18T01:00:00Z',
  pg_temp.msg('base')::jsonb || '{"confidence":2}')->>'code','invalid','Confidence range checked');
select is(public.ingest_ai_proposal('laurum-a','wam-phone','1@c.us','2026-11-18T01:00:00Z',
  pg_temp.msg('base')::jsonb || '{"phone":"12"}')->>'code','invalid','Phone shape checked');
select is(public.ingest_ai_proposal('laurum-a','wam-addr','1@c.us','2026-11-18T01:00:00Z',
  jsonb_build_object('source_text','ok','address',repeat('a',301)))->>'code','invalid',
  'Address length checked');
select is(public.ingest_ai_proposal('laurum-a','wam-obj','1@c.us','2026-11-18T01:00:00Z',
  '[]'::jsonb)->>'code','invalid','Payload must be an object');
select is(public.ingest_ai_proposal('laurum-a','wam-old','1@c.us','2026-11-17T23:00:00Z',
  pg_temp.msg('base')::jsonb)->>'code','ignored','Message older than connected_at ignored');
select is(public.ingest_ai_proposal('laurum-b','wam-b1','62822@c.us','2026-11-18T02:00:00Z',
  pg_temp.msg('base')::jsonb)->>'code','created','Ingest for the second account');
select is((select owner_id::text from public.ai_proposals where wa_message_id='wam-b1'),
  (select id::text from ids where name='b'),'Second proposal owned by B');
select is((select service_id::text from public.ai_proposals where wa_message_id='wam-b1'),
  (select id::text from ids where name='service_b'),
  'Service hint matches the own service, never the other account');
select is(public.ingest_ai_proposal('laurum-a','wam-ref','1@c.us','2026-11-18T01:00:00Z',
  pg_temp.msg('base')::jsonb ||
  jsonb_build_object('order_id',(select id from ids where name='order_b')))->>'code','invalid',
  'Foreign order id rejected');
select is(public.ingest_ai_proposal('laurum-a','wam-2','62812@c.us','2026-11-18T01:05:00Z',
  pg_temp.msg('minimal')::jsonb)->>'code','created','Second pending proposal');
select is(public.ingest_ai_proposal('laurum-a','wam-3','62812@c.us','2026-11-18T01:06:00Z',
  pg_temp.msg('minimal')::jsonb)->>'code','created','Third pending proposal');
select is(public.ingest_ai_proposal('laurum-a','wam-4','62812@c.us','2026-11-18T01:07:00Z',
  pg_temp.msg('minimal')::jsonb)->>'code','created','Fourth pending proposal');
select is(public.get_ai_context('laurum-zzz')->>'code','unknown_instance','Context rejects unknown');
select is(public.get_ai_context('laurum-a')->>'code','ok','Context readable');
select is(jsonb_array_length(public.get_ai_context('laurum-a')->'services'),1,
  'Context lists the owner services only');
select ok(not (public.get_ai_context('laurum-a') ? 'owner_id'),'Context hides the owner');
select is(public.set_wa_connection_status('laurum-a','terputus')->>'code','updated',
  'Status update applies');
select is((select status from public.wa_connections where instance_id='laurum-a'),'terputus',
  'Status persisted');
select is(public.set_wa_connection_status('laurum-a','ngawur')->>'code','invalid',
  'Unknown status rejected');
select is(public.set_wa_connection_status('laurum-zzz','terhubung')->>'code','unknown_instance',
  'Status for unknown instance rejected');
select is(public.set_wa_connection_status('laurum-a','terhubung')->>'code','updated',
  'Reconnect accepted');
select ok((select connected_at > '2026-11-18T00:00:00Z'::timestamptz
  from public.wa_connections where instance_id='laurum-a'),'Reconnect refreshes connected_at');
select ok(pg_temp.denied($q$insert into public.ai_proposals(id,owner_id,status,source_text,
  wa_message_id,chat_id,received_at) values(gen_random_uuid(),
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','disetujui','x','wam-self','1@c.us',now())$q$),
  'Even the worker cannot insert a decided row directly');

-- Client side: own rows only, decisions only, no insert.
reset role;
select set_config('request.jwt.claims',
  json_build_object('sub',(select id from ids where name='a'),'role','authenticated')::text,true);
set local role authenticated;
select is((select count(*) from public.ai_proposals),4::bigint,'A reads only own proposals');
select is((select count(*) from public.ai_proposals
  where owner_id=(select id from ids where name='b')),0::bigint,'B proposals hidden from A');
with u as (update public.ai_proposals set status='disetujui', customer_name='Siti A',
  phone='081234567890', address='Jl. Mawar 2',
  order_id=(select id from ids where name='order_a')
  where wa_message_id='wam-1' returning 1)
  select is((select count(*) from u),1::bigint,'Owner approves own');
select ok((select decided_at is not null from public.ai_proposals where wa_message_id='wam-1'),
  'Server fills decided_at');
with u as (update public.ai_proposals set status='ditolak'
  where wa_message_id='wam-2' returning 1)
  select is((select count(*) from u),1::bigint,'Owner rejects own');
select ok(pg_temp.denied($q$update public.ai_proposals set source_text='edited'
  where wa_message_id='wam-4'$q$),'Message text is immutable for the client');
select ok(pg_temp.denied($q$update public.ai_proposals set status='ditutup_otomatis'
  where wa_message_id='wam-4'$q$),'Client cannot close automatically');
select ok(pg_temp.denied($q$update public.ai_proposals set status='menunggu'
  where wa_message_id='wam-1'$q$),'Final status cannot be reverted');
select ok(pg_temp.denied($q$insert into public.ai_proposals(id,owner_id,status,source_text,
  wa_message_id,chat_id,received_at) values(gen_random_uuid(),
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','menunggu','x','wam-client','1@c.us',now())$q$),
  'Client cannot insert a proposal');
select ok(pg_temp.denied($q$delete from public.ai_proposals$q$),
  'Client cannot delete a proposal');
with u as (update public.ai_proposals set status='ditolak'
  where wa_message_id='wam-b1' returning 1)
  select is((select count(*) from u),0::bigint,'Other owner proposal not updatable');
select is(jsonb_array_length(public.sync_pull('ai_proposals',null,null,500)->'rows'),4,
  'Pull returns the own proposals through the RPC');
select is(jsonb_array_length(public.sync_pull('wa_connections',null,null,500)->'rows'),1,
  'Pull returns the own connection through the RPC');
select is(pg_temp.push(jsonb_build_array(jsonb_build_object('change_id',gen_random_uuid(),
  'table','ai_proposals','row_id',(select id from public.ai_proposals where wa_message_id='wam-3'),
  'op','upsert','schema_version',5,
  'payload',(select to_jsonb(p) from public.ai_proposals p where wa_message_id='wam-3')
    || '{"status":"ditolak"}')))->'results'->0->>'status','ok','Decision pushed through sync_push');
select is((select status from public.ai_proposals where wa_message_id='wam-3'),'ditolak',
  'Pushed decision stored');
select is(pg_temp.push(jsonb_build_array(jsonb_build_object('change_id',gen_random_uuid(),
  'table','ai_proposals','row_id',gen_random_uuid(),'op','upsert','schema_version',5,
  'payload',jsonb_build_object('id',gen_random_uuid(),'source_text','x',
    'wa_message_id','wam-self','chat_id','1@c.us','received_at',now()))))->>'status','rejected',
  'Client insert through sync_push rejected');
select is((select count(*) from public.wa_connections),1::bigint,'A reads only own connection');
select ok(pg_temp.denied($q$insert into public.wa_connections(id,owner_id,instance_id)
  values(gen_random_uuid(),'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','evil')$q$),
  'Client cannot insert a connection');
select ok(pg_temp.denied($q$update public.wa_connections set instance_id='evil'$q$),
  'Client cannot edit a connection');
select is(public.set_ai_settings(false,true,false)->>'code','saved','Owner saves settings');
select is((select read_messages from public.wa_connections
  where owner_id=(select id from ids where name='a')),false,'Own read_messages saved');
select is((select ignore_groups from public.wa_connections
  where owner_id=(select id from ids where name='a')),true,'Own ignore_groups saved');
select is((select detect_cancellation from public.wa_connections
  where owner_id=(select id from ids where name='a')),false,'Own detect_cancellation saved');
select is((select count(*) from public.wa_connections
  where owner_id=(select id from ids where name='b')),0::bigint,'Other connection hidden');
select set_config('request.jwt.claims',
  json_build_object('sub',(select id from ids where name='c'),'role','authenticated')::text,true);
select is(public.set_ai_settings(true,true,true)->>'code','no_connection',
  'Account without a connection gets no_connection');

-- Grants: worker RPCs are not callable by clients.
reset role;
select is((select read_messages from public.wa_connections
  where owner_id=(select id from ids where name='b')),true,'Other read_messages untouched');
select is((select ignore_groups from public.wa_connections
  where owner_id=(select id from ids where name='b')),true,'Other ignore_groups untouched');
select is((select detect_cancellation from public.wa_connections
  where owner_id=(select id from ids where name='b')),true,'Other detect_cancellation untouched');
select ok(not has_function_privilege('authenticated',
  'public.ingest_ai_proposal(text,text,text,timestamptz,jsonb)','execute'),
  'Client cannot ingest');
select ok(not has_function_privilege('authenticated','public.get_ai_context(text)','execute'),
  'Client cannot read the AI context');
select ok(not has_function_privilege('authenticated',
  'public.set_wa_connection_status(text,text)','execute'),'Client cannot set connection status');
select ok(not has_function_privilege('anon','public.set_ai_settings(boolean,boolean,boolean)',
  'execute'),'Anonymous cannot save settings');
select ok(has_function_privilege('service_role',
  'public.ingest_ai_proposal(text,text,text,timestamptz,jsonb)','execute'),
  'Worker can ingest');

-- Retention and auto-close stay server side.
set local role service_role;
select set_config('request.jwt.claims','{"role":"service_role"}',true);
select ok(pg_temp.denied($q$update public.ai_proposals set source_text=null
  where wa_message_id='wam-4'$q$),'Undecided text cannot be dropped');
select lives_ok($q$update public.ai_proposals set source_text=null
  where wa_message_id='wam-1'$q$,'Decided text can be dropped');
select is((select source_text from public.ai_proposals where wa_message_id='wam-1'),null::text,
  'Decided text is cleared');
select ok(pg_temp.denied($q$update public.ai_proposals set customer_name='edited'
  where wa_message_id='wam-1'$q$),'Worker cannot rewrite owner fields');
select ok(pg_temp.denied($q$update public.ai_proposals set status='ditutup_otomatis'
  where wa_message_id='wam-3'$q$),'Decided proposal is not auto-closed');
select lives_ok($q$update public.ai_proposals set status='ditutup_otomatis'
  where wa_message_id='wam-4'$q$,'Worker closes a stale pending proposal');
select is((select status from public.ai_proposals where wa_message_id='wam-4'),'ditutup_otomatis',
  'Closed status stored');
select ok((select decided_at is not null from public.ai_proposals where wa_message_id='wam-4'),
  'Auto-close stamps decided_at so retention can run');

-- Account cleanup covers both new tables and keeps the other account intact.
reset role;
select set_config('request.jwt.claims',
  json_build_object('sub',(select id from ids where name='a'),'role','authenticated')::text,true);
set local role authenticated;
select lives_ok('select public.delete_my_account()','Account purge succeeds');
reset role;
select is((select count(*) from public.ai_proposals
  where owner_id=(select id from ids where name='a')),0::bigint,'A proposals purged');
select is((select count(*) from public.ai_proposals
  where owner_id=(select id from ids where name='b')),1::bigint,'B proposals kept');
select is((select count(*) from public.wa_connections
  where owner_id=(select id from ids where name='a')),0::bigint,'A connection purged');
select is((select count(*) from public.wa_connections
  where owner_id=(select id from ids where name='b')),1::bigint,'B connection kept');
select * from finish();
rollback;
