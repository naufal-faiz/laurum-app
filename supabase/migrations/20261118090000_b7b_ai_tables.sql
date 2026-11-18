-- B7b: AI WhatsApp tables (ai_proposals, wa_connections), guards, RLS and RPCs.
-- Additive only: no DROP/TRUNCATE and no change to existing tables. Contract: docs/plans/B7a-skema.md.
-- Wire schema stays 5; clients that do not know these tables never ask for them.

create table public.ai_proposals (
  id uuid primary key,
  owner_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  status text not null default 'menunggu'
    check (status in ('menunggu','disetujui','ditolak','ditutup_otomatis')),
  -- Text is cleared by the retention job only after a decision.
  source_text text check (source_text is null or char_length(source_text) between 1 and 2000),
  customer_name text not null default '' check (char_length(customer_name) <= 120),
  phone text not null default '' check (phone = '' or phone ~ '^[0-9]{6,15}$'),
  address text not null default '' check (char_length(address) <= 300),
  service_id uuid,
  cancel_requested boolean not null default false,
  uncertain_address boolean not null default false,
  customer_id uuid,
  order_id uuid,
  wa_message_id text not null check (char_length(wa_message_id) between 1 and 200),
  chat_id text not null check (char_length(chat_id) between 1 and 100),
  confidence numeric(3,2) check (confidence is null or (confidence >= 0 and confidence <= 1)),
  received_at timestamptz not null,
  decided_at timestamptz,
  unique(owner_id,id),
  unique(owner_id,wa_message_id),
  foreign key(owner_id,service_id) references public.services(owner_id,id),
  constraint proposal_text_or_decided check (source_text is not null or decided_at is not null)
);
create index ai_proposals_pull on public.ai_proposals(owner_id,updated_at,id);
create index ai_proposals_status on public.ai_proposals(owner_id,status);
create index ai_proposals_retention on public.ai_proposals(owner_id,decided_at)
  where source_text is not null;

create table public.wa_connections (
  id uuid primary key,
  owner_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  instance_id text not null unique check (char_length(instance_id) between 1 and 120),
  status text not null default 'belum'
    check (status in ('belum','menunggu','terhubung','terputus')),
  connected_at timestamptz,
  read_messages boolean not null default true,
  ignore_groups boolean not null default true,
  detect_cancellation boolean not null default true,
  unique(owner_id,id),
  unique(owner_id)
);
create index wa_connections_pull on public.wa_connections(owner_id,updated_at,id);

-- RLS: client reads its own proposals and may only decide them; connections are read-only there.
alter table public.ai_proposals enable row level security;
revoke all on public.ai_proposals from anon, authenticated;
grant select, update on public.ai_proposals to authenticated;
grant select, delete on public.ai_proposals to laurum_account_deleter;
grant select, insert, update, delete on public.ai_proposals to service_role;
create policy owner_read on public.ai_proposals for select to authenticated, laurum_account_deleter
  using(owner_id = (select auth.uid()));
create policy owner_update on public.ai_proposals for update to authenticated
  using(owner_id = (select auth.uid())) with check(owner_id = (select auth.uid()));
create policy account_cleanup on public.ai_proposals for delete to laurum_account_deleter
  using(owner_id = (select auth.uid()));

alter table public.wa_connections enable row level security;
revoke all on public.wa_connections from anon, authenticated;
grant select on public.wa_connections to authenticated;
grant select, delete on public.wa_connections to laurum_account_deleter;
grant select, insert, update, delete on public.wa_connections to service_role;
create policy owner_read on public.wa_connections for select to authenticated, laurum_account_deleter
  using(owner_id = (select auth.uid()));
create policy account_cleanup on public.wa_connections for delete to laurum_account_deleter
  using(owner_id = (select auth.uid()));

create trigger stamp_record before insert or update on public.ai_proposals
  for each row execute function private.stamp_record();
create trigger stamp_record before insert or update on public.wa_connections
  for each row execute function private.stamp_record();

