# Joyas Antuvilu — versión V6

Subir a GitHub reemplazando archivos en la raíz del repositorio.

## Archivos principales
- `index.html`: tienda pública con catálogo, favoritos, carrito, videos y Panel Admin visible.
- `admin.html`: panel corregido con edición clara de productos, miniaturas, vista previa de imagen y seguridad básica.
- `assets/js/config.js`: conexión Supabase existente. No publicar secret keys.

## Correcciones V6
- Producto visible en tienda pública con imagen normalizada y fallback al logo.
- Botones Editar / Ver imagen / Ocultar visibles en el panel.
- Vista previa de imagen en el formulario de producto.
- Campo de imagen limpio: usar `assets/logo-antuvilu.png` o URL directa.
- Textos públicos sin frases de demo/Supabase.
- Configuración del panel con lenguaje normal para la dueña.
- Se agregó restablecimiento/cambio de contraseña básico en el panel.

## Subida recomendada
Para este arreglo sube `admin.html` e `index.html`. Si dudas, sube todo el contenido del ZIP respetando carpetas.
