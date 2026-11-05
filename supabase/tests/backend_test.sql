begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;
select no_plan();
select ok(not pg_has_role('authenticated','laurum_account_deleter','MEMBER'),'Client is not a cleanup role member');
select ok(not pg_has_role('service_role','laurum_account_deleter','MEMBER'),'Service role is not a cleanup role member');
select ok(not (select rolbypassrls from pg_roles where rolname='laurum_account_deleter'),'Cleanup role does not bypass RLS');

-- Synthetic UUIDs only. No customer fixtures, production data, credentials or tokens.
create temporary table test_rows(t text, owner_id uuid, payload jsonb);
create function pg_temp.denied(statement text) returns boolean language plpgsql as $$
declare affected bigint;
begin
  execute statement;
  get diagnostics affected = row_count;
  return affected = 0;
exception when insufficient_privilege or check_violation then return true;
end $$;
create function pg_temp.change(t text, id uuid, payload jsonb, op text default 'upsert', version integer default 4)
returns jsonb language sql as $$
  select jsonb_build_object('table',t,'row_id',id,'payload',payload,'op',op,'schema_version',version);
$$;
insert into auth.users(id) values('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb');
do $$ declare own uuid; t text; p jsonb; extra jsonb; begin
  foreach own in array array['aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'::uuid,'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'::uuid] loop
    foreach t in array array['businesses','customers','services','orders','order_items','payments','savings_entries',
      'order_events','expense_categories','expenses','receipt_settings','devices','entitlements'] loop
      extra := case t
        when 'businesses' then '{"name":"Test business"}'::jsonb
        when 'customers' then jsonb_build_object('name','Test customer','phone','0800000000')
        when 'services' then '{"name":"Test service","kind":"kiloan","price":1000,"duration_days":1}'::jsonb
        when 'orders' then jsonb_build_object('order_no','A-0001','customer_id',own,'status','diproses',
          'entered_at',now(),'estimated_at',now(),'subtotal',1000,'total',1000)
        when 'order_items' then jsonb_build_object('order_id',own,'service_id',own,'service_name','Test service',
          'unit','kg','qty_milli',1000,'unit_price',1000,'line_total',1000)
        when 'payments' then jsonb_build_object('order_id',own,'method','tunai','amount',1000,'paid_at',now())
        when 'savings_entries' then jsonb_build_object('customer_id',own,'kind','setor','method','tunai','amount',1000)
        when 'order_events' then jsonb_build_object('order_id',own,'kind','created','occurred_at',now())
        when 'expense_categories' then '{"name":"Test category"}'::jsonb
        when 'expenses' then jsonb_build_object('category_id',own,'amount',100,'spent_at',now())
        when 'receipt_settings' then '{}'::jsonb
        when 'devices' then '{"code":"A","name":"Test device"}'::jsonb
        when 'entitlements' then '{"source":"test"}'::jsonb end;
      p := extra || jsonb_build_object('id',own,'owner_id',own);
      execute format('insert into public.%I(%s) select %s from jsonb_populate_record(null::public.%I,$1) p',t,
        (select string_agg(format('%I',key),',') from jsonb_object_keys(p) key),
        (select string_agg(format('p.%I',key),',') from jsonb_object_keys(p) key),t) using p;
      execute format('insert into test_rows select $1,owner_id,to_jsonb(r) from public.%I r where id=$2',t) using t,own;
    end loop;
  end loop;
end $$;
insert into storage.objects(bucket_id,name) values
  ('expense-photos','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa/test.jpg'),
  ('expense-photos','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb/test.jpg');
grant select on test_rows to authenticated;

-- All 13 owner tables: visibility and forged ownership for every CRUD verb.
create function pg_temp.owner_tests() returns setof text language plpgsql as $$ declare r record; n bigint; p jsonb; statement text; begin
  for r in select * from test_rows where owner_id='bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb' loop
    execute format('select count(*) from public.%I where owner_id=$1',r.t) into n using r.owner_id;
    return next is(n,0::bigint,r.t || ': cannot read B');
    execute format('select count(*) from public.%I',r.t) into n;
    return next is(n,1::bigint,r.t || ': can read A');
    p := r.payload || jsonb_build_object('id',gen_random_uuid());
    statement := format('insert into public.%I select * from jsonb_populate_record(null::public.%I,%L::jsonb)',r.t,r.t,p);
    return next ok(pg_temp.denied(statement),r.t || ': cannot insert as B');
    return next ok(pg_temp.denied(format('update public.%I set updated_at=now() where owner_id=%L',r.t,r.owner_id)),r.t || ': cannot update B');
    return next ok(pg_temp.denied(format('delete from public.%I where owner_id=%L',r.t,r.owner_id)),r.t || ': cannot delete B');
  end loop;
