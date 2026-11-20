-- Approved B7d weight addendum: one nullable column; local only by agent.
-- No backfill: historic proposals keep unknown weight instead of guessing.
alter table public.ai_proposals add column estimated_weight_grams integer
 constraint ai_proposals_estimated_weight_positive check(estimated_weight_grams>0);

create or replace function private.ai_draft_valid(value jsonb) returns boolean language sql immutable set search_path='' as $$
 select case when jsonb_typeof(value) is distinct from 'object' then false else coalesce(not exists(select from jsonb_object_keys(value) k
   where k<>all(array['customer_name','address','service_hint','uncertain_address','confidence','estimated_weight_grams']))
   and coalesce(jsonb_typeof(value->'customer_name'),'null') in ('string','null')
   and char_length(coalesce(value->>'customer_name',''))<=120
   and coalesce(jsonb_typeof(value->'address'),'null') in ('string','null')
   and char_length(coalesce(value->>'address',''))<=300
   and coalesce(jsonb_typeof(value->'service_hint'),'null') in ('string','null')
   and char_length(coalesce(value->>'service_hint',''))<=120
   and coalesce(jsonb_typeof(value->'uncertain_address'),'null') in ('boolean','null')
   and case when coalesce(jsonb_typeof(value->'estimated_weight_grams'),'null')='null' then true
     when jsonb_typeof(value->'estimated_weight_grams')='number' then
       (value->>'estimated_weight_grams')::numeric between 1 and 2147483647
       and (value->>'estimated_weight_grams')::numeric=trunc((value->>'estimated_weight_grams')::numeric)
     else false end
   and case when coalesce(jsonb_typeof(value->'confidence'),'null')='null' then true
     when jsonb_typeof(value->'confidence')='number' then (value->>'confidence')::numeric between 0 and 1
     else false end,false) end;
$$;

create or replace function private.ai_proposal_draft(p public.ai_proposals) returns jsonb language sql stable set search_path='' as $$
 select jsonb_build_object('customer_name',p.customer_name,'address',p.address,
   'service_hint',coalesce((select name from public.services where id=p.service_id and owner_id=p.owner_id),''),
   'uncertain_address',p.uncertain_address,'confidence',p.confidence,'estimated_weight_grams',p.estimated_weight_grams);
$$;

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
        'uncertain_address','confidence','estimated_weight_grams','status','decided_at']) is distinct from
       (to_jsonb(old)-array['updated_at','customer_name','address','service_id',
        'uncertain_address','confidence','estimated_weight_grams','status','decided_at']) then
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
    new.estimated_weight_grams:=old.estimated_weight_grams;
    new.uncertain_address:=old.uncertain_address;
    new.source_text:=old.source_text;
  end if;
  if new.id is distinct from old.id or new.owner_id is distinct from old.owner_id
     or new.wa_message_id is distinct from old.wa_message_id
     or new.chat_id is distinct from old.chat_id
     or new.confidence is distinct from old.confidence
     or new.estimated_weight_grams is distinct from old.estimated_weight_grams
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
   'action','draft_context','conversation_generation','context_revision','estimated_weight_grams'])) then
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
       confidence=round((merged->>'confidence')::numeric,2),
       estimated_weight_grams=(merged->>'estimated_weight_grams')::integer where id=p.id and owner_id=conn.owner_id;
     perform set_config('laurum.ai_ingest',previous_flag,true);
     code:='updated';
   elsif action='order' then
     insert into public.ai_proposals(id,owner_id,source_text,customer_name,phone,address,service_id,
       uncertain_address,confidence,estimated_weight_grams,wa_message_id,chat_id,received_at,order_id,cancel_requested)
     values(gen_random_uuid(),conn.owner_id,source_value,coalesce(merged->>'customer_name',''),phone_key,
       coalesce(merged->>'address',''),service_key,coalesce((merged->>'uncertain_address')::boolean,false),
       round((merged->>'confidence')::numeric,2),(merged->>'estimated_weight_grams')::integer,p_wa_message_id,p_chat_id,p_received_at,
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

notify pgrst, 'reload schema';
