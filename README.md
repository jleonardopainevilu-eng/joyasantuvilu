# Antuvilu Store Base v1

Base profesional para vender tiendas online boutique de baja escala.

Incluye:

- Tienda publica (`index.html`)
- Panel administrador (`admin.html`)
- Configuracion Supabase (`assets/js/config.js`)
- Esquema de base de datos con seguridad (`database/supabase_schema.sql`)
- Logo y videos demo de Joyas Antuvilu

## Categoria comercial

Producto: **Tienda Online Boutique**

Para joyas, ropa, accesorios, artesania, cosmetica, decoracion y productos de stock acotado.

## Que resuelve

- Catalogo de productos
- Filtros y buscador
- Ficha de producto
- Carrito
- Pedido manual
- Login admin
- Productos administrables
- Stock en base de datos
- Pedidos guardados
- Confirmacion de pedido con descuento de stock
- Historial de movimientos de inventario
- Base lista para pagos online futuros

## Instalacion Supabase

1. Crear proyecto en Supabase.
2. Abrir SQL Editor.
3. Ejecutar `database/supabase_schema.sql`.
4. En Authentication, crear el usuario administrador con correo y contrasena.
5. Copiar el `user_id` del usuario creado.
6. En SQL Editor ejecutar:

```sql
insert into public.admin_profiles(user_id, full_name, role, active)
values ('PEGAR_USER_ID_AQUI', 'Administrador', 'owner', true);
```

7. Ir a Project Settings > API.
8. Copiar:
   - Project URL
   - anon public key
9. Pegar esos datos en `assets/js/config.js`.

Importante: nunca pegar la `service_role key` en archivos frontend.

## Flujo de pedido recomendado

1. Cliente agrega productos al carrito.
2. Cliente envia pedido.
3. Pedido queda como `new`.
4. Administrador revisa disponibilidad y pago manual.
5. Administrador presiona `Confirmar`.
6. Supabase descuenta stock y registra movimiento.

Asi evitamos descontar stock cuando un cliente aun no paga.

## Pagos online futuros

La base esta preparada para sumar:

- Webpay
- Flow
- Mercado Pago

Recomendacion: agregar pagos en una segunda etapa con una funcion backend, no directamente desde el HTML.

## Producto vendible

Rangos sugeridos:

- Web presencia: $150.000 - $220.000
- Catalogo premium: $280.000 - $450.000
- Tienda online boutique: $450.000 - $750.000
- Tienda pro / sistema: $800.000+

Esta base corresponde a **Tienda Online Boutique**.