end $$;
set local role authenticated;
set local request.jwt.claims = '{"sub":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","role":"authenticated"}';
select * from pg_temp.owner_tests();
select is((select count(*) from storage.objects),1::bigint,'Storage lists only A');
select ok(pg_temp.denied($q$insert into storage.objects(bucket_id,name) values('expense-photos','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb/forged.jpg')$q$),'Storage cannot insert B');
select ok(pg_temp.denied($q$update storage.objects set name='bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb/moved.jpg' where name like 'aaaaaaaa%'$q$),'Storage cannot move A into B');
select ok(pg_temp.denied($q$update storage.objects set name='forged.jpg' where name like 'bbbbbbbb%'$q$),'Storage cannot update B');
select ok(pg_temp.denied($q$delete from storage.objects where name like 'bbbbbbbb%'$q$),'Storage cannot delete B');
select ok(pg_temp.denied('update public.app_config set min_schema_version=1'),'Client cannot lower minimum schema');
select ok(pg_temp.denied('insert into public.app_config values(false,1)'),'Client cannot insert config');
select ok(pg_temp.denied('delete from public.app_config'),'Client cannot delete config');
select is((select min_schema_version from public.app_config),4,'Global config readable');
select ok(pg_temp.denied($q$update public.customers set owner_id='bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'$q$),'Owner immutable');
select ok(pg_temp.denied('update public.payments set amount=1'),'Own payment cannot update');
select ok(pg_temp.denied('delete from public.payments'),'Own payment cannot delete');
select ok(pg_temp.denied('update public.savings_entries set amount=1'),'Own savings cannot update');
select ok(pg_temp.denied('delete from public.savings_entries'),'Own savings cannot delete');
select ok(pg_temp.denied('update public.order_items set qty_milli=1'),'Own items cannot update');
select ok(pg_temp.denied('update public.entitlements set plan=''pro'''),'Client cannot grant Pro');
select ok(pg_temp.denied('delete from public.order_items'),'Own items cannot delete');
select ok(pg_temp.denied('update public.order_events set kind=''forged'''),'Own events cannot update');
select ok(pg_temp.denied('delete from public.order_events'),'Own events cannot delete');
select is(sync_push(jsonb_build_array(pg_temp.change('orders','12345678-1234-4234-8234-123456789012',
  '{"id":"12345678-1234-4234-8234-123456789012","order_no":"A-0002","customer_id":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","status":"selesai","pay_term":"cod","entered_at":"2026-11-05T00:00:00Z","estimated_at":"2026-11-06T00:00:00Z","subtotal":1000,"total":1000}')))->0->>'status','ditolak','Unpaid COD cannot complete on insert');
select throws_ok('select public.sync_push(''{}'')','22023','changes_must_be_array','Reject non-array batch');
select throws_ok('select public.sync_push((select jsonb_agg(''{}''::jsonb) from generate_series(1,51)))',
  '22023','batch_too_large','Reject batch over 50');

create temporary table push_result as select sync_push(jsonb_build_array(pg_temp.change('customers',
  'cccccccc-cccc-4ccc-8ccc-cccccccccccc','{"id":"cccccccc-cccc-4ccc-8ccc-cccccccccccc","owner_id":"bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb","name":"Retry","phone":"0800000001","updated_at":"2000-01-01T00:00:00Z"}'))) as value;
