-- B2a: group-atomic sync contract. New migration only; the four B0 migrations stay frozen.
-- Wire schema 5: one business operation is one group with per-change ids, content hashes,
-- an idempotent receipt and an all-or-nothing commit. Pull uses an owner-serialized cursor.

-- 1. Per-owner serialization and a monotonic server timestamp -----------------
-- Every write takes the same transaction advisory lock as sync_push/sync_pull. The lock is
-- released only when the transaction commits, so a pull that acquires it afterwards cannot
-- miss a commit that started earlier. owner_clock also keeps updated_at monotonic per owner
-- even if the host clock moves backwards.
create table private.owner_clock (
  owner_id uuid primary key,
  last_at timestamptz not null
);

create function private.next_owner_timestamp(p_owner uuid) returns timestamptz
language plpgsql set search_path = '' as $$
declare next_at timestamptz;
begin
  -- Legacy rows may already carry a timestamp newer than the host clock. Seed the
  -- clock from the owner's real maximum so later writes can never land behind a cursor.
  if not exists (select from private.owner_clock where owner_id = p_owner) then
    insert into private.owner_clock(owner_id,last_at)
    select p_owner, coalesce(max(u),'-infinity'::timestamptz) from (
      select updated_at as u from public.businesses where owner_id = p_owner
      union all select updated_at from public.customers where owner_id = p_owner
      union all select updated_at from public.services where owner_id = p_owner
      union all select updated_at from public.orders where owner_id = p_owner
      union all select updated_at from public.order_items where owner_id = p_owner
      union all select updated_at from public.payments where owner_id = p_owner
      union all select updated_at from public.savings_entries where owner_id = p_owner
      union all select updated_at from public.order_events where owner_id = p_owner
      union all select updated_at from public.expense_categories where owner_id = p_owner
      union all select updated_at from public.expenses where owner_id = p_owner
      union all select updated_at from public.receipt_settings where owner_id = p_owner
      union all select updated_at from public.devices where owner_id = p_owner
      union all select updated_at from public.entitlements where owner_id = p_owner
    ) q
    on conflict (owner_id) do nothing;
  end if;
  update private.owner_clock
    set last_at = greatest(clock_timestamp(), last_at + interval '1 microsecond')
    where owner_id = p_owner
    returning last_at into next_at;
  return next_at;
end $$;

create or replace function private.stamp_record() returns trigger language plpgsql
set search_path = '' as $$ begin
  if TG_OP = 'UPDATE' then
    if new.owner_id is distinct from old.owner_id or new.id is distinct from old.id then
      raise exception using errcode = '23514', message = 'immutable_identity';
    end if;
    new.created_at := old.created_at;
  end if;
  new.updated_at := private.next_owner_timestamp(new.owner_id);
  return new;
end $$;

create function private.owner_write_lock() returns trigger language plpgsql
set search_path = '' as $$ begin
  if TG_OP = 'INSERT' then
    perform pg_advisory_xact_lock(hashtextextended('laurum_sync:' || new.owner_id::text, 0));
    return new;
  end if;
  perform pg_advisory_xact_lock(hashtextextended('laurum_sync:' || old.owner_id::text, 0));
  if TG_OP = 'DELETE' then return old; end if;
  return new;
end $$;