-- A decision is the only client write: menunggu -> disetujui/ditolak, with the owner's edits.
-- Content produced by the worker/LLM stays immutable; retries with identical rows never reach here
-- because sync_push returns the existing stamp for an unchanged row.
create function private.guard_ai_proposal() returns trigger language plpgsql
set search_path = '' as $$
declare v_role text := coalesce(auth.role(), '');
begin
  if TG_OP = 'INSERT' then
    if v_role not in ('', 'service_role') then
      raise exception using errcode = '42501', message = 'insert_not_allowed';
    end if;
    if new.status <> 'menunggu' or new.decided_at is not null then
      raise exception using errcode = '23514', message = 'invalid_insert';
    end if;
    return new;
  end if;
  if new.id is distinct from old.id or new.owner_id is distinct from old.owner_id
     or new.wa_message_id is distinct from old.wa_message_id
     or new.chat_id is distinct from old.chat_id
     or new.confidence is distinct from old.confidence
     or new.received_at is distinct from old.received_at
     or new.cancel_requested is distinct from old.cancel_requested
     or new.uncertain_address is distinct from old.uncertain_address
     or new.customer_id is distinct from old.customer_id then
    raise exception using errcode = '23514', message = 'immutable_content';
  end if;
  if v_role = 'service_role' then
    if new.status is distinct from old.status then
      if old.status <> 'menunggu' or new.status <> 'ditutup_otomatis' then
        raise exception using errcode = '23514', message = 'invalid_transition';
      end if;
      new.decided_at := clock_timestamp();
    end if;
    if new.source_text is distinct from old.source_text and old.decided_at is null then
      raise exception using errcode = '23514', message = 'text_retained';
    end if;
    new.decided_at := coalesce(new.decided_at, old.decided_at);
    if new.customer_name is distinct from old.customer_name
       or new.phone is distinct from old.phone
       or new.address is distinct from old.address
       or new.service_id is distinct from old.service_id
       or new.order_id is distinct from old.order_id then
      raise exception using errcode = '23514', message = 'immutable_content';
    end if;
    return new;
  end if;
  if new.deleted_at is distinct from old.deleted_at then
    raise exception using errcode = '23514', message = 'delete_not_allowed';
  end if;
  if old.status <> 'menunggu' then
    raise exception using errcode = '23514', message = 'final_proposal';
  end if;
  if new.status not in ('disetujui','ditolak') then
    raise exception using errcode = '23514', message = 'invalid_transition';
  end if;
  if new.source_text is distinct from old.source_text then
    raise exception using errcode = '23514', message = 'immutable_content';
  end if;
  new.decided_at := clock_timestamp();
  return new;
end $$;
revoke all on function private.guard_ai_proposal() from public;
create trigger guard_ai_proposal before insert or update on public.ai_proposals
  for each row execute function private.guard_ai_proposal();

-- instance_id is the isolation key from AI-4a: it never changes after pairing.
create function private.guard_wa_connection() returns trigger language plpgsql
set search_path = '' as $$
begin
  if new.id is distinct from old.id or new.owner_id is distinct from old.owner_id
     or (old.instance_id is not null and new.instance_id is distinct from old.instance_id) then
    raise exception using errcode = '23514', message = 'immutable_identity';
  end if;
  return new;
end $$;
revoke all on function private.guard_wa_connection() from public;
create trigger guard_wa_connection before update on public.wa_connections
  for each row execute function private.guard_wa_connection();

-- Worker ingress: owner comes from the paired instance, never from the payload (AI-4a/AI-4c).
create function public.ingest_ai_proposal(
  p_instance_id text,
  p_wa_message_id text,
  p_chat_id text,
  p_received_at timestamptz,
  p_payload jsonb
) returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  v_conn public.wa_connections%rowtype;
  v_invalid jsonb := jsonb_build_object('code','invalid');
  v_source text; v_name text; v_phone text; v_address text; v_hint text; v_order text;
  v_service uuid; v_order_id uuid; v_confidence numeric(3,2); v_id uuid := gen_random_uuid();
  v_inserted integer;
