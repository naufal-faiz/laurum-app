-- Server wire schema v4. Local sync_state and normalized keys never cross the API.
create schema if not exists private;
revoke all on schema private from public;
do $$ begin
  if not exists (select from pg_roles where rolname = 'laurum_account_deleter') then
    create role laurum_account_deleter nologin noinherit;
  end if;
end $$;

create table public.businesses (
  id uuid primary key, owner_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz,
  name text not null, address text not null default '', phone text not null default '',
  receipt_footer text not null default '', receipt_note text not null default '', use_order_status boolean not null default true,
  unique(owner_id, id)
);
create table public.customers (
  id uuid primary key, owner_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz,
  name text not null, phone text not null default '', address text not null default '', notes text not null default '',
  is_active boolean not null default true, unique(owner_id, id)
);
create unique index customers_active_phone on public.customers(owner_id, phone)
  where deleted_at is null and is_active and phone <> '';
create table public.services (
  id uuid primary key, owner_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz,
  name text not null, kind text not null check(kind in ('kiloan','satuan')), price bigint not null check(price >= 0),
  duration_days integer not null check(duration_days >= 0), is_active boolean not null default true,
  sort_order integer not null default 0, unique(owner_id, id)
);
create table public.orders (
  id uuid primary key, owner_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz,
  order_no text not null, customer_id uuid not null,
  status text not null check(status in ('menunggu_jemput','diproses','siap','selesai','dibatalkan')),
  source text not null default 'kasir' check(source in ('kasir','whatsapp_ai')),
  pay_term text not null default 'sekarang' check(pay_term in ('sekarang','cod')), proposal_id uuid,
  discount bigint not null default 0 check(discount >= 0), note text not null default '',
  entered_at timestamptz not null, estimated_at timestamptz not null,
  subtotal bigint not null check(subtotal >= 0), total bigint not null check(total >= 0 and total = subtotal - discount),
  unique(owner_id,id), unique(owner_id,order_no),
  foreign key(owner_id,customer_id) references public.customers(owner_id,id)
);
create table public.order_items (
  id uuid primary key, owner_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz,
  order_id uuid not null, service_id uuid not null, service_name text not null,
  unit text not null check(unit in ('kg','pcs')), qty_milli bigint not null check(qty_milli >= 0),
  unit_price bigint not null check(unit_price >= 0), line_total bigint not null check(line_total >= 0),
  unique(owner_id,id), foreign key(owner_id,order_id) references public.orders(owner_id,id),
  foreign key(owner_id,service_id) references public.services(owner_id,id)
);
create table public.payments (
  id uuid primary key, owner_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz,
  order_id uuid not null, method text not null check(method in ('tunai','qris','transfer','tabungan')),
  amount bigint not null, received bigint not null default 0, paid_at timestamptz not null, note text not null default '',
  unique(owner_id,id), foreign key(owner_id,order_id) references public.orders(owner_id,id),
  check(deleted_at is null)
);
create table public.savings_entries (
  id uuid primary key, owner_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
  customer_id uuid not null, kind text not null check(kind in ('setor','pakai','penyesuaian')),
  amount bigint not null, method text not null check(method in ('tunai','qris','transfer','tabungan')),
  order_id uuid, note text not null default '', unique(owner_id,id),
  foreign key(owner_id,customer_id) references public.customers(owner_id,id),
  foreign key(owner_id,order_id) references public.orders(owner_id,id)
);
-- Already part of the B1d domain; missing from PRD B table summary (tracked in STATE).
create table public.order_events (
  id uuid primary key, owner_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz,
  order_id uuid not null, occurred_at timestamptz not null, kind text not null, note text not null default '',
  from_status text, to_status text, unique(owner_id,id),
  foreign key(owner_id,order_id) references public.orders(owner_id,id)
);
create table public.expense_categories (
  id uuid primary key, owner_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz,
  name text not null, is_default boolean not null default false, unique(owner_id,id)
);
create table public.expenses (
  id uuid primary key, owner_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz,
  category_id uuid not null, amount bigint not null check(amount >= 0), vendor text not null default '',
  note text not null default '', spent_at timestamptz not null, photo_path text,
  unique(owner_id,id), foreign key(owner_id,category_id) references public.expense_categories(owner_id,id),
  check(photo_path is null or photo_path like owner_id::text || '/%')
);
create table public.receipt_settings (
  id uuid primary key, owner_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz,
  paper_mm integer not null default 58 check(paper_mm in (58,80)), font_size integer not null default 12 check(font_size > 0),
  show_address boolean not null default true, show_customer boolean not null default true,
  show_savings boolean not null default true, show_note boolean not null default true, unique(owner_id,id)
);
create table public.devices (
  id uuid primary key, owner_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz,
  code text not null, name text not null, last_seen_at timestamptz, unique(owner_id,id), unique(owner_id,code)
);
create table public.entitlements (
  id uuid primary key, owner_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz,
  plan text not null default 'free' check(plan in ('free','pro')), valid_until timestamptz, source text not null,
  unique(owner_id,id)
);
create table public.app_config (
  id boolean primary key default true check(id), min_schema_version integer not null check(min_schema_version > 0)
);
insert into public.app_config(min_schema_version) values(4);
do $$ declare t text; begin
  foreach t in array array['businesses','customers','services','orders','order_items','payments','savings_entries',
    'order_events','expense_categories','expenses','receipt_settings','devices','entitlements'] loop
    execute format('create index %I on public.%I(owner_id,updated_at,id)', t || '_pull',t);
  end loop;
end $$;
create index orders_status on public.orders(owner_id,status);
create index orders_entered on public.orders(owner_id,entered_at);
create index payments_order on public.payments(order_id);
create index items_order on public.order_items(owner_id,order_id);
create index savings_customer on public.savings_entries(owner_id,customer_id);
create index events_order on public.order_events(owner_id,order_id);
create index expenses_category on public.expenses(owner_id,category_id);
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
  values('expense-photos','expense-photos',false,204800,array['image/jpeg']);
