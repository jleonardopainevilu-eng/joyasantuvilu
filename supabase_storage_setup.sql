-- Joyas Antuvilu — Supabase Storage para imágenes de productos
-- Ejecutar en SQL Editor con Role postgres.
-- Permite que el panel admin suba imágenes al bucket público product-images.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'product-images',
  'product-images',
  true,
  5242880,
  array['image/jpeg','image/png','image/webp']
)
on conflict (id) do update
set
  public = true,
  file_size_limit = 5242880,
  allowed_mime_types = array['image/jpeg','image/png','image/webp'];

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'joyas_antuvilu_public_read_product_images'
  ) then
    create policy joyas_antuvilu_public_read_product_images
    on storage.objects
    for select
    using (bucket_id = 'product-images');
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'joyas_antuvilu_admin_upload_product_images'
  ) then
    create policy joyas_antuvilu_admin_upload_product_images
    on storage.objects
    for insert
    to authenticated
    with check (
      bucket_id = 'product-images'
      and exists (
        select 1
        from public.admin_profiles ap
        where ap.user_id = auth.uid()
          and ap.active = true
          and ap.role in ('owner','admin')
      )
    );
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'joyas_antuvilu_admin_update_product_images'
  ) then
    create policy joyas_antuvilu_admin_update_product_images
    on storage.objects
    for update
    to authenticated
    using (
      bucket_id = 'product-images'
      and exists (
        select 1
        from public.admin_profiles ap
        where ap.user_id = auth.uid()
          and ap.active = true
          and ap.role in ('owner','admin')
      )
    )
    with check (
      bucket_id = 'product-images'
      and exists (
        select 1
        from public.admin_profiles ap
        where ap.user_id = auth.uid()
          and ap.active = true
          and ap.role in ('owner','admin')
      )
    );
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'joyas_antuvilu_admin_delete_product_images'
  ) then
    create policy joyas_antuvilu_admin_delete_product_images
    on storage.objects
    for delete
    to authenticated
    using (
      bucket_id = 'product-images'
      and exists (
        select 1
        from public.admin_profiles ap
        where ap.user_id = auth.uid()
          and ap.active = true
          and ap.role in ('owner','admin')
      )
    );
  end if;
end $$;