select is((select value->0->>'status' from push_result),'ok','Push succeeds');
select is((select owner_id::text from public.customers where id='cccccccc-cccc-4ccc-8ccc-cccccccccccc'),
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','Forged owner ignored');
select ok((select updated_at > '2026-01-01'::timestamptz from public.customers where id='cccccccc-cccc-4ccc-8ccc-cccccccccccc'),'Timestamp is server assigned');
select is(sync_push(jsonb_build_array(pg_temp.change('customers','cccccccc-cccc-4ccc-8ccc-cccccccccccc',
  '{"id":"cccccccc-cccc-4ccc-8ccc-cccccccccccc","name":"Retry","phone":"0800000001"}'))),
  (select value from push_result),'Retry preserves timestamp and result');
select is((select count(*) from public.customers where id='cccccccc-cccc-4ccc-8ccc-cccccccccccc'),1::bigint,'Retry creates no duplicate');
select is(sync_push(jsonb_build_array(pg_temp.change('customers','dddddddd-dddd-4ddd-8ddd-dddddddddddd',
  '{"id":"dddddddd-dddd-4ddd-8ddd-dddddddddddd","name":"Conflict","phone":"0800000001"}'),
  pg_temp.change('customers','eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee',
  '{"id":"eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee","name":"Next","phone":"0800000002"}')))->0->>'status','konflik','Unique conflict classified');
select is((select count(*) from public.customers where id='eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee'),1::bigint,'Batch continues after conflict');
select is(sync_push(jsonb_build_array(pg_temp.change('customers','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  '{"id":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","name":"Old"}','upsert',1)))->0->>'code','schema_too_old','Old schema rejected');
select is(sync_push(jsonb_build_array(pg_temp.change('entitlements','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  '{"id":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","plan":"pro"}')))->0->>'status','ditolak','Whitelist excludes entitlement writes');
select is(sync_push(jsonb_build_array(pg_temp.change('customers;drop table public.orders','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  '{"id":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"}')))->0->>'status','ditolak','Table-name injection rejected');
select is(sync_push(jsonb_build_array(pg_temp.change('customers','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  '{"id":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","sync_state":"synced"}')))->0->>'status','ditolak','Local-only fields rejected');
select is(sync_push(jsonb_build_array(pg_temp.change('payments','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  (select payload from test_rows where t='payments' and owner_id=auth.uid()))))->0->>'status','ok','Append-only identical retry accepted');
select is(sync_push(jsonb_build_array(pg_temp.change('payments','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  (select payload || '{"amount":1}' from test_rows where t='payments' and owner_id=auth.uid()))))->0->>'status','ditolak','Append-only changed retry rejected');
select is(sync_push(jsonb_build_array(pg_temp.change('expenses','ffffffff-ffff-4fff-8fff-ffffffffffff',
  '{"id":"ffffffff-ffff-4fff-8fff-ffffffffffff","category_id":"bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb","amount":1,"spent_at":"2026-11-05T00:00:00Z"}')))->0->>'status','ditolak','Cross-owner FK rejected');
update public.orders set status='selesai';
select ok(pg_temp.denied('update public.orders set status=''diproses'''),'Final order cannot reverse');
select is(sync_push(jsonb_build_array(pg_temp.change('customers','eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee',null,'delete')))->0->>'status','ok','Soft delete succeeds');
select ok((select deleted_at is not null from public.customers where id='eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee'),'Tombstone retained for pull');

reset role;
set local role service_role;
select ok(pg_temp.denied('update public.payments set amount=1'),'Service role cannot mutate payments');
select ok(pg_temp.denied('delete from public.payments'),'Service role cannot delete payments');
select ok(pg_temp.denied('update public.savings_entries set amount=1'),'Service role cannot mutate savings');
select ok(pg_temp.denied('delete from public.savings_entries'),'Service role cannot delete savings');
reset role;
set local role authenticated;
select lives_ok('select public.delete_my_account()','Account data purge succeeds');
reset role;
create function pg_temp.purge_tests() returns setof text language plpgsql as $$ declare t text; n bigint; begin
  foreach t in array array['businesses','customers','services','orders','order_items','payments','savings_entries',
    'order_events','expense_categories','expenses','receipt_settings','devices','entitlements'] loop
    execute format('select count(*) from public.%I where owner_id=''aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa''',t) into n;
    return next is(n,0::bigint,t || ': A fully purged');
    execute format('select count(*) from public.%I where owner_id=''bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb''',t) into n;
    return next is(n,1::bigint,t || ': B retained');
  end loop;
end $$;
select * from pg_temp.purge_tests();
set local role anon;
select throws_ok('select public.delete_my_account()','42501',null,'Anonymous cannot delete account');
select throws_ok('select public.sync_push(''[]'')','42501',null,'Anonymous cannot push');
reset role;
select * from finish();
rollback;


