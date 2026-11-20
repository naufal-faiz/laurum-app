begin;
create extension if not exists pgtap with schema extensions;
set search_path=public,extensions;
select no_plan();
create temporary table weight_results(name text primary key,value jsonb);
grant select,insert on weight_results to service_role,authenticated;
create function pg_temp.weight_event(msg text,grams jsonb,action text default 'order',inst text default 'weight-a')
returns jsonb language plpgsql as $$
declare ctx jsonb;
begin
 ctx:=public.get_ai_conversation_context(inst,'081200000090');
 return public.ingest_ai_proposal(inst,msg,'6281200000090@s.whatsapp.net',clock_timestamp(),
   jsonb_build_object('action',action,'phone','081200000090','source_text','Synthetic request',
    'conversation_generation',ctx->'conversation_generation','context_revision',ctx->'context_revision',
    'draft_context',jsonb_build_object('estimated_weight_grams',grams)));
end $$;
insert into auth.users(id) values('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb');
insert into wa_connections(id,owner_id,instance_id,connected_at) values
 ('a1111111-1111-4111-8111-111111111111','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','weight-a','2000-01-01'),
 ('b1111111-1111-4111-8111-111111111111','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','weight-b','2000-01-01');
insert into ai_proposals(id,owner_id,source_text,wa_message_id,chat_id,received_at) values
 ('a2222222-2222-4222-8222-222222222222','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','Old proposal','old-weight','old-chat',now());
select is((select estimated_weight_grams from ai_proposals where wa_message_id='old-weight'),null::integer,'Old callers keep unknown weight');
set local role service_role;
select set_config('request.jwt.claims','{"role":"service_role"}',true);
insert into weight_results values('first',pg_temp.weight_event('weight-1','2000'));
select is((select value->>'code' from weight_results where name='first'),'created','Known grams create a proposal');
select is((select estimated_weight_grams from ai_proposals where phone='081200000090'),2000,'Stored in integer grams');
select is(public.get_ai_conversation_context('weight-a','081200000090')->'draft_context'->>'estimated_weight_grams','2000','Summary returns the trusted estimate');
select is(pg_temp.weight_event('weight-2','2500')->>'code','updated','A correction updates the same pending proposal');
select is((select count(*) from ai_proposals where phone='081200000090'),1::bigint,'No duplicate proposal after correction');
select is((select estimated_weight_grams from ai_proposals where phone='081200000090'),2500,'Correction retained');
select is(public.ingest_ai_proposal('weight-a','address-only','chat',clock_timestamp(),
 '{"action":"collect","phone":"081200000090","draft_context":{"address":"Synthetic address"}}')->>'code','updated','Unrelated continuation accepted');
select is((select estimated_weight_grams from ai_proposals where phone='081200000090'),2500,'Unrelated message keeps earlier stated weight');
select is(pg_temp.weight_event('unknown-weight','null')->>'code','updated','Explicit unknown clears estimate');
select is((select estimated_weight_grams from ai_proposals where phone='081200000090'),null::integer,'Unknown remains empty');
select is(pg_temp.weight_event('bad-negative','-1')->>'code','invalid','Negative weight rejected');
select is(pg_temp.weight_event('bad-zero','0')->>'code','invalid','Zero is not a positive estimate');
select is(pg_temp.weight_event('bad-fraction','2.5')->>'code','invalid','Fractional grams rejected');
select is(pg_temp.weight_event('bad-string','"2000"')->>'code','invalid','String grams rejected');
select is(pg_temp.weight_event('bad-large','2147483648')->>'code','invalid','Out-of-range grams rejected safely');
select is(pg_temp.weight_event('weight-1','9000')->>'code','duplicate','Duplicate cannot change estimate');
select is((select estimated_weight_grams from ai_proposals where phone='081200000090'),null::integer,'Duplicate does not restore stale weight');
select is(pg_temp.weight_event('weight-b','500','order','weight-b')->>'code','created','Second owner can use same phone');
select is((select estimated_weight_grams from ai_proposals where owner_id='bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'),500,'Second owner gets own weight');
select is(pg_temp.weight_event('weight-3','3000')->>'code','updated','Estimate updated before owner decision');
reset role;
set local role authenticated;
select set_config('request.jwt.claims','{"sub":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","role":"authenticated"}',true);
select is((select count(*) from ai_proposals where owner_id='bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'),0::bigint,'Owner cannot read another weight');
select throws_ok($q$update ai_proposals set estimated_weight_grams=1000 where phone='081200000090'$q$,
 '23514','immutable_content','Owner cannot write AI estimate');
select lives_ok($q$update ai_proposals set status='ditolak',estimated_weight_grams=2000 where phone='081200000090'$q$,
 'Stale cached estimate does not block rejection');
select is((select estimated_weight_grams from ai_proposals where phone='081200000090'),3000,'Server metadata wins over cached estimate');
reset role;
set local role service_role;
select set_config('request.jwt.claims','{"role":"service_role"}',true);
select is(pg_temp.weight_event('new-without-weight','null')->>'code','created','New request after final can have no weight');
select is((select estimated_weight_grams from ai_proposals where phone='081200000090' and status='menunggu'
 and owner_id='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),null::integer,'New request does not inherit old estimate');
select is(pg_temp.weight_event('new-cancel','null','cancel')->>'code','closed','Withdrawal still works');
select is((select count(*) from orders where owner_id='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),0::bigint,'Weight extraction creates no order');
select is((select count(*) from payments where owner_id='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),0::bigint,'Weight extraction creates no payment');
select * from finish();
rollback;