begin
  if coalesce(auth.role(), '') not in ('', 'service_role') then
    raise exception using errcode = '42501', message = 'service_role_required';
  end if;
  if p_instance_id is null then return jsonb_build_object('code','unknown_instance'); end if;
  select * into v_conn from public.wa_connections c
    where c.instance_id = p_instance_id and c.deleted_at is null;
  if not found then return jsonb_build_object('code','unknown_instance'); end if;
  if p_wa_message_id is null or char_length(p_wa_message_id) not between 1 and 200
     or p_chat_id is null or char_length(p_chat_id) not between 1 and 100
     or p_received_at is null or jsonb_typeof(p_payload) is distinct from 'object' then
    return v_invalid;
  end if;
  if exists(select from jsonb_object_keys(p_payload) k
      where k <> all(array['source_text','customer_name','phone','address','service_hint',
        'uncertain_address','cancel_requested','confidence','order_id'])) then
    return v_invalid;
  end if;
  if coalesce(jsonb_typeof(p_payload->'uncertain_address'),'null') not in ('boolean','null')
     or coalesce(jsonb_typeof(p_payload->'cancel_requested'),'null') not in ('boolean','null')
     or coalesce(jsonb_typeof(p_payload->'confidence'),'null') not in ('number','null')
     or coalesce(jsonb_typeof(p_payload->'order_id'),'null') not in ('string','null') then
    return v_invalid;
  end if;
  v_source := btrim(coalesce(p_payload->>'source_text',''));
  v_name := btrim(coalesce(p_payload->>'customer_name',''));
  v_address := btrim(coalesce(p_payload->>'address',''));
  v_hint := btrim(coalesce(p_payload->>'service_hint',''));
  v_phone := regexp_replace(coalesce(p_payload->>'phone',''), '[^0-9]', '', 'g');
  if left(v_phone,2) = '62' then v_phone := '0' || substr(v_phone,3); end if;
  if v_source = '' or char_length(v_source) > 2000 or char_length(v_name) > 120
     or char_length(v_address) > 300 or (v_phone <> '' and v_phone !~ '^[0-9]{6,15}$') then
    return v_invalid;
  end if;
  if jsonb_typeof(p_payload->'confidence') = 'number' then
    v_confidence := round((p_payload->>'confidence')::numeric, 2);
    if v_confidence < 0 or v_confidence > 1 then return v_invalid; end if;
  end if;
  v_order := p_payload->>'order_id';
  if v_order is not null then
    if not private.is_uuid(v_order) then return v_invalid; end if;
    select o.id into v_order_id from public.orders o
      where o.id = v_order::uuid and o.owner_id = v_conn.owner_id and o.deleted_at is null;
    if v_order_id is null then return v_invalid; end if;
  end if;
  if v_hint <> '' then
    select s.id into v_service from public.services s
      where s.owner_id = v_conn.owner_id and s.deleted_at is null and s.is_active
        and lower(btrim(s.name)) = lower(v_hint)
      order by s.sort_order, s.id limit 1;
  end if;
  if not v_conn.read_messages then return jsonb_build_object('code','ignored'); end if;
  if v_conn.connected_at is not null and p_received_at < v_conn.connected_at then
    return jsonb_build_object('code','ignored');
  end if;
  insert into public.ai_proposals(id,owner_id,status,source_text,customer_name,phone,address,
    service_id,cancel_requested,uncertain_address,order_id,wa_message_id,chat_id,confidence,
    received_at)
  values (v_id,v_conn.owner_id,'menunggu',v_source,v_name,v_phone,v_address,v_service,
    coalesce((p_payload->>'cancel_requested')::boolean,false),
    coalesce((p_payload->>'uncertain_address')::boolean,false),
    v_order_id,p_wa_message_id,p_chat_id,v_confidence,p_received_at)
  on conflict (owner_id,wa_message_id) do nothing;
  get diagnostics v_inserted = row_count;
  if v_inserted = 0 then return jsonb_build_object('code','duplicate'); end if;
  return jsonb_build_object('code','created','proposal_id',v_id);
end $$;

-- Worker context for the prompt; owner identity is deliberately not returned (AI-4b).
create function public.get_ai_context(p_instance_id text) returns jsonb
language plpgsql security definer set search_path = '' as $$
declare v_conn public.wa_connections%rowtype; v_services jsonb;
begin
  if coalesce(auth.role(), '') not in ('', 'service_role') then
    raise exception using errcode = '42501', message = 'service_role_required';
  end if;
  select * into v_conn from public.wa_connections c
    where c.instance_id = p_instance_id and c.deleted_at is null;
  if not found then return jsonb_build_object('code','unknown_instance'); end if;
  select coalesce(jsonb_agg(jsonb_build_object('id',s.id,'name',s.name,'kind',s.kind)
      order by s.sort_order, s.name), '[]'::jsonb) into v_services
    from public.services s
    where s.owner_id = v_conn.owner_id and s.deleted_at is null and s.is_active;
  return jsonb_build_object('code','ok','connected_at',private.iso6(v_conn.connected_at),
    'read_messages',v_conn.read_messages,'ignore_groups',v_conn.ignore_groups,
    'detect_cancellation',v_conn.detect_cancellation,'services',v_services);
