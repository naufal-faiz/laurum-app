-- B7d conversation addendum, approved 20 Nov 2026. New additive migration only.
-- Never run against cloud from an agent. No raw chat archive and no money writes.
create function private.ai_phone(value text) returns text language sql immutable set search_path='' as $$
  select regexp_replace(regexp_replace(coalesce(value,''),'[^0-9]','','g'),'^62','0');
$$;
create function private.ai_draft_valid(value jsonb) returns boolean language sql immutable set search_path='' as $$
 select case when jsonb_typeof(value) is distinct from 'object' then false else coalesce(not exists(select from jsonb_object_keys(value) k
   where k<>all(array['customer_name','address','service_hint','uncertain_address','confidence']))
   and coalesce(jsonb_typeof(value->'customer_name'),'null') in ('string','null')
   and char_length(coalesce(value->>'customer_name',''))<=120
   and coalesce(jsonb_typeof(value->'address'),'null') in ('string','null')
   and char_length(coalesce(value->>'address',''))<=300
   and coalesce(jsonb_typeof(value->'service_hint'),'null') in ('string','null')
   and char_length(coalesce(value->>'service_hint',''))<=120
   and coalesce(jsonb_typeof(value->'uncertain_address'),'null') in ('boolean','null')
   and case when coalesce(jsonb_typeof(value->'confidence'),'null')='null' then true
     when jsonb_typeof(value->'confidence')='number' then (value->>'confidence')::numeric between 0 and 1
     else false end,false) end;
$$;
create function private.ai_proposal_draft(p public.ai_proposals) returns jsonb language sql stable set search_path='' as $$
 select jsonb_build_object('customer_name',p.customer_name,'address',p.address,
   'service_hint',coalesce((select name from public.services where id=p.service_id and owner_id=p.owner_id),''),
   'uncertain_address',p.uncertain_address,'confidence',p.confidence);
$$;
revoke all on function private.ai_phone(text),private.ai_draft_valid(jsonb),
 private.ai_proposal_draft(public.ai_proposals) from public;
create table public.ai_conversation_contexts (
 id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id),
 phone text not null check(phone ~ '^[0-9]{6,15}$'), chat_id text not null default '' check(char_length(chat_id)<=100),
 generation_id uuid not null default gen_random_uuid(), revision bigint not null default 0 check(revision>=0),
 draft_context jsonb not null default '{}' check(private.ai_draft_valid(draft_context)),
 proposal_id uuid, last_received_at timestamptz, created_at timestamptz not null default now(),
 updated_at timestamptz not null default now(), unique(owner_id,phone), unique(owner_id,id),
 foreign key(owner_id,proposal_id) references public.ai_proposals(owner_id,id)
);
create table public.ai_message_receipts (
 id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id),
 wa_message_id text not null check(char_length(wa_message_id) between 1 and 200), conversation_id uuid,
 received_at timestamptz not null, result_code text not null check(result_code in
 ('created','updated','closed','collected','ignored','stale')), proposal_id uuid,
 created_at timestamptz not null default now(), unique(owner_id,wa_message_id),
 foreign key(owner_id,conversation_id) references public.ai_conversation_contexts(owner_id,id),
 foreign key(owner_id,proposal_id) references public.ai_proposals(owner_id,id)
);
alter table public.ai_conversation_contexts enable row level security;
alter table public.ai_message_receipts enable row level security;
revoke all on public.ai_conversation_contexts,public.ai_message_receipts from public,anon,authenticated,service_role;
grant select on public.ai_conversation_contexts,public.ai_message_receipts to service_role;
grant select,delete on public.ai_conversation_contexts,public.ai_message_receipts to laurum_account_deleter;
create policy account_cleanup on public.ai_conversation_contexts for all to laurum_account_deleter
 using(owner_id=(select auth.uid())) with check(false);
create policy account_cleanup on public.ai_message_receipts for all to laurum_account_deleter
 using(owner_id=(select auth.uid())) with check(false);
create trigger stamp_record before insert or update on public.ai_conversation_contexts
 for each row execute function private.stamp_record();
do $$ begin
 if exists(select from public.ai_proposals where status='menunggu' and deleted_at is null and phone<>''
   group by owner_id,phone having count(*)>1) then
   raise exception 'B7d: duplicate pending sender proposals; resolve explicitly before migration';
 end if;
end $$;
create unique index ai_proposals_one_pending on public.ai_proposals(owner_id,phone)
 where status='menunggu' and deleted_at is null and phone<>'';

