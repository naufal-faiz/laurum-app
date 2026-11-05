-- Authenticated invoker: RLS remains active, including inside each savepoint.
create function public.sync_push(changes jsonb) returns jsonb language plpgsql
security invoker set search_path = '' as $$
declare
  change jsonb; payload jsonb; existing jsonb; normalized jsonb; result jsonb := '[]';
  t text; operation text; row_id uuid; cols text; projection text; assignments text;
  stamp timestamptz; own uuid := auth.uid(); append_only boolean;
begin
  if own is null then raise exception using errcode = '42501', message = 'authentication_required'; end if;
  if jsonb_typeof(changes) is distinct from 'array' then
    raise exception using errcode = '22023', message = 'changes_must_be_array';
  end if;
  if jsonb_array_length(changes) > 50 then
    raise exception using errcode = '22023', message = 'batch_too_large';
  end if;
  for change in select value from jsonb_array_elements(changes) loop
    t := change->>'table'; row_id := null; stamp := null;
    begin
      if coalesce((change->>'schema_version')::integer,0) < (select min_schema_version from public.app_config) then
        raise exception using errcode = 'P0001', message = 'schema_too_old';
      end if;
      if t is null or t <> all(array['businesses','customers','services','orders','order_items','payments',
        'savings_entries','order_events','expense_categories','expenses','receipt_settings','devices']) then
        raise exception using errcode = '42501', message = 'table_not_allowed';
      end if;
      row_id := (change->>'row_id')::uuid;
      operation := change->>'op';
      if row_id is null or operation is null or operation not in ('upsert','delete') then
        raise exception using errcode = '22023', message = 'invalid_change';
      end if;
      append_only := t = any(array['payments','savings_entries','order_items','order_events']);
      -- Serializes duplicate RPC retries without needing UPDATE privileges on append-only rows.
      perform pg_advisory_xact_lock(hashtextextended(t || row_id::text,0));
      execute format('select to_jsonb(r) from public.%I r where id=$1 and owner_id=$2',t)
        into existing using row_id, own;
      if operation = 'delete' then
        if append_only then raise exception using errcode = '23514', message = 'append_only'; end if;
        if existing is null then raise exception using errcode = '23503', message = 'missing_row'; end if;
        if existing->>'deleted_at' is null then
          execute format('update public.%I set deleted_at=clock_timestamp() where id=$1 and owner_id=$2 returning updated_at',t)
            into stamp using row_id,own;
        else stamp := (existing->>'updated_at')::timestamptz; end if;
      else
        payload := change->'payload';
        if jsonb_typeof(payload) is distinct from 'object' or (payload->>'id')::uuid is distinct from row_id then
          raise exception using errcode = '22023', message = 'invalid_payload';
        end if;
        payload := (payload - 'owner_id' - 'updated_at') || jsonb_build_object('owner_id',own);
        if exists(select from jsonb_object_keys(payload) k where not exists(
          select from pg_catalog.pg_attribute a where a.attrelid = format('public.%I',t)::regclass
          and a.attname = k and a.attnum > 0 and not a.attisdropped)) then
          raise exception using errcode = '22023', message = 'unknown_field';
        end if;
        if existing is not null then
          execute format('select to_jsonb(jsonb_populate_record(jsonb_populate_record(null::public.%I,$1),$2))',t)
            into normalized using existing,payload;
          -- Server preserves creation time on updates; compare canonical PostgreSQL values.
          if (normalized - 'updated_at' - 'created_at') = (existing - 'updated_at' - 'created_at') then
            stamp := (existing->>'updated_at')::timestamptz;
          elsif append_only then
            raise exception using errcode = '23514', message = 'append_only';
          else
            select string_agg(format('%I=p.%I',key,key),',') into assignments
              from jsonb_object_keys(payload) key where key not in ('id','owner_id','created_at');
            execute format('update public.%I r set %s from jsonb_populate_record(null::public.%I,$1) p
              where r.id=$2 and r.owner_id=$3 returning r.updated_at',t,assignments,t)
              into stamp using payload,row_id,own;
          end if;
        else
          select string_agg(format('%I',key),','), string_agg(format('p.%I',key),',')
            into cols,projection from jsonb_object_keys(payload) key;
          execute format('insert into public.%I(%s) select %s from jsonb_populate_record(null::public.%I,$1) p
            returning updated_at',t,cols,projection,t) into stamp using payload;
        end if;
      end if;
      result := result || jsonb_build_array(jsonb_build_object('table',t,'row_id',row_id,'status','ok','updated_at',stamp));
    exception
      when unique_violation then
        result := result || jsonb_build_array(jsonb_build_object('table',t,'row_id',row_id,'status','konflik','code','unique_conflict','updated_at',null));
      when others then
        result := result || jsonb_build_array(jsonb_build_object('table',t,'row_id',row_id,'status','ditolak',
          'code',case when SQLSTATE = 'P0001' then 'schema_too_old' else 'invalid_change' end,'updated_at',null));
    end;
  end loop;
  return result;
end $$;
revoke all on function public.sync_push(jsonb) from public, anon;
grant execute on function public.sync_push(jsonb) to authenticated;

-- Narrow NOLOGIN role: no BYPASSRLS, no membership for client/service roles.
-- Only this role may delete immutable ledgers, and every DELETE is still owner-scoped.
-- PostgreSQL 17 CREATEROLE does not imply SET ROLE for the migration login.
grant laurum_account_deleter to postgres with set true;
grant laurum_account_deleter to postgres with inherit false;
grant usage, create on schema private to laurum_account_deleter;
create function private.purge_my_rows() returns void language plpgsql security definer
set search_path = '' as $$
-- Same verified request claims used by auth.uid(). The NOLOGIN role deliberately
-- has no access to the managed auth schema; policies already bind auth.uid by OID.
declare own uuid := coalesce(nullif(current_setting('request.jwt.claim.sub',true),''),
  nullif(current_setting('request.jwt.claims',true),'')::jsonb->>'sub')::uuid; t text;
begin
  if own is null then raise exception using errcode = '42501', message = 'authentication_required'; end if;
  foreach t in array array['savings_entries','payments','order_events','order_items','orders','expenses',
    'expense_categories','customers','services','receipt_settings','businesses','devices','entitlements'] loop
    execute format('delete from public.%I where owner_id=$1',t) using own;
  end loop;
end $$;
alter function private.purge_my_rows() owner to laurum_account_deleter;
revoke create on schema private from laurum_account_deleter;
revoke all on function private.purge_my_rows() from public, anon;
grant usage on schema private to authenticated;
grant execute on function private.purge_my_rows() to authenticated;
create function public.delete_my_account() returns void language sql security invoker
set search_path = '' as $$ select private.purge_my_rows(); $$;
revoke all on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;
