create function private.stamp_record() returns trigger language plpgsql
set search_path = '' as $$ begin
  if TG_OP = 'UPDATE' then
    if new.owner_id is distinct from old.owner_id or new.id is distinct from old.id then
      raise exception using errcode = '23514', message = 'immutable_identity';
    end if;
    new.created_at := old.created_at;
  end if;
  new.updated_at := clock_timestamp();
  return new;
end $$;
create function private.guard_ledger() returns trigger language plpgsql
set search_path = '' as $$ begin
  if TG_OP = 'DELETE' and current_user = 'laurum_account_deleter' then return old; end if;
  raise exception using errcode = '23514', message = 'append_only';
end $$;
create function private.guard_order() returns trigger language plpgsql
set search_path = '' as $$ begin
  if TG_OP = 'UPDATE' and old.status in ('selesai','dibatalkan') and new.status <> old.status then
    raise exception using errcode = '23514', message = 'final_order';
  end if;
  if new.status = 'selesai' and new.pay_term = 'cod' and new.total > coalesce(
    (select sum(amount) from public.payments where owner_id = new.owner_id and order_id = new.id),0) then
    raise exception using errcode = '23514', message = 'cod_unpaid';
  end if;
  return new;
end $$;
revoke all on function private.stamp_record(), private.guard_ledger(), private.guard_order() from public;
do $$ declare t text; begin
  foreach t in array array['businesses','customers','services','orders','order_items','payments','savings_entries',
    'order_events','expense_categories','expenses','receipt_settings','devices','entitlements'] loop
    execute format('create trigger stamp_record before insert or update on public.%I
      for each row execute function private.stamp_record()',t);
    if t = any(array['payments','savings_entries','order_items','order_events']) then
      execute format('create trigger immutable_ledger before update or delete on public.%I
        for each row execute function private.guard_ledger()',t);
    end if;
  end loop;
end $$;
create trigger guard_order before insert or update on public.orders
  for each row execute function private.guard_order();