create or replace function private.guard_ai_proposal() returns trigger language plpgsql
set search_path = '' as $$
declare v_role text := coalesce(auth.role(), ''); v_cached_decision boolean := false;
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
  -- Only the validated ingress RPC may refresh a still-pending AI draft.
  if v_role='service_role' and current_setting('laurum.ai_ingest',true)='on'
      and old.status='menunggu' and new.status in ('menunggu','ditutup_otomatis') then
    if (to_jsonb(new)-array['updated_at','customer_name','address','service_id',
        'uncertain_address','confidence','status','decided_at']) is distinct from
       (to_jsonb(old)-array['updated_at','customer_name','address','service_id',
        'uncertain_address','confidence','status','decided_at']) then
      raise exception using errcode='23514',message='immutable_content';
    end if;
    new.decided_at:=case when new.status='ditutup_otomatis' then clock_timestamp() else old.decided_at end;
    return new;
  end if;
  -- A real owner-created order may have been accepted while the device was offline.
  v_cached_decision:=v_role='authenticated' and not old.cancel_requested and (
    (old.status in ('menunggu','ditutup_otomatis') and new.status='disetujui' and new.order_id is not null
      and exists(select 1 from public.orders o where o.id=new.order_id and o.owner_id=old.owner_id
        and o.proposal_id=old.id and o.source='whatsapp_ai' and o.deleted_at is null))
    or (old.status='menunggu' and new.status='ditolak'));

  if v_cached_decision then
    new.confidence:=old.confidence;
    new.uncertain_address:=old.uncertain_address;
    new.source_text:=old.source_text;
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
  if old.status <> 'menunggu' and not v_cached_decision then
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
-- Existing trigger keeps its identity and now calls the replaced function.