end $$;

create function public.set_wa_connection_status(p_instance_id text, p_status text)
returns jsonb language plpgsql security definer set search_path = '' as $$
begin
  if coalesce(auth.role(), '') not in ('', 'service_role') then
    raise exception using errcode = '42501', message = 'service_role_required';
  end if;
  if p_status is null or p_status not in ('belum','menunggu','terhubung','terputus') then
    return jsonb_build_object('code','invalid');
  end if;
  update public.wa_connections c
    set status = p_status,
      connected_at = case when p_status = 'terhubung' then clock_timestamp() else c.connected_at end
    where c.instance_id = p_instance_id and c.deleted_at is null;
  if not found then return jsonb_build_object('code','unknown_instance'); end if;
  return jsonb_build_object('code','updated');
end $$;

-- Owner-side settings: the client never writes wa_connections directly (no update policy).
create function public.set_ai_settings(
  p_read_messages boolean,
  p_ignore_groups boolean,
  p_detect_cancellation boolean
) returns jsonb language plpgsql security definer set search_path = '' as $$
declare own uuid := auth.uid();
begin
  if own is null then raise exception using errcode = '42501', message = 'authentication_required'; end if;
  if p_read_messages is null or p_ignore_groups is null or p_detect_cancellation is null then
    return jsonb_build_object('code','invalid');
  end if;
  update public.wa_connections c
    set read_messages = p_read_messages, ignore_groups = p_ignore_groups,
      detect_cancellation = p_detect_cancellation
    where c.owner_id = own and c.deleted_at is null;
  if not found then return jsonb_build_object('code','no_connection'); end if;
  return jsonb_build_object('code','saved');
end $$;

-- sync_push/sync_pull reproduced from b2a with the two new tables added.
create or replace function public.sync_push(
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
        'receipt_settings','devices','ai_proposals']) then
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

create or replace function public.sync_pull(
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
      'receipt_settings','devices','ai_proposals','wa_connections','entitlements']) then
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

-- Wire: ai_proposals joins push and pull; wa_connections is pull-only (written by RPC/Edge only).
revoke all on function public.sync_push(jsonb,uuid,text,integer,integer,text) from public, anon;
grant execute on function public.sync_push(jsonb,uuid,text,integer,integer,text) to authenticated;
revoke all on function public.sync_pull(text,timestamptz,uuid,integer) from public, anon;
grant execute on function public.sync_pull(text,timestamptz,uuid,integer) to authenticated;

revoke all on function public.ingest_ai_proposal(text,text,text,timestamptz,jsonb)
  from public, anon, authenticated;
grant execute on function public.ingest_ai_proposal(text,text,text,timestamptz,jsonb) to service_role;
revoke all on function public.get_ai_context(text) from public, anon, authenticated;
grant execute on function public.get_ai_context(text) to service_role;
revoke all on function public.set_wa_connection_status(text,text) from public, anon, authenticated;
grant execute on function public.set_wa_connection_status(text,text) to service_role;
revoke all on function public.set_ai_settings(boolean,boolean,boolean) from public, anon;
grant execute on function public.set_ai_settings(boolean,boolean,boolean) to authenticated;

-- Account cleanup must also clear the two new tables (ai_proposals first: FK to services).
grant usage, create on schema private to laurum_account_deleter;
drop function public.delete_my_account();
drop function private.purge_my_rows();
create function private.purge_my_rows() returns void language plpgsql security definer
set search_path = '' as $$
declare own uuid := coalesce(nullif(current_setting('request.jwt.claim.sub',true),''),
  nullif(current_setting('request.jwt.claims',true),'')::jsonb->>'sub')::uuid; t text;
begin
  if own is null then raise exception using errcode = '42501', message = 'authentication_required'; end if;
  foreach t in array array['ai_proposals','wa_connections','savings_entries','payments',
    'order_events','order_items','orders','expenses','expense_categories','customers','services',
    'receipt_settings','businesses','devices','entitlements'] loop
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
