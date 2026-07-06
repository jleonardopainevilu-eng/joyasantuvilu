-- Joyas Antuvilu / Store Base v1
-- Run this file in Supabase SQL Editor.
-- Safe model: public users can read active products and create orders.
-- Only authenticated admin users can manage products, stock and orders.

create extension if not exists pgcrypto;

create sequence if not exists public.order_number_seq start 1001;

create table if not exists public.admin_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role text not null default 'owner' check (role in ('owner', 'admin', 'staff', 'viewer')),
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  sort_order int not null default 0,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  sku text unique,
  name text not null,
  slug text not null unique,
  category_id uuid references public.categories(id) on delete set null,
  price int not null default 0 check (price >= 0),
  compare_at_price int check (compare_at_price is null or compare_at_price >= 0),
  description text,
  materials text,
  measure text,
  stock int not null default 0 check (stock >= 0),
  low_stock_threshold int not null default 2 check (low_stock_threshold >= 0),
  status text not null default 'active' check (status in ('draft', 'active', 'sold_out', 'archived')),
  featured boolean not null default false,
  image_url text,
  video_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.product_images (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  url text not null,
  alt text,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.store_videos (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  url text not null,
  thumb_url text,
  active boolean not null default true,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  order_number text not null unique default ('ANT-' || to_char(now(), 'YYYYMMDD') || '-' || lpad(nextval('public.order_number_seq')::text, 5, '0')),
  customer_name text not null,
  customer_email text,
  customer_phone text,
  customer_note text,
  status text not null default 'new' check (status in ('new', 'confirmed', 'paid', 'preparing', 'shipped', 'delivered', 'cancelled')),
  subtotal int not null default 0 check (subtotal >= 0),
  shipping_method text not null default 'coordinar',
  payment_method text not null default 'manual',
  confirmed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  product_id uuid references public.products(id) on delete set null,
  product_name text not null,
  product_snapshot jsonb not null default '{}'::jsonb,
  quantity int not null check (quantity > 0),
  unit_price int not null default 0 check (unit_price >= 0),
  line_total int not null default 0 check (line_total >= 0),
  created_at timestamptz not null default now()
);

create table if not exists public.inventory_movements (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  order_id uuid references public.orders(id) on delete set null,
  type text not null check (type in ('initial', 'purchase', 'sale', 'adjustment', 'return')),
  quantity int not null,
  reason text,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);

create table if not exists public.store_settings (
  key text primary key,
  value jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists products_set_updated_at on public.products;
create trigger products_set_updated_at
before update on public.products
for each row execute function public.set_updated_at();

drop trigger if exists orders_set_updated_at on public.orders;
create trigger orders_set_updated_at
before update on public.orders
for each row execute function public.set_updated_at();

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.admin_profiles
    where user_id = auth.uid()
      and active = true
      and role in ('owner', 'admin', 'staff')
  );
$$;

create or replace function public.is_owner_or_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.admin_profiles
    where user_id = auth.uid()
      and active = true
      and role in ('owner', 'admin')
  );
$$;