create function private.ingest_ai_proposal_legacy(
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


revoke all on function private.ingest_ai_proposal_legacy(text,text,text,timestamptz,jsonb) from public;
create function public.get_ai_conversation_context(p_instance_id text,p_phone text) returns jsonb
language plpgsql security definer set search_path='' as $$
declare base jsonb; own uuid; phone_key text:=private.ai_phone(p_phone);
 c public.ai_conversation_contexts%rowtype; p public.ai_proposals%rowtype; draft jsonb:='{}';
begin
 base:=public.get_ai_context(p_instance_id);
 if base->>'code'<>'ok' then return base; end if;
 if phone_key !~ '^[0-9]{6,15}$' then return jsonb_build_object('code','invalid'); end if;
 select owner_id into own from public.wa_connections where instance_id=p_instance_id and deleted_at is null;
 select * into c from public.ai_conversation_contexts where owner_id=own and phone=phone_key;
 select * into p from public.ai_proposals where owner_id=own and phone=phone_key
   and status='menunggu' and deleted_at is null;
 if p.id is null and c.proposal_id is not null then
   select * into p from public.ai_proposals where owner_id=own and id=c.proposal_id;
 end if;
 if p.id is null then draft:=coalesce(c.draft_context,'{}');
 elsif p.status='menunggu' then draft:=private.ai_proposal_draft(p);
 end if;
 return base||jsonb_build_object('draft_context',draft,'proposal_status',p.status,
   'conversation_generation',c.generation_id,'context_revision',coalesce(c.revision,0));
end $$;
revoke all on function public.get_ai_conversation_context(text,text) from public,anon,authenticated;
grant execute on function public.get_ai_conversation_context(text,text) to service_role;

create or replace function public.ingest_ai_proposal(p_instance_id text,p_wa_message_id text,
 p_chat_id text,p_received_at timestamptz,p_payload jsonb) returns jsonb
language plpgsql security definer set search_path='' as $$
declare
 conn public.wa_connections%rowtype; c public.ai_conversation_contexts%rowtype;
 p public.ai_proposals%rowtype; receipt public.ai_message_receipts%rowtype;
 action text; phone_key text; draft jsonb; merged jsonb; source_value text; code text;
 service_key uuid; legacy_order uuid; gen uuid; had_context boolean; expected_revision bigint;
 previous_flag text:=coalesce(current_setting('laurum.ai_ingest',true),'');
begin
 if coalesce(auth.role(),'') not in ('','service_role') then
   raise exception using errcode='42501',message='service_role_required';
 end if;
 select * into conn from public.wa_connections where instance_id=p_instance_id and deleted_at is null;
 if not found then return jsonb_build_object('code','unknown_instance'); end if;
 if jsonb_typeof(p_payload) is distinct from 'object' or p_wa_message_id is null
   or char_length(p_wa_message_id) not between 1 and 200 or p_chat_id is null
   or char_length(p_chat_id) not between 1 and 100 or p_received_at is null then
   return jsonb_build_object('code','invalid');
 end if;
 if exists(select from jsonb_object_keys(p_payload) k where k<>all(array['source_text','customer_name',
   'phone','address','service_hint','uncertain_address','cancel_requested','confidence','order_id',
   'action','draft_context','conversation_generation','context_revision'])) then
   return jsonb_build_object('code','invalid');
 end if;
 phone_key:=private.ai_phone(p_payload->>'phone');
 -- Existing callers without a sender retain the old, non-conversation contract.
 if phone_key='' and not(p_payload ?| array['action','draft_context','conversation_generation','context_revision']) then
   return private.ingest_ai_proposal_legacy(p_instance_id,p_wa_message_id,p_chat_id,p_received_at,p_payload);
 end if;
 action:=coalesce(p_payload->>'action','order');
 source_value:=btrim(coalesce(p_payload->>'source_text',''));
 if phone_key !~ '^[0-9]{6,15}$' or action not in ('order','collect','cancel','ignore')
   or coalesce(jsonb_typeof(p_payload->'phone'),'null')<>'string'
   or coalesce(jsonb_typeof(p_payload->'source_text'),'null') not in ('string','null')
   or char_length(source_value)>2000 or (action='order' and source_value='')
   or coalesce(jsonb_typeof(p_payload->'cancel_requested'),'null') not in ('boolean','null') then
   return jsonb_build_object('code','invalid');
 end if;
 draft:=case when p_payload?'draft_context' then p_payload->'draft_context' else
   jsonb_strip_nulls(p_payload-array['source_text','phone','order_id','cancel_requested','action',
     'conversation_generation','context_revision']) end;
 if not private.ai_draft_valid(draft) then return jsonb_build_object('code','invalid'); end if;
 if p_payload?'context_revision' then
   if jsonb_typeof(p_payload->'context_revision')<>'number' then return jsonb_build_object('code','invalid'); end if;
   if (p_payload->>'context_revision')::numeric not between 0 and 9007199254740991
     or (p_payload->>'context_revision')::numeric<>trunc((p_payload->>'context_revision')::numeric) then
     return jsonb_build_object('code','invalid');
   end if;
   expected_revision:=(p_payload->>'context_revision')::bigint;
 end if;
 if p_payload?'conversation_generation' and p_payload->>'conversation_generation' is not null then
   if not private.is_uuid(p_payload->>'conversation_generation') then return jsonb_build_object('code','invalid'); end if;
   gen:=(p_payload->>'conversation_generation')::uuid;
 end if;
 if p_payload->>'order_id' is not null then
   if not private.is_uuid(p_payload->>'order_id') then return jsonb_build_object('code','invalid'); end if;
   select id into legacy_order from public.orders where id=(p_payload->>'order_id')::uuid
     and owner_id=conn.owner_id and deleted_at is null;
   if legacy_order is null then return jsonb_build_object('code','invalid'); end if;
 end if;
 if not conn.read_messages or (conn.connected_at is not null and p_received_at<conn.connected_at) then
   return jsonb_build_object('code','ignored');
 end if;
 perform pg_advisory_xact_lock(hashtextextended('laurum_sync:'||conn.owner_id::text,0));
 select * into receipt from public.ai_message_receipts where owner_id=conn.owner_id and wa_message_id=p_wa_message_id;
 if found then return jsonb_build_object('code','duplicate','proposal_id',receipt.proposal_id); end if;
 select * into p from public.ai_proposals where owner_id=conn.owner_id and wa_message_id=p_wa_message_id;
 if found then return jsonb_build_object('code','duplicate','proposal_id',p.id); end if;
 if action='ignore' then return jsonb_build_object('code','ignored'); end if;
 select * into c from public.ai_conversation_contexts where owner_id=conn.owner_id and phone=phone_key;
 had_context:=found;
 if had_context and c.last_received_at is not null and p_received_at<c.last_received_at then code:='stale';
 elsif had_context and p_payload?'conversation_generation' and gen is distinct from c.generation_id then
   if action='cancel' then code:='stale'; else return jsonb_build_object('code','retry'); end if;
 elsif expected_revision is not null and expected_revision<>coalesce(c.revision,0) then
   return jsonb_build_object('code','retry');
 end if;
 if not had_context then
   if expected_revision is not null and expected_revision<>0 then return jsonb_build_object('code','retry'); end if;
   insert into public.ai_conversation_contexts(owner_id,phone,chat_id)
     values(conn.owner_id,phone_key,p_chat_id) returning * into c;
 end if;
 if code='stale' then
   insert into public.ai_message_receipts(owner_id,wa_message_id,conversation_id,received_at,result_code)
     values(conn.owner_id,p_wa_message_id,c.id,p_received_at,'stale');
   return jsonb_build_object('code','stale');
 end if;
 select * into p from public.ai_proposals where owner_id=conn.owner_id and phone=phone_key
   and status='menunggu' and deleted_at is null;
 if p.id is not null then
   c.proposal_id:=p.id;
   if not had_context then c.draft_context:=private.ai_proposal_draft(p); end if;
 elsif c.proposal_id is not null and action in ('order','collect') then
   c.generation_id:=gen_random_uuid(); c.draft_context:='{}'; c.proposal_id:=null;
 end if;
 if action='cancel' then
   if conn.detect_cancellation then
     if p.id is not null then
       perform set_config('laurum.ai_ingest','on',true);
       update public.ai_proposals set status='ditutup_otomatis' where id=p.id and owner_id=conn.owner_id;
       perform set_config('laurum.ai_ingest',previous_flag,true);
       code:='closed';
     else code:='ignored'; end if;
     c.generation_id:=gen_random_uuid(); c.draft_context:='{}';
   else code:='ignored'; end if;
 else
   merged:=c.draft_context||draft;
   if not private.ai_draft_valid(merged) then return jsonb_build_object('code','invalid'); end if;
   select id into service_key from public.services where owner_id=conn.owner_id and deleted_at is null
     and is_active and lower(btrim(name))=lower(btrim(coalesce(merged->>'service_hint','')))
     order by sort_order,id limit 1;
   if p.id is not null then
     perform set_config('laurum.ai_ingest','on',true);
     update public.ai_proposals set customer_name=coalesce(merged->>'customer_name',''),
       address=coalesce(merged->>'address',''),service_id=service_key,
       uncertain_address=coalesce((merged->>'uncertain_address')::boolean,false),
       confidence=round((merged->>'confidence')::numeric,2) where id=p.id and owner_id=conn.owner_id;
     perform set_config('laurum.ai_ingest',previous_flag,true);
     code:='updated';
   elsif action='order' then
     insert into public.ai_proposals(id,owner_id,source_text,customer_name,phone,address,service_id,
       uncertain_address,confidence,wa_message_id,chat_id,received_at,order_id,cancel_requested)
     values(gen_random_uuid(),conn.owner_id,source_value,coalesce(merged->>'customer_name',''),phone_key,
       coalesce(merged->>'address',''),service_key,coalesce((merged->>'uncertain_address')::boolean,false),
       round((merged->>'confidence')::numeric,2),p_wa_message_id,p_chat_id,p_received_at,
       legacy_order,coalesce((p_payload->>'cancel_requested')::boolean,false)) returning * into p;
     c.proposal_id:=p.id; code:='created';
   else code:='collected'; end if;
   c.draft_context:=merged;
 end if;
 update public.ai_conversation_contexts set chat_id=p_chat_id,generation_id=c.generation_id,
   revision=c.revision+1,draft_context=c.draft_context,proposal_id=c.proposal_id,last_received_at=p_received_at
   where id=c.id and owner_id=conn.owner_id;
 insert into public.ai_message_receipts(owner_id,wa_message_id,conversation_id,received_at,result_code,proposal_id)
   values(conn.owner_id,p_wa_message_id,c.id,p_received_at,code,p.id);
 return jsonb_build_object('code',code,'proposal_id',p.id);
end $$;
revoke all on function public.ingest_ai_proposal(text,text,text,timestamptz,jsonb) from public,anon,authenticated;
grant execute on function public.ingest_ai_proposal(text,text,text,timestamptz,jsonb) to service_role;

create function private.ai_owner_decision() returns trigger language plpgsql security definer set search_path='' as $$
begin
 if auth.role()='authenticated' and new.status is distinct from old.status then
   update public.ai_conversation_contexts set revision=revision+1
     where owner_id=new.owner_id and proposal_id=new.id;
 end if;
 return new;
end $$;
revoke all on function private.ai_owner_decision() from public;
create trigger ai_owner_decision after update on public.ai_proposals
 for each row execute function private.ai_owner_decision();

-- Preserve the existing function identity and grants: no DROP of applied functions.
grant usage,create on schema private to laurum_account_deleter;
set role laurum_account_deleter;
create or replace function private.purge_my_rows() returns void language plpgsql security definer set search_path='' as $$
declare own uuid:=coalesce(nullif(current_setting('request.jwt.claim.sub',true),''),
 nullif(current_setting('request.jwt.claims',true),'')::jsonb->>'sub')::uuid; t text;
begin
 if own is null then raise exception using errcode='42501',message='authentication_required'; end if;
 foreach t in array array['ai_message_receipts','ai_conversation_contexts','ai_proposals','wa_connections',
   'savings_entries','payments','order_events','order_items','orders','expenses','expense_categories',
   'customers','services','receipt_settings','businesses','devices','entitlements'] loop
   execute format('delete from public.%I where owner_id=$1',t) using own;
 end loop;
 delete from private.sync_fragments where owner_id=own;
 delete from private.sync_groups where owner_id=own;
 delete from private.owner_clock where owner_id=own;
end $$;
reset role;
revoke create on schema private from laurum_account_deleter;
