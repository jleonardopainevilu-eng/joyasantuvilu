# Joyas Antuvilu — versión lista para entregar

Versión final preparada para cliente con tienda pública, panel administrador y Supabase.

## Incluye

- Tienda pública boutique (`index.html`).
- Catálogo conectado a Supabase.
- Favoritos con corazón pequeño y discreto.
- Carrito de solicitud.
- Videos locales livianos.
- Sección “Cómo comprar”.
- Acceso visible al panel desde la tienda.
- Panel privado (`admin.html`).
- Login limpio, sin correos prellenados.
- Restablecimiento y cambio de contraseña.
- Dashboard.
- Productos con crear, editar, ocultar, vista previa y carga de imagen.
- Categorías administrables.
- Pedidos y confirmación con descuento de stock.
- Stock manual e historial.
- Configuración pública de tienda.
- Página interna de entrega al cliente (`ENTREGA_CLIENTE.html`).

## Subida a GitHub

Subir el contenido de esta carpeta a la raíz del repositorio. No subir la carpeta contenedora completa.

La raíz debe quedar así:

```text
index.html
admin.html
ENTREGA_CLIENTE.html
assets/
assets/js/config.js
assets/videos/
supabase_schema.sql
supabase_storage_setup.sql
supabase_seed_productos_prueba.sql
SUBIR_ESTA_VERSION.md
README.md
```

## Supabase

1. Ejecutar `supabase_schema.sql` con Role `postgres`.
2. Crear el usuario administrador en Authentication > Users > Add user > Create user.
3. Insertar ese usuario en `admin_profiles`.
4. Ejecutar `supabase_storage_setup.sql` si se quiere subir imágenes desde el panel.
5. Cargar productos desde el panel o usar `supabase_seed_productos_prueba.sql`.

## Configuración

Editar `assets/js/config.js` solo con:

- Project URL.
- Publishable key.
- Datos públicos de la tienda.

Nunca usar secret key en el frontend.

## Entrega al cliente

Abrir `ENTREGA_CLIENTE.html` para mostrar al cliente qué se entrega y cómo usar el panel.
