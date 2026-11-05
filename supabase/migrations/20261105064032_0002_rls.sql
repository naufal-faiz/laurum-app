grant usage on schema public to laurum_account_deleter;
do $$ declare t text; begin
  foreach t in array array['businesses','customers','services','orders','order_items','payments','savings_entries',
    'order_events','expense_categories','expenses','receipt_settings','devices','entitlements'] loop
    execute format('alter table public.%I enable row level security',t);
    execute format('revoke all on public.%I from anon, authenticated',t);
    execute format('grant select, insert, update, delete on public.%I to authenticated',t);
    execute format('grant select, delete on public.%I to laurum_account_deleter',t);
    execute format('create policy owner_read on public.%I for select to authenticated, laurum_account_deleter
      using(owner_id = (select auth.uid()))',t);
    execute format('create policy account_cleanup on public.%I for delete to laurum_account_deleter
      using(owner_id = (select auth.uid()))',t);
    if t <> 'entitlements' then
      execute format('create policy owner_insert on public.%I for insert to authenticated
        with check(owner_id = (select auth.uid()))',t);
    end if;
    if t <> all(array['payments','savings_entries','order_items','order_events','entitlements']) then
      execute format('create policy owner_update on public.%I for update to authenticated
        using(owner_id = (select auth.uid())) with check(owner_id = (select auth.uid()))',t);
    end if;
  end loop;
end $$;
-- Hard deletion is reserved for account cleanup; ordinary deletion is a tombstone.
alter table public.app_config enable row level security;
revoke all on public.app_config from anon, authenticated;
grant select on public.app_config to authenticated;
create policy authenticated_config_read on public.app_config for select to authenticated using(true);

create policy expense_photo_read on storage.objects for select to authenticated
  using(bucket_id = 'expense-photos' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy expense_photo_insert on storage.objects for insert to authenticated
  with check(bucket_id = 'expense-photos' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy expense_photo_update on storage.objects for update to authenticated
  using(bucket_id = 'expense-photos' and (storage.foldername(name))[1] = (select auth.uid())::text)
  with check(bucket_id = 'expense-photos' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy expense_photo_delete on storage.objects for delete to authenticated
  using(bucket_id = 'expense-photos' and (storage.foldername(name))[1] = (select auth.uid())::text);
