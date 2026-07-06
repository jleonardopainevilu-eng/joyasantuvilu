# Joyas Antuvilu — Tienda online administrable

Versión corregida para publicar y seguir trabajando con Supabase.

## Archivos principales

- `index.html`: tienda pública.
- `admin.html`: panel privado.
- `assets/js/config.js`: conexión pública a Supabase.
- `supabase_schema.sql`: tablas, funciones y políticas RLS.
- `supabase_seed_productos_prueba.sql`: datos opcionales de prueba.
- `assets/logo-antuvilu.png`: logo.
- `assets/videos/`: videos locales livianos.

## Qué se corrigió en esta versión

- La tienda pública ya no queda en blanco si Supabase está vacío.
- Los videos locales se muestran aunque la tabla `store_videos` no tenga datos.
- Si no hay productos, se muestra un estado profesional: “Catálogo en preparación”.
- Se retiraron textos técnicos de la portada pública.
- El enlace visible a `admin.html` se retiró del menú público.
- El panel admin muestra errores de login más claros.
- Se corrigieron textos y tildes principales.
- El README ahora apunta al archivo SQL correcto: `supabase_schema.sql`.

## Cómo subir a GitHub / Vercel

1. Descomprime este ZIP.
2. Sube todo el contenido a la raíz del repositorio `joyasantuvilu`.
3. Confirma que exista:
   - `index.html`
   - `admin.html`
   - `assets/js/config.js`
   - `supabase_schema.sql`
4. Haz commit en `main`.
5. Vercel debería desplegar automáticamente.

## Instalación Supabase

1. En Supabase, abre el proyecto `joyas-antuvilu`.
2. Abre SQL Editor.
3. Ejecuta `supabase_schema.sql` con rol `postgres`.
4. En Authentication > Users, crea el usuario administrador con **Create user**, no Invite.
5. Activa **Auto confirm user**.
6. Copia el `user_id` del usuario.
7. En SQL Editor, con rol `postgres`, ejecuta:

```sql
insert into public.admin_profiles(user_id, full_name, role, active)
values ('PEGAR_USER_ID_AQUI', 'Administrador', 'owner', true)
on conflict (user_id) do update
set full_name = 'Administrador', role = 'owner', active = true;
```

## Configuración

En `assets/js/config.js` deben estar:

```js
window.STORE_CONFIG = {
  supabaseUrl: "https://vxjjquvfmpqqemjhdhch.supabase.co",
  supabaseAnonKey: "sb_publishable_...",
  storeName: "Joyas Antuvilu",
  storeEmail: "joyasantuvilu@gmail.com",
  whatsappNumber: "",
  instagramUrl: "https://www.instagram.com/joyasantuvilu",
  currency: "CLP"
};
```

No pongas nunca la `service_role key` o `secret key` en archivos frontend.

## Flujo de pedido

1. Cliente agrega productos al carrito.
2. Cliente envía pedido.
3. El pedido queda como `new`.
4. El administrador revisa disponibilidad y pago manual.
5. El administrador presiona `Confirmar`.
6. Supabase descuenta stock y registra movimiento.

Así evitamos descontar stock antes de que el pedido esté confirmado.

## Próximo paso recomendado

Entrar a `admin.html`, crear 3 productos reales y verificar que aparezcan en la tienda pública.