do $$ declare t text; begin
  foreach t in array array['businesses','customers','services','orders','order_items','payments','savings_entries',
    'order_events','expense_categories','expenses','receipt_settings','devices','entitlements'] loop
    execute format('create trigger a_owner_write_lock before insert or update or delete on public.%I
      for each row execute function private.owner_write_lock()',t);
  end loop;
end $$;

-- 2. Items are editable only while their own order is not final ---------------
-- id/owner_id/order_id stay immutable, no client hard delete, and final order values
-- are locked for both REST and RPC writes.
drop trigger immutable_ledger on public.order_items;
create trigger immutable_ledger before delete on public.order_items
  for each row execute function private.guard_ledger();

create function private.guard_order_item() returns trigger language plpgsql
set search_path = '' as $$
declare parent_status text;
begin
  if TG_OP = 'UPDATE' then
    if new.id is distinct from old.id or new.owner_id is distinct from old.owner_id
       or new.order_id is distinct from old.order_id then
      raise exception using errcode = '23514', message = 'immutable_identity';
    end if;
  end if;
  select status into parent_status from public.orders
    where id = new.order_id and owner_id = new.owner_id;
  if parent_status is null then
    raise exception using errcode = '23503', message = 'missing_reference';
  end if;
  if parent_status in ('selesai','dibatalkan') then
    raise exception using errcode = '23514', message = 'final_order';
  end if;
  return new;
end $$;

create trigger guard_order_item before insert or update on public.order_items
  for each row execute function private.guard_order_item();

revoke delete on public.order_items from authenticated;
create policy owner_update on public.order_items for update to authenticated
  using(owner_id = (select auth.uid())) with check(owner_id = (select auth.uid()));

create or replace function private.guard_order() returns trigger language plpgsql
set search_path = '' as $$ begin
  if TG_OP = 'UPDATE' and old.status in ('selesai','dibatalkan')
     and (to_jsonb(new) - 'updated_at' - 'created_at')
       is distinct from (to_jsonb(old) - 'updated_at' - 'created_at') then
    raise exception using errcode = '23514', message = 'final_order';
  end if;
  return new;
end $$;

-- COD must be paid by the end of the transaction, not at the moment of the order write.
-- That lets a group apply order + payment in dependency order and still validate the
-- final state. sync_push also checks the same condition before returning its receipt.
create function private.guard_cod_paid() returns trigger language plpgsql
set search_path = '' as $$ begin
  if new.status = 'selesai' and new.pay_term = 'cod' and new.total > coalesce(
    (select sum(amount) from public.payments where owner_id = new.owner_id and order_id = new.id),0) then
    raise exception using errcode = '23514', message = 'cod_unpaid';
  end if;
  return new;
end $$;
create constraint trigger guard_cod_paid after insert or update on public.orders
  deferrable initially deferred for each row execute function private.guard_cod_paid();

-- 3. Group staging and receipts ----------------------------------------------
create table private.sync_groups (
  owner_id uuid not null,
  group_id uuid not null,
  group_hash text not null check(group_hash ~ '^[0-9a-f]{64}$'),
  fragment_count integer not null check(fragment_count between 1 and 100),
  status text not null check(status in ('staged','committed','rejected')),
  receipt jsonb,
  created_at timestamptz not null default now(),
  committed_at timestamptz,
  primary key (owner_id, group_id)
);
create index sync_groups_status on private.sync_groups(owner_id,status);

create table private.sync_fragments (
  owner_id uuid not null,
  group_id uuid not null,
  fragment_index integer not null check(fragment_index between 1 and 100),
  fragment_hash text not null check(fragment_hash ~ '^[0-9a-f]{64}$'),
  changes jsonb not null check(jsonb_typeof(changes) = 'array'),
  created_at timestamptz not null default now(),
  primary key (owner_id, group_id, fragment_index),
  foreign key (owner_id, group_id) references private.sync_groups(owner_id,group_id) on delete cascade
);

-- Canonical hash contract shared with the B2 client adapter. Keys are sorted by code
-- point, arrays keep their order, numbers must be integers, strings use JSON escaping.
create function private.canonical_json(p_value jsonb) returns text language sql immutable
set search_path = '' as $$
  select case jsonb_typeof(p_value)
    when 'object' then '{' || coalesce((
      select string_agg(to_jsonb(k)::text || ':' || private.canonical_json(p_value->k), ',' order by k)
      from jsonb_object_keys(p_value) k), '') || '}'
    when 'array' then '[' || coalesce((
      select string_agg(private.canonical_json(e), ',' order by o)
      from jsonb_array_elements(p_value) with ordinality as x(e,o)), '') || ']'
    else p_value::text
  end
$$;

create function private.sha256_hex(p_text text) returns text language sql immutable
set search_path = '' as $$ select encode(sha256(convert_to(p_text,'UTF8')),'hex') $$;

create function private.is_uuid(p_text text) returns boolean language sql immutable
set search_path = '' as $$ select coalesce(p_text ~
  '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', false) $$;

create function private.iso6(p_value timestamptz) returns text language sql stable
set search_path = '' as $$
  select case when p_value is null then null
    else to_char(p_value at time zone 'UTC','YYYY-MM-DD"T"HH24:MI:SS.US"Z"') end
$$;

create function private.wire_row(p_row jsonb) returns jsonb language sql stable
set search_path = '' as $$
  select coalesce(jsonb_object_agg(key,
    case when key = any(array['created_at','updated_at','deleted_at','entered_at','estimated_at',
        'paid_at','occurred_at','spent_at','last_seen_at','valid_until'])
      and jsonb_typeof(value) = 'string'
      then to_jsonb(private.iso6((value #>> '{}')::timestamptz))
      else value end), '{}'::jsonb)
  from jsonb_each(p_row)
$$;

create function private.sync_error_code(p_state text, p_message text) returns text language sql immutable
set search_path = '' as $$
  select case
    when p_state = '23505' then 'unique_conflict'
    when p_state = '23503' then 'missing_reference'
    when p_state = '23514' then case
      when p_message like '%append_only%' then 'append_only'
      when p_message like '%final_order%' then 'final_order'
      when p_message like '%cod_unpaid%' then 'cod_unpaid'
      when p_message like '%immutable_identity%' then 'immutable_identity'
      when p_message like '%inconsistent_ledger%' then 'inconsistent_ledger'
      else 'invalid_change' end
    when p_state = '42501' then 'not_allowed'
    else 'invalid_change' end
$$;

create function private.validate_sync_orders(p_owner uuid, p_orders uuid[]) returns void
language plpgsql set search_path = '' as $$
declare o record; paid bigint;
begin
  if p_orders is null or cardinality(p_orders) = 0 then return; end if;
  for o in select id,status,pay_term,total from public.orders
    where owner_id = p_owner and id = any(p_orders) loop
    select coalesce(sum(amount),0) into paid from public.payments
      where owner_id = p_owner and order_id = o.id;
    if paid < 0 then
      raise exception using errcode = '23514', message = 'inconsistent_ledger';
    end if;
    if o.status = 'selesai' and o.pay_term = 'cod' and o.total > paid then
      raise exception using errcode = '23514', message = 'cod_unpaid';
    end if;
  end loop;
end $$;

-- 4. Group-atomic push --------------------------------------------------------
drop function public.sync_push(jsonb);

create function public.sync_push(
  p_changes jsonb,
  p_group_id uuid,
  p_group_hash text,
  p_fragment_index integer default 1,
  p_fragment_count integer default 1,
  p_fragment_hash text default null
) returns jsonb language plpgsql security invoker set search_path = '' as $$
declare
  own uuid := auth.uid();
  v_group private.sync_groups%rowtype;
  v_change jsonb; v_table text; v_op text; v_row uuid; v_change_id uuid;
  v_payload jsonb; v_existing jsonb; v_normalized jsonb;
  v_cols text; v_projection text; v_assignments text; v_stamp timestamptz;
  v_append_only boolean; v_fragment_hash text; v_group_hash text;
  v_received integer; v_total integer; v_distinct integer;
  v_full jsonb; v_results jsonb := '[]'::jsonb; v_receipt jsonb;
  v_code text; v_order_ids uuid[] := '{}';
begin
  if own is null then raise exception using errcode = '42501', message = 'authentication_required'; end if;
  if p_group_id is null then raise exception using errcode = '22023', message = 'group_id_required'; end if;
  if p_group_hash is null or p_group_hash !~ '^[0-9a-f]{64}$' then
    raise exception using errcode = '22023', message = 'invalid_group_hash';
  end if;
  if p_fragment_count is null or p_fragment_count < 1 or p_fragment_count > 100 then
    raise exception using errcode = '22023', message = 'invalid_fragment';
  end if;
  if p_fragment_index is null or p_fragment_index < 1 or p_fragment_index > p_fragment_count then
    raise exception using errcode = '22023', message = 'invalid_fragment';
  end if;
  if jsonb_typeof(p_changes) is distinct from 'array' or jsonb_array_length(p_changes) = 0 then
    raise exception using errcode = '22023', message = 'changes_must_be_nonempty_array';
  end if;
  if jsonb_array_length(p_changes) > 50 then
    raise exception using errcode = '22023', message = 'batch_too_large';
  end if;
  if p_fragment_hash is null or p_fragment_hash !~ '^[0-9a-f]{64}$' then
    raise exception using errcode = '22023', message = 'invalid_fragment_hash';
  end if;
  v_fragment_hash := private.sha256_hex(private.canonical_json(p_changes));
  if v_fragment_hash <> p_fragment_hash then
    raise exception using errcode = '22023', message = 'fragment_hash_mismatch';
  end if;
  for v_change in select value from jsonb_array_elements(p_changes) loop
    if jsonb_typeof(v_change) is distinct from 'object'
       or not private.is_uuid(v_change->>'change_id')
       or not private.is_uuid(v_change->>'row_id') then
      raise exception using errcode = '22023', message = 'invalid_change';
    end if;
    v_table := v_change->>'table';
    if v_table is null or v_table <> all(array['businesses','customers','services','orders',
        'order_items','payments','savings_entries','order_events','expense_categories','expenses',
        'receipt_settings','devices']) then
      raise exception using errcode = '42501', message = 'table_not_allowed';
    end if;
    v_op := v_change->>'op';
    if v_op is null or v_op not in ('upsert','delete') then
      raise exception using errcode = '22023', message = 'invalid_change';
    end if;
    if coalesce((v_change->>'schema_version')::integer,0)
       < (select min_schema_version from public.app_config) then
      raise exception using errcode = 'P0001', message = 'schema_too_old';
    end if;
    if v_op = 'upsert' and jsonb_typeof(v_change->'payload') is distinct from 'object' then
      raise exception using errcode = '22023', message = 'invalid_payload';
    end if;
  end loop;
  if (select count(distinct value->>'change_id') from jsonb_array_elements(p_changes))
     <> jsonb_array_length(p_changes) then
    raise exception using errcode = '22023', message = 'duplicate_change';
  end if;

  perform pg_advisory_xact_lock(hashtextextended('laurum_sync:' || own::text, 0));

  select * into v_group from private.sync_groups
    where owner_id = own and group_id = p_group_id;
  if found then
    if v_group.group_hash <> p_group_hash or v_group.fragment_count <> p_fragment_count then
      raise exception using errcode = '22023', message = 'group_mismatch';
    end if;
    if v_group.status <> 'staged' then return v_group.receipt; end if;
    if exists(select from private.sync_fragments f where f.owner_id = own
        and f.group_id = p_group_id and f.fragment_index = p_fragment_index) then
      if (select f.fragment_hash from private.sync_fragments f where f.owner_id = own
          and f.group_id = p_group_id and f.fragment_index = p_fragment_index) <> v_fragment_hash then
        raise exception using errcode = '22023', message = 'fragment_mismatch';
      end if;
    else
      insert into private.sync_fragments(owner_id,group_id,fragment_index,fragment_hash,changes)
        values(own,p_group_id,p_fragment_index,v_fragment_hash,p_changes);
    end if;
  else
    insert into private.sync_groups(owner_id,group_id,group_hash,fragment_count,status)
      values(own,p_group_id,p_group_hash,p_fragment_count,'staged');
    insert into private.sync_fragments(owner_id,group_id,fragment_index,fragment_hash,changes)
      values(own,p_group_id,p_fragment_index,v_fragment_hash,p_changes);
  end if;

  select count(*)::integer, coalesce(sum(jsonb_array_length(changes)),0)::integer
    into v_received, v_total
    from private.sync_fragments where owner_id = own and group_id = p_group_id;
  if v_received < p_fragment_count then
    return jsonb_build_object('group_id',p_group_id,'status','staged','received',v_received,
      'expected',p_fragment_count,'results','[]'::jsonb);
  end if;

  select coalesce(jsonb_agg(e.elem order by f.fragment_index, e.ord), '[]'::jsonb)
    into v_full
    from private.sync_fragments f
    cross join lateral jsonb_array_elements(f.changes) with ordinality as e(elem, ord)
    where f.owner_id = own and f.group_id = p_group_id;
  select count(*)::integer, count(distinct value->>'change_id')::integer into v_total, v_distinct
    from jsonb_array_elements(v_full);

  v_code := null;
  if v_total = 0 or v_total > 5000 then
    v_code := 'group_too_large';
  elsif v_total <> v_distinct then
    v_code := 'duplicate_change';
  else
    v_group_hash := private.sha256_hex(private.canonical_json(v_full));
    if v_group_hash <> p_group_hash then v_code := 'group_hash_mismatch'; end if;
  end if;

  if v_code is null then
    begin
      for v_change in select value from jsonb_array_elements(v_full) loop
        v_table := v_change->>'table';
        v_op := v_change->>'op';
        v_row := (v_change->>'row_id')::uuid;
        v_change_id := (v_change->>'change_id')::uuid;
        v_stamp := null;
        v_append_only := v_table = any(array['payments','savings_entries','order_events']);
        execute format('select to_jsonb(r) from public.%I r where id=$1 and owner_id=$2',v_table)
          into v_existing using v_row, own;
        if v_op = 'delete' then
          if v_append_only then
            raise exception using errcode = '23514', message = 'append_only';
          end if;
          if v_existing is null then
            raise exception using errcode = '23503', message = 'missing_reference';
          end if;
          if v_existing->>'deleted_at' is null then
            execute format('update public.%I set deleted_at=clock_timestamp()
              where id=$1 and owner_id=$2 returning updated_at',v_table)
              into v_stamp using v_row, own;
          else
            v_stamp := (v_existing->>'updated_at')::timestamptz;
          end if;
        else
          v_payload := v_change->'payload';
          if jsonb_typeof(v_payload) is distinct from 'object'
             or (v_payload->>'id')::uuid is distinct from v_row then
            raise exception using errcode = '22023', message = 'invalid_payload';
          end if;
          v_payload := (v_payload - 'owner_id' - 'updated_at') || jsonb_build_object('owner_id',own);
          if exists(select from jsonb_object_keys(v_payload) k where not exists(
            select from pg_catalog.pg_attribute a
            where a.attrelid = format('public.%I',v_table)::regclass
            and a.attname = k and a.attnum > 0 and not a.attisdropped)) then
            raise exception using errcode = '22023', message = 'unknown_field';
          end if;
          if v_existing is not null then
            execute format('select to_jsonb(jsonb_populate_record(jsonb_populate_record(
              null::public.%I,$1),$2))',v_table)
              into v_normalized using v_existing, v_payload;
            if (v_normalized - 'updated_at' - 'created_at')
               = (v_existing - 'updated_at' - 'created_at') then
              v_stamp := (v_existing->>'updated_at')::timestamptz;
            elsif v_append_only then
              raise exception using errcode = '23514', message = 'append_only';
            else
              select string_agg(format('%I=p.%I',key,key),',') into v_assignments
                from jsonb_object_keys(v_payload) key
                where key not in ('id','owner_id','created_at');
              execute format('update public.%I r set %s from jsonb_populate_record(
                null::public.%I,$1) p where r.id=$2 and r.owner_id=$3 returning r.updated_at',
                v_table,v_assignments,v_table)
                into v_stamp using v_payload, v_row, own;
            end if;
          else
            select string_agg(format('%I',key),','),
              string_agg(format('p.%I',key),',') into v_cols, v_projection
              from jsonb_object_keys(v_payload) key;
            execute format('insert into public.%I(%s) select %s from jsonb_populate_record(
              null::public.%I,$1) p returning updated_at',v_table,v_cols,v_projection,v_table)
              into v_stamp using v_payload;
          end if;
        end if;
        if v_table = 'orders' then
          v_order_ids := array_append(v_order_ids, v_row);
        elsif v_table = 'payments' and (v_change->'payload'->>'order_id') is not null then
          v_order_ids := array_append(v_order_ids, (v_change->'payload'->>'order_id')::uuid);
        end if;
        v_results := v_results || jsonb_build_array(jsonb_build_object(
          'change_id',v_change_id,'table',v_table,'row_id',v_row,'status','ok',
          'updated_at',private.iso6(v_stamp)));
      end loop;
      perform private.validate_sync_orders(own, v_order_ids);
    exception when others then
      v_code := private.sync_error_code(SQLSTATE, SQLERRM);
      v_results := coalesce((
        select jsonb_agg(jsonb_build_object(
          'change_id',(e->>'change_id')::uuid,'table',e->>'table',
          'row_id',(e->>'row_id')::uuid,'status','ditolak','code',v_code,
          'updated_at',null) order by ord)
        from jsonb_array_elements(v_full) with ordinality as x(e,ord)), '[]'::jsonb);
    end;
  else
    v_results := coalesce((
      select jsonb_agg(jsonb_build_object(
        'change_id',(e->>'change_id')::uuid,'table',e->>'table',
        'row_id',(e->>'row_id')::uuid,'status','ditolak','code',v_code,
        'updated_at',null) order by ord)
      from jsonb_array_elements(v_full) with ordinality as x(e,ord)), '[]'::jsonb);
  end if;

  if v_code is null then
    v_receipt := jsonb_build_object('group_id',p_group_id,'status','committed','results',v_results);
  else
    v_receipt := jsonb_build_object('group_id',p_group_id,'status','rejected','code',v_code,
      'results',v_results);
  end if;
  delete from private.sync_fragments where owner_id = own and group_id = p_group_id;
  update private.sync_groups set status = case when v_code is null then 'committed' else 'rejected' end,
    receipt = v_receipt, committed_at = clock_timestamp()
    where owner_id = own and group_id = p_group_id;
  return v_receipt;
end $$;
revoke all on function public.sync_push(jsonb,uuid,text,integer,integer,text) from public, anon;
grant execute on function public.sync_push(jsonb,uuid,text,integer,integer,text) to authenticated;

-- 5. Owner-serialized pull ----------------------------------------------------
create function public.sync_pull(
  p_table text,
  p_cursor_updated_at timestamptz default null,
  p_cursor_id uuid default null,
  p_limit integer default 500
) returns jsonb language plpgsql security invoker set search_path = '' as $$
declare
  own uuid := auth.uid(); v_limit integer; v_rows jsonb; v_count integer;
  v_cursor timestamptz; v_cursor_id uuid;
begin
  if own is null then raise exception using errcode = '42501', message = 'authentication_required'; end if;
  if p_table is null or p_table <> all(array['businesses','customers','services','orders',
      'order_items','payments','savings_entries','order_events','expense_categories','expenses',
      'receipt_settings','devices','entitlements']) then
    raise exception using errcode = '42501', message = 'table_not_allowed';
  end if;
  v_limit := least(greatest(coalesce(p_limit,500),1),500);
  perform pg_advisory_xact_lock(hashtextextended('laurum_sync:' || own::text, 0));
  execute format('select coalesce(jsonb_agg(private.wire_row(to_jsonb(r)) order by r.updated_at, r.id),
      ''[]''::jsonb), count(*)::integer from (select * from public.%I r where r.owner_id = $1
      and ($2 is null or (r.updated_at, r.id) > ($2, coalesce($3,
        ''00000000-0000-0000-0000-000000000000''::uuid)))
      order by r.updated_at, r.id limit $4) r', p_table)
    into v_rows, v_count using own, p_cursor_updated_at, p_cursor_id, v_limit;
  if v_count = 0 then
    v_cursor := p_cursor_updated_at; v_cursor_id := p_cursor_id;
  else
    v_cursor := (v_rows->-1->>'updated_at')::timestamptz;
    v_cursor_id := (v_rows->-1->>'id')::uuid;
  end if;
  return jsonb_build_object('table',p_table,'rows',v_rows,
    'next_cursor',jsonb_build_object('updated_at',private.iso6(v_cursor),'id',v_cursor_id),
    'has_more',v_count = v_limit);
end $$;
revoke all on function public.sync_pull(text,timestamptz,uuid,integer) from public, anon;
grant execute on function public.sync_pull(text,timestamptz,uuid,integer) to authenticated;

-- 6. Grants and account cleanup ----------------------------------------------
grant usage on schema private to authenticated, service_role;
grant select, insert, update, delete on private.owner_clock, private.sync_groups,
  private.sync_fragments to authenticated, service_role;
grant select, insert, update, delete on private.owner_clock, private.sync_groups,
  private.sync_fragments to laurum_account_deleter;
grant execute on function private.next_owner_timestamp(uuid), private.canonical_json(jsonb),
  private.sha256_hex(text), private.iso6(timestamptz), private.wire_row(jsonb),
  private.sync_error_code(text,text), private.validate_sync_orders(uuid,uuid[])
  to authenticated, service_role;

-- Recreate both cleanup functions so the narrow owner can also clear staging/receipts.
-- CREATE on the private schema is needed only while the new owner is assigned.
grant usage, create on schema private to laurum_account_deleter;
drop function public.delete_my_account();
drop function private.purge_my_rows();
create function private.purge_my_rows() returns void language plpgsql security definer
set search_path = '' as $$
declare own uuid := coalesce(nullif(current_setting('request.jwt.claim.sub',true),''),
  nullif(current_setting('request.jwt.claims',true),'')::jsonb->>'sub')::uuid; t text;
begin
  if own is null then raise exception using errcode = '42501', message = 'authentication_required'; end if;
  foreach t in array array['savings_entries','payments','order_events','order_items','orders','expenses',
    'expense_categories','customers','services','receipt_settings','businesses','devices','entitlements'] loop
    execute format('delete from public.%I where owner_id=$1',t) using own;
  end loop;
  delete from private.sync_fragments where owner_id = own;
  delete from private.sync_groups where owner_id = own;
  delete from private.owner_clock where owner_id = own;
end $$;
alter function private.purge_my_rows() owner to laurum_account_deleter;
revoke create on schema private from laurum_account_deleter;
revoke all on function private.purge_my_rows() from public, anon;
grant execute on function private.purge_my_rows() to authenticated;
create function public.delete_my_account() returns void language sql security invoker
set search_path = '' as $$ select private.purge_my_rows(); $$;
revoke all on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;

-- Wire schema 5 is required from now on.
update public.app_config set min_schema_version = 5;
