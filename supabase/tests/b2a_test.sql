begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;
select no_plan();

-- Synthetic UUIDs only. No production data, credentials or tokens.
create function pg_temp.change(p_table text, p_id uuid, p_payload jsonb,
  p_op text default 'upsert', p_version integer default 5)
returns jsonb language sql as $$
  select jsonb_build_object('change_id',gen_random_uuid(),'table',p_table,'row_id',p_id,
    'payload',p_payload,'op',p_op,'schema_version',p_version);
$$;
create function pg_temp.hash(p_changes jsonb) returns text language sql as $$
  select private.sha256_hex(private.canonical_json(p_changes));
$$;
create function pg_temp.push(p_changes jsonb, p_gid uuid default gen_random_uuid())
returns jsonb language sql as $$
  select public.sync_push(p_changes,p_gid,pg_temp.hash(p_changes),1,1,pg_temp.hash(p_changes));
$$;
create function pg_temp.push_frag(p_changes jsonb, p_gid uuid, p_idx integer, p_total integer, p_full jsonb)
returns jsonb language sql as $$
  select public.sync_push(p_changes,p_gid,pg_temp.hash(p_full),p_idx,p_total,pg_temp.hash(p_changes));
$$;

insert into auth.users(id) values
  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),
  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'),
  ('cccccccc-cccc-4ccc-8ccc-cccccccccccc');
insert into public.customers(id,owner_id,name,phone) values
  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','Customer A','0811'),
  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','Customer B','0822');
insert into public.services(id,owner_id,name,kind,price,duration_days) values
  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','Service A','kiloan',1000,1),
  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','Service B','kiloan',1000,1);
insert into public.orders(id,owner_id,order_no,customer_id,status,pay_term,entered_at,estimated_at,subtotal,total) values
  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','A-1',
   'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','diproses','sekarang',now(),now(),1000,1000),
  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','B-1',
   'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','diproses','sekarang',now(),now(),1000,1000);
insert into public.order_items(id,owner_id,order_id,service_id,service_name,unit,qty_milli,unit_price,line_total) values
  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
   'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','Service A','kg',1000,1000,1000),
  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
   'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','Service B','kg',1000,1000,1000);

set local role authenticated;
set local request.jwt.claims = '{"sub":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","role":"authenticated"}';

-- Items through the RPC: editable before final, move refused, other owner refused.
select is(pg_temp.push(jsonb_build_array(pg_temp.change('order_items',
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  (select to_jsonb(r) from public.order_items r where id='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa')
  || '{"qty_milli":1500}')))->'results'->0->>'status','ok','RPC item edit before final succeeds');
