-- Datos opcionales de prueba para Joyas Antuvilu.
-- Ejecutar solo si quieres ver productos de prueba en la tienda pública.
-- Role recomendado: postgres.

with cats as (
  select id, slug from public.categories where slug in ('pulseras','collares','regalos')
)
insert into public.products(name, slug, sku, category_id, price, description, materials, measure, stock, status, featured, image_url)
values
  (
    'Pulsera Jaguar',
    'pulsera-jaguar-prueba',
    'ANT-PUL-JAG-001',
    (select id from cats where slug = 'pulseras'),
    7000,
    'Pulsera de hematita y piedra volcánica con dije central de jaguar, símbolo de fuerza y valentía.',
    'Hematita, piedra volcánica, acero inoxidable',
    '16 cm + extensor',
    2,
    'active',
    true,
    'assets/logo-antuvilu.png'
  ),
  (
    'Pulsera Corazón',
    'pulsera-corazon-prueba',
    'ANT-PUL-COR-001',
    (select id from cats where slug = 'pulseras'),
    7000,
    'Pulsera de hematita en forma de corazón y calcedonia amarilla.',
    'Hematita, calcedonia amarilla, acero inoxidable',
    '16 cm + extensor',
    2,
    'active',
    true,
    'assets/logo-antuvilu.png'
  ),
  (
    'Collar Energía Natural',
    'collar-energia-natural-prueba',
    'ANT-COL-ENE-001',
    (select id from cats where slug = 'collares'),
    12000,
    'Collar artesanal de piedras naturales, pensado como pieza de presencia y significado.',
    'Piedras naturales seleccionadas',
    '45 cm aprox.',
    1,
    'active',
    false,
    'assets/logo-antuvilu.png'
  )
on conflict (slug) do nothing;

insert into public.store_videos(title, description, url, thumb_url, active, sort_order)
select * from (values
  ('Piedras en luz natural', 'Detalle real de las piezas.', 'assets/videos/antuvilu-reel-01.mp4', 'assets/videos/antuvilu-reel-01.jpg', true, 10),
  ('Brillo y movimiento', 'Texturas y color.', 'assets/videos/antuvilu-reel-02.mp4', 'assets/videos/antuvilu-reel-02.jpg', true, 20)
) as v(title, description, url, thumb_url, active, sort_order)
where not exists (select 1 from public.store_videos sv where sv.url = v.url);
