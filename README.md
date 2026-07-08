# Joyas Antuvilu — versión fusionada

Esta versión une la base Supabase/panel admin con las mejoras de experiencia que ya se habían avanzado:

- Tienda pública con estética boutique.
- Catálogo conectado a Supabase.
- Estado elegante si el catálogo está vacío.
- Videos locales visibles aunque Supabase no tenga videos cargados.
- Carrito persistente.
- Corazones de favoritos guardados en el navegador.
- Modal de producto con imagen ampliada.
- Acceso visible al panel desde la web: `Panel`.
- Panel administrador en `admin.html`.
- SEO básico + Open Graph + Twitter Card + schema JewelryStore.

## Subida a GitHub

Subir el contenido de esta carpeta a la raíz del repositorio. No subir la carpeta contenedora completa.

La raíz debe quedar así:

```
index.html
admin.html
assets/
assets/js/config.js
assets/videos/
supabase_schema.sql
supabase_seed_productos_prueba.sql
SUBIR_ESTA_VERSION.md
README.md
```

## Supabase

1. Ejecutar `supabase_schema.sql` en SQL Editor con Role `postgres`.
2. Crear usuario en Authentication > Users.
3. Insertar ese usuario en `admin_profiles` con Role `postgres`.
4. Cargar productos desde el panel o ejecutar `supabase_seed_productos_prueba.sql` para ver productos de prueba.

## Configuración

Editar `assets/js/config.js` solo con publishable key. Nunca usar la secret key en el frontend.


## Seguridad admin v3
El panel usa Supabase Auth pero con sesión no persistente. Al recargar o volver a entrar a `/admin.html`, solicita correo y contraseña nuevamente. También incluye botón `Cerrar sesión`.
