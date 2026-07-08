# Subir esta versión — Joyas Antuvilu

Esta es la versión lista para entregar.

## Qué subir

Sube todo el contenido de esta carpeta a la raíz del repositorio de GitHub.

No debe quedar dentro de una carpeta como:

```text
joyas_antuvilu_final/
  index.html
  admin.html
```

Debe quedar directamente así:

```text
index.html
admin.html
ENTREGA_CLIENTE.html
assets/js/config.js
assets/videos/
supabase_schema.sql
supabase_storage_setup.sql
```

## Commit sugerido

```text
Versión final cliente Joyas Antuvilu
```

## Después de subir

Abrir:

```text
https://www.joyasantuvilu.cl/?v=final
https://www.joyasantuvilu.cl/admin.html?v=final
```

## Importante

- El corazón de favoritos queda pequeño en la esquina del producto.
- Las imágenes pueden subirse desde el panel si `supabase_storage_setup.sql` está ejecutado.
- Si Storage no está configurado, el campo imagen acepta URL directa o ruta del sitio.
- La contraseña se cambia desde Configuración > Seguridad.
- El enlace de recuperación de contraseña requiere configurar en Supabase Authentication > URL Configuration:
  - Site URL: `https://www.joyasantuvilu.cl`
  - Redirect URL: `https://www.joyasantuvilu.cl/admin.html`
  - Redirect URL: `https://joyasantuvilu.cl/admin.html`
