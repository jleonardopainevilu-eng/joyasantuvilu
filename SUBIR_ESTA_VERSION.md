# Joyas Antuvilu — Fusion v2 para subir

Esta versión mantiene:

- Panel Admin visible en el menú público.
- Corazones de favoritos en cada producto.
- Carrito.
- Videos locales.
- Supabase.
- Estado de respaldo: si Supabase falla o está vacío, se muestran productos de ejemplo para que la página no se vea rota.

## Cómo subir

1. Descomprime el ZIP.
2. Entra a la carpeta descomprimida.
3. Sube el contenido completo a la raíz del repositorio GitHub.
4. No subas la carpeta como carpeta nueva.
5. Commit en `main`.
6. Espera Vercel `Ready`.

Debe verse en la raíz:

```text
index.html
admin.html
assets/
README.md
SUBIR_ESTA_VERSION.md
supabase_schema.sql
supabase_seed_productos_prueba.sql
```

Después de subir, el menú debe mostrar: `Catálogo | Videos | Instagram | Panel Admin | Carrito`.


## Ajuste v3
- Panel Admin visible desde la web.
- El admin ya no mantiene sesión persistente: al volver a cargar `/admin.html` exige correo y contraseña.
- Corregido `[hidden]` para que no se vea el login encima del dashboard.