create or replace function public.confirm_order_and_decrement_stock(target_order_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  item record;
  current_status text;
  current_stock int;
begin
  if not public.is_admin() then
    raise exception 'not authorized';
  end if;

  select status into current_status
  from public.orders
  where id = target_order_id
  for update;

  if current_status is null then
    raise exception 'order not found';
  end if;

  if current_status not in ('new') then
    update public.orders
    set status = 'confirmed',
        confirmed_at = coalesce(confirmed_at, now())
    where id = target_order_id;
    return;
  end if;

  for item in
    select product_id, quantity
    from public.order_items
    where order_id = target_order_id
      and product_id is not null
  loop
    select stock into current_stock
    from public.products
    where id = item.product_id
    for update;

    if current_stock is null then
      raise exception 'product not found';
    end if;

    if current_stock < item.quantity then
      raise exception 'stock insuficiente';
    end if;

    update public.products
    set stock = stock - item.quantity,
        status = case when stock - item.quantity = 0 then 'sold_out' else status end
    where id = item.product_id;

    insert into public.inventory_movements(product_id, order_id, type, quantity, reason, created_by)
    values (item.product_id, target_order_id, 'sale', item.quantity * -1, 'Pedido confirmado', auth.uid());
  end loop;

  update public.orders
  set status = 'confirmed',
      confirmed_at = now()
  where id = target_order_id;
end;
$$;

alter table public.admin_profiles enable row level security;
alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.product_images enable row level security;
alter table public.store_videos enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.inventory_movements enable row level security;
alter table public.store_settings enable row level security;

drop policy if exists "admins can read own profile" on public.admin_profiles;
create policy "admins can read own profile"
on public.admin_profiles for select
to authenticated
using (user_id = auth.uid() or public.is_owner_or_admin());

drop policy if exists "owners manage admin profiles" on public.admin_profiles;
create policy "owners manage admin profiles"
on public.admin_profiles for all
to authenticated
using (public.is_owner_or_admin())
with check (public.is_owner_or_admin());

drop policy if exists "public reads active categories" on public.categories;
create policy "public reads active categories"
on public.categories for select
to anon, authenticated
using (active = true or public.is_admin());

drop policy if exists "admins manage categories" on public.categories;
create policy "admins manage categories"
on public.categories for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "public reads active products" on public.products;
create policy "public reads active products"
on public.products for select
to anon, authenticated
using (status in ('active', 'sold_out') or public.is_admin());

drop policy if exists "admins manage products" on public.products;
create policy "admins manage products"
on public.products for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "public reads product images" on public.product_images;
create policy "public reads product images"
on public.product_images for select
to anon, authenticated
using (
  exists (
    select 1 from public.products p
    where p.id = product_id
      and (p.status in ('active', 'sold_out') or public.is_admin())
  )
);

drop policy if exists "admins manage product images" on public.product_images;
create policy "admins manage product images"
on public.product_images for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "public reads active videos" on public.store_videos;
create policy "public reads active videos"
on public.store_videos for select
to anon, authenticated
using (active = true or public.is_admin());

drop policy if exists "admins manage videos" on public.store_videos;
create policy "admins manage videos"
on public.store_videos for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "public creates orders" on public.orders;
create policy "public creates orders"
on public.orders for insert
to anon, authenticated
with check (status = 'new');

drop policy if exists "admins read and update orders" on public.orders;
create policy "admins read and update orders"
on public.orders for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "public creates order items" on public.order_items;
create policy "public creates order items"
on public.order_items for insert
to anon, authenticated
with check (quantity > 0);

drop policy if exists "admins read order items" on public.order_items;
create policy "admins read order items"
on public.order_items for select
to authenticated
using (public.is_admin());

drop policy if exists "admins manage inventory movements" on public.inventory_movements;
create policy "admins manage inventory movements"
on public.inventory_movements for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "public reads public settings" on public.store_settings;
create policy "public reads public settings"
on public.store_settings for select
to anon, authenticated
using (key in ('store_public') or public.is_admin());

drop policy if exists "admins manage settings" on public.store_settings;
create policy "admins manage settings"
on public.store_settings for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

grant execute on function public.confirm_order_and_decrement_stock(uuid) to authenticated;

insert into public.categories(name, slug, sort_order)
values
  ('Pulseras', 'pulseras', 10),
  ('Collares', 'collares', 20),
  ('Regalos', 'regalos', 30)
on conflict (slug) do nothing;

insert into public.store_settings(key, value)
values (
  'store_public',
  jsonb_build_object(
    'store_name', 'Joyas Antuvilu',
    'email', 'joyasantuvilu@gmail.com',
    'whatsapp', '',
    'currency', 'CLP'
  )
)
on conflict (key) do nothing;