select is((select qty_milli from public.order_items where id='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),
  1500::bigint,'RPC item edit persisted');
select is(pg_temp.push(jsonb_build_array(pg_temp.change('order_items',
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',null,'delete')))->'results'->0->>'status','ok',
  'RPC item soft delete before final succeeds');
select ok((select deleted_at is not null from public.order_items where id='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),
  'RPC item soft delete kept a tombstone');
select is(pg_temp.push(jsonb_build_array(pg_temp.change('order_items',
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  (select to_jsonb(r) from public.order_items r where id='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa')
  || '{"deleted_at":null}')))->'results'->0->>'status','ok','RPC item can be restored before final');
select is(pg_temp.push(jsonb_build_array(pg_temp.change('order_items',
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  (select to_jsonb(r) from public.order_items r where id='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa')
  || '{"order_id":"bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb"}')))->'results'->0->>'code',
  'immutable_identity','RPC cannot move an item to another order');
select is(pg_temp.push(jsonb_build_array(pg_temp.change('order_items',
  'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
  '{"id":"bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb","owner_id":"bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb",
    "order_id":"bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb","service_id":"bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb",
    "service_name":"Forged","unit":"kg","qty_milli":1,"unit_price":1,"line_total":1}')))
  ->'results'->0->>'status','ditolak','RPC cannot update another owner item');

-- Group >50: staged fragments stay invisible until the complete group commits.
create temporary table bulk as
  select i, pg_temp.change('customers',
    format('10000000-0000-4000-8000-%s',lpad(i::text,12,'0'))::uuid,
    jsonb_build_object('id',format('10000000-0000-4000-8000-%s',lpad(i::text,12,'0'))::uuid,
      'name','Bulk '||i,'phone','')) as ch
  from generate_series(1,60) i;
create temporary table bulk_parts as select
  (select jsonb_agg(ch order by i) from bulk) as all_changes,
  (select jsonb_agg(ch order by i) from bulk where i <= 50) as first_part,
  (select jsonb_agg(ch order by i) from bulk where i > 50) as second_part,
  gen_random_uuid() as gid;
select is(pg_temp.push_frag(first_part,gid,1,2,all_changes)->>'status','staged','First fragment is only staged')
  from bulk_parts;
select is((select count(*) from public.customers where id::text like '10000000-%'),0::bigint,
  'Staged fragment is not visible');
select is(pg_temp.push_frag(second_part,gid,2,2,all_changes)->>'status','committed','Second fragment commits the group')
  from bulk_parts;
select is((select count(*) from public.customers where id::text like '10000000-%'),60::bigint,
  'Complete group is visible');
select is(pg_temp.push_frag(first_part,gid,1,2,all_changes)->>'status','committed','Committed fragment retry is idempotent')
  from bulk_parts;
select is((select count(*) from public.customers where id::text like '10000000-%'),60::bigint,
  'Committed retry adds no duplicate');

-- Reverse fragment arrival still commits in index order.
create temporary table reverse_full as select jsonb_build_array(
  pg_temp.change('customers','11000000-0000-4000-8000-000000000001',
    '{"id":"11000000-0000-4000-8000-000000000001","name":"Reverse one","phone":""}'),
  pg_temp.change('customers','11000000-0000-4000-8000-000000000002',
    '{"id":"11000000-0000-4000-8000-000000000002","name":"Reverse two","phone":""}')) as all_changes;
create temporary table reverse_parts as select all_changes, all_changes->0 as one, all_changes->1 as two,
  gen_random_uuid() as gid from reverse_full;
select is(pg_temp.push_frag(jsonb_build_array(two),gid,2,2,all_changes)->>'status','staged',
  'Last fragment may arrive first') from reverse_parts;
select is(pg_temp.push_frag(jsonb_build_array(one),gid,1,2,all_changes)->>'status','committed',
  'Missing first fragment completes the group') from reverse_parts;
select is((select count(*) from public.customers where id::text like '11000000-%'),2::bigint,
  'Reverse-order group is complete');

-- Fragment/hash/limit tampering.
create temporary table tamper as select
  jsonb_build_array(pg_temp.change('customers','12000000-0000-4000-8000-000000000001',
    '{"id":"12000000-0000-4000-8000-000000000001","name":"Tamper one","phone":""}')) as one,
  jsonb_build_array(pg_temp.change('customers','12000000-0000-4000-8000-000000000002',
    '{"id":"12000000-0000-4000-8000-000000000002","name":"Tamper two","phone":""}')) as two,
  gen_random_uuid() as gid;
select throws_ok($q$select public.sync_push(one,gen_random_uuid(),pg_temp.hash(one),1,1,
  repeat('0',64)) from tamper$q$,'22023','fragment_hash_mismatch','A fake fragment hash is rejected');
select throws_ok($q$select public.sync_push(one,gen_random_uuid(),pg_temp.hash(one),3,2,
  pg_temp.hash(one)) from tamper$q$,'22023','invalid_fragment','A fragment index outside its count is rejected');
select throws_ok($q$select public.sync_push(one,gen_random_uuid(),pg_temp.hash(one),1,101,
  pg_temp.hash(one)) from tamper$q$,'22023','invalid_fragment','Too many fragments are rejected');
select is((select public.sync_push(one,gen_random_uuid(),repeat('0',64),1,1,
  pg_temp.hash(one))->>'code' from tamper),'group_hash_mismatch','A fake single-fragment group hash is rejected');
create temporary table fake_group as select one, two, one || two as all_changes, gen_random_uuid() as gid from tamper;
select is(public.sync_push(one,gid,repeat('0',64),1,2,pg_temp.hash(one))->>'status','staged',
  'Fragment stages under a fake group hash') from fake_group;
select is((select public.sync_push(two,gid,repeat('0',64),2,2,pg_temp.hash(two))->>'code' from fake_group),
  'group_hash_mismatch','Group hash is verified at commit');
select is((select count(*) from public.customers where id::text like '12000000-%'),0::bigint,
  'Hash-mismatch group never reaches business tables');

-- A staged group does not block or leak into another group.
create temporary table isolated as select
  (select jsonb_agg(ch) from (values
    (pg_temp.change('customers','13000000-0000-4000-8000-000000000001',
      '{"id":"13000000-0000-4000-8000-000000000001","name":"Isolated one","phone":""}')),
    (pg_temp.change('customers','13000000-0000-4000-8000-000000000002',
      '{"id":"13000000-0000-4000-8000-000000000002","name":"Isolated two","phone":""}'))) v(ch)) as all_changes,
  gen_random_uuid() as staged_gid;
select is(pg_temp.push_frag(jsonb_build_array(all_changes->0),staged_gid,1,2,all_changes)->>'status','staged',
  'Group X remains staged') from isolated;
select is(pg_temp.push(jsonb_build_array(pg_temp.change('customers','14000000-0000-4000-8000-000000000001',
  '{"id":"14000000-0000-4000-8000-000000000001","name":"Group Y","phone":""}')))->>'status','committed',
  'Group Y commits while group X is staged');
select is((select count(*) from public.customers where id::text like '13000000-%'),0::bigint,
  'Staged group X is still invisible');
select is((select count(*) from public.customers where id='14000000-0000-4000-8000-000000000001'),1::bigint,
  'Group Y row is visible');

-- A group is all-or-nothing across order+item and payment+savings.
select is(pg_temp.push(jsonb_build_array(
  pg_temp.change('orders','20000000-0000-4000-8000-000000000001',
    '{"id":"20000000-0000-4000-8000-000000000001","order_no":"ROLL-1",
      "customer_id":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","status":"diproses","pay_term":"sekarang",
      "entered_at":"2026-11-05T00:00:00Z","estimated_at":"2026-11-06T00:00:00Z","subtotal":1000,"total":1000}'),
  pg_temp.change('order_items','21000000-0000-4000-8000-000000000001',
    '{"id":"21000000-0000-4000-8000-000000000001","order_id":"20000000-0000-4000-8000-000000000001",
      "service_id":"bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb","service_name":"Other owner","unit":"kg",
      "qty_milli":1000,"unit_price":1000,"line_total":1000}')))->'results'->0->>'code',
  'missing_reference','Bad item rolls back its order');
select is((select count(*) from public.orders where id='20000000-0000-4000-8000-000000000001'),0::bigint,
  'Order from a rejected group is absent');
select is(pg_temp.push(jsonb_build_array(
  pg_temp.change('payments','22000000-0000-4000-8000-000000000001',
    '{"id":"22000000-0000-4000-8000-000000000001","order_id":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa",
      "method":"tunai","amount":500,"paid_at":"2026-11-05T00:00:00Z"}'),
  pg_temp.change('savings_entries','23000000-0000-4000-8000-000000000001',
    '{"id":"23000000-0000-4000-8000-000000000001","customer_id":"bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb",
      "kind":"setor","method":"tunai","amount":500}')))->'results'->0->>'code',
  'missing_reference','Bad savings rolls back its payment');
select is((select count(*) from public.payments where id='22000000-0000-4000-8000-000000000001'),0::bigint,
  'Payment from a rejected group is absent');

-- COD completion and its payment may travel in one group and validate at the end state.
select is(pg_temp.push(jsonb_build_array(
  pg_temp.change('orders','30000000-0000-4000-8000-000000000001',
    '{"id":"30000000-0000-4000-8000-000000000001","order_no":"COD-1",
      "customer_id":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","status":"selesai","pay_term":"cod",
      "entered_at":"2026-11-05T00:00:00Z","estimated_at":"2026-11-06T00:00:00Z","subtotal":1000,"total":1000}'),
  pg_temp.change('payments','31000000-0000-4000-8000-000000000001',
    '{"id":"31000000-0000-4000-8000-000000000001","order_id":"30000000-0000-4000-8000-000000000001",
      "method":"tunai","amount":1000,"paid_at":"2026-11-05T00:00:00Z"}')))->>'status','committed',
  'Paid COD order and payment commit together');
select is((select count(*) from public.payments where id='31000000-0000-4000-8000-000000000001'),1::bigint,
  'COD payment is stored');
select is(pg_temp.push(jsonb_build_array(
  pg_temp.change('orders','32000000-0000-4000-8000-000000000001',
    '{"id":"32000000-0000-4000-8000-000000000001","order_no":"COD-2",
      "customer_id":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","status":"selesai","pay_term":"cod",
      "entered_at":"2026-11-05T00:00:00Z","estimated_at":"2026-11-06T00:00:00Z","subtotal":1000,"total":1000}'),
  pg_temp.change('payments','32000000-0000-4000-8000-000000000002',
    '{"id":"32000000-0000-4000-8000-000000000002","order_id":"32000000-0000-4000-8000-000000000001",
      "method":"tunai","amount":500,"paid_at":"2026-11-05T00:00:00Z"}')))->'results'->0->>'code','cod_unpaid',
  'Partially paid COD final state is rejected');
select is((select count(*) from public.orders where id='32000000-0000-4000-8000-000000000001'),0::bigint,
  'Rejected COD order is rolled back');
select is(pg_temp.push(jsonb_build_array(pg_temp.change('payments','33000000-0000-4000-8000-000000000001',
  '{"id":"33000000-0000-4000-8000-000000000001","order_id":"30000000-0000-4000-8000-000000000001",
    "method":"tunai","amount":-2000,"paid_at":"2026-11-05T00:00:00Z"}')))->'results'->0->>'code',
  'inconsistent_ledger','An over-reversal cannot commit');
select is((select count(*) from public.payments where id='33000000-0000-4000-8000-000000000001'),0::bigint,
  'Inconsistent correction is rolled back');

-- Retry of an old receipt never rewinds a newer edit.
create temporary table first_edit as select jsonb_build_array(pg_temp.change('customers',
  '40000000-0000-4000-8000-000000000001',
  '{"id":"40000000-0000-4000-8000-000000000001","name":"First","phone":""}')) as changes,
  gen_random_uuid() as gid;
select is(pg_temp.push(changes,gid)->>'status','committed','First edit commits') from first_edit;
select is(pg_temp.push(jsonb_build_array(pg_temp.change('customers',
  '40000000-0000-4000-8000-000000000001',
  '{"id":"40000000-0000-4000-8000-000000000001","name":"Second","phone":""}')))->>'status','committed',
  'Newer edit commits');
select is(pg_temp.push(changes,gid)->>'status','committed','Old group retry returns its receipt') from first_edit;
select is((select name from public.customers where id='40000000-0000-4000-8000-000000000001'),'Second',
  'Old receipt does not reapply its snapshot');

-- Pull contract: owner isolation, 500 cap, same-timestamp tuple, tombstones and late commits.
reset role;
alter table public.customers disable trigger user;
insert into public.customers(id,owner_id,created_at,updated_at,name,phone,address,notes,is_active)
select format('50000000-0000-4000-8000-%s',lpad(i::text,12,'0'))::uuid,
  'cccccccc-cccc-4ccc-8ccc-cccccccccccc','2099-01-01T00:00:00.123456Z',
  '2099-01-01T00:00:00.123456Z','Pull '||i,'','','',true
from generate_series(1,501) i;
alter table public.customers enable trigger user;
set local role authenticated;
set local request.jwt.claims = '{"sub":"cccccccc-cccc-4ccc-8ccc-cccccccccccc","role":"authenticated"}';
create temporary table pull_one as select public.sync_pull('customers',null,null,500) as value;
select is(jsonb_array_length(value->'rows'),500,'Pull returns at most 500 rows') from pull_one;
select is(value->>'has_more','true','Pull reports more rows') from pull_one;
select ok((value->'next_cursor'->>'updated_at') ~ '^2099-01-01T00:00:00\.123456Z$','Cursor uses UTC six digits')
  from pull_one;
create temporary table pull_two as select public.sync_pull('customers',
  (value->'next_cursor'->>'updated_at')::timestamptz,(value->'next_cursor'->>'id')::uuid,500) as value
  from pull_one;
select is(jsonb_array_length(value->'rows'),1,'Second pull returns the remaining same-timestamp row') from pull_two;
select is(value->>'has_more','false','Second pull is complete') from pull_two;
select is((select count(distinct e->>'id') from pull_one, jsonb_array_elements(value->'rows') e)
  + (select count(distinct e->>'id') from pull_two, jsonb_array_elements(value->'rows') e),501::bigint,
  'Same-timestamp rows are delivered once');
select is(jsonb_array_length(public.sync_pull('customers',null,null,1000)->'rows'),500,'Pull clamps larger limits');
select throws_ok($q$select public.sync_pull('app_config')$q$,'42501','table_not_allowed',
  'Pull rejects a non-whitelisted table');
select is((select count(*) from public.customers where owner_id='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),0::bigint,
  'Pull never leaks another owner rows');

select is(pg_temp.push(jsonb_build_array(pg_temp.change('customers','60000000-0000-4000-8000-000000000001',
  '{"id":"60000000-0000-4000-8000-000000000001","name":"Late commit","phone":""}')))->>'status','committed',
  'Late write commits after the cursor');
select is(pg_temp.push(jsonb_build_array(pg_temp.change('customers','60000000-0000-4000-8000-000000000002',
  null,'delete')))->'results'->0->>'code','missing_reference','Delete needs an existing row');
select is(pg_temp.push(jsonb_build_array(pg_temp.change('customers','50000000-0000-4000-8000-000000000001',
  null,'delete')))->>'status','committed','Tombstone write commits');
create temporary table pull_late as select public.sync_pull('customers',
  (value->'next_cursor'->>'updated_at')::timestamptz,(value->'next_cursor'->>'id')::uuid,500) as value
  from pull_two;
select is((select count(*) from pull_late, jsonb_array_elements(value->'rows') e
  where e->>'id'='60000000-0000-4000-8000-000000000001'),1::bigint,'Late commit appears after the cursor');
select ok((select bool_or(e->>'id'='50000000-0000-4000-8000-000000000001' and e->>'deleted_at' is not null)
  from pull_late, jsonb_array_elements(value->'rows') e),'Tombstone is included in pull');
select ok((select min((e->>'updated_at')::timestamptz) > '2099-01-01T00:00:00.123456Z'::timestamptz
  from pull_late, jsonb_array_elements(value->'rows') e),'New timestamps stay ahead of the cursor');

-- Account cleanup also removes staging and receipts, leaving the other owner untouched.
reset role;
set local role authenticated;
set local request.jwt.claims = '{"sub":"bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb","role":"authenticated"}';
select is(pg_temp.push_frag(jsonb_build_array(pg_temp.change('customers',
  '70000000-0000-4000-8000-000000000001',
  '{"id":"70000000-0000-4000-8000-000000000001","name":"B staged","phone":""}')),
  '70000000-0000-4000-8000-000000000099'::uuid,1,2,
  jsonb_build_array(pg_temp.change('customers','70000000-0000-4000-8000-000000000001',
    '{"id":"70000000-0000-4000-8000-000000000001","name":"B staged","phone":""}'),
    pg_temp.change('customers','70000000-0000-4000-8000-000000000002',
    '{"id":"70000000-0000-4000-8000-000000000002","name":"B missing","phone":""}')))->>'status','staged',
  'B has a staged group');
reset role;
set local role authenticated;
set local request.jwt.claims = '{"sub":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","role":"authenticated"}';
select lives_ok('select public.delete_my_account()','A account cleanup succeeds');
reset role;
select is((select count(*) from private.sync_groups where owner_id='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),0::bigint,
  'A staging and receipts are removed');
select is((select count(*) from private.sync_fragments where owner_id='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),0::bigint,
  'A staged fragments are removed');
select is((select count(*) from private.sync_groups where owner_id='bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'),1::bigint,
  'B receipt/staging is retained');
select is((select count(*) from private.sync_fragments where owner_id='bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'),1::bigint,
  'B fragment is retained');
select is((select count(*) from public.customers where owner_id='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),0::bigint,
  'A rows are purged');
select is((select count(*) from public.customers where owner_id='bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'),1::bigint,
  'B rows are retained');

set local role anon;
select throws_ok($q$select public.sync_pull('customers')$q$,'42501',null,'Anonymous cannot pull');
select throws_ok($q$select public.sync_pull('app_config')$q$,'42501',null,'Anonymous cannot reach a non-whitelisted table');
reset role;
select * from finish();
rollback;
