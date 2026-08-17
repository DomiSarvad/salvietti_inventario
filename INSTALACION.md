# Guía de Instalación y Configuración
# Sistema de Gestión de Inventario - Salvietti

## 📋 Requisitos Previos

- Flutter SDK
- Dart SDK
- Cuenta de Supabase activa
- PostgreSQL 15+ (gestionado por Supabase)
- Git

## 🚀 Pasos de Instalación

### 1. Clonar o Descargar el Proyecto

```bash
cd "C:\Users\HP\Desktop\Trabajos\CCA 2026\Salvietti\sistema"
```

### 2. Instalar Dependencias PHP

```bash
composer install
```

### 3. Configurar Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto Flutter con:

```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu_clave_anonima
```

### 4. Crear la base de datos en Supabase

Importa el script SQL de PostgreSQL ubicado en:

```bash
database/salvietti.sql
```

Esto crea las tablas del proyecto, el trigger para sincronizar `auth.users` y la estructura base del inventario.

### 5. Crear usuarios reales en Supabase Auth

Desde el panel de Supabase, crea los usuarios de acceso con los emails que se usarán en la app:

- gerente@salvietti.com
- jefe@salvietti.com
- almacen@salvietti.com

La tabla `public.usuarios` se sincroniza automáticamente con `auth.users` mediante el trigger incluido en el script.

### 6. Ejecutar la app

```bash
flutter pub get
flutter run -d windows
```

O para Android:

```bash
flutter run -d android
```

### 7. Verificar flujo de login

La app debe iniciar sesión con las credenciales creadas en Supabase Auth y no depender de una tabla MySQL local.

---

## 🗄️ Estructura de Base de Datos

La base de datos del proyecto queda en Supabase/PostgreSQL y mantiene la lógica del inventario empresarial.

### Gestión de Usuarios
- `public.usuarios` - Perfil del usuario vinculado a `auth.users`
- `public.auditoria` - Registro de eventos del sistema

### Inventario
- `public.insumos_materias_primas` - Catálogo de materias primas con stock
- `public.movimientos_inventario` - Histórico de movimientos
- `public.bitacora_inventario` - Registro detallado de operaciones

### Proveedores
- `public.proveedores` - Proveedores de insumos

### Producción y análisis
- `public.consumo_semanal` - Datos para dashboard ejecutivo
- `public.vista_insumos_estado` - Vista resumida de stock

---

## 👥 Usuarios de Prueba

Después de ejecutar el script SQL, los usuarios disponibles son:

| Email | Contraseña | Rol |
|-------|-----------|-----|
| gerente@salvietti.com | (según configuración) | Gerente |
| jefe@salvietti.com | (según configuración) | Jefe Producción |
| almacen@salvietti.com | (según configuración) | Encargado Almacén |

**Nota**: Las contraseñas en el script SQL están como hash. Debes actualizar con contraseñas reales.

---

## 🎨 Configuración de Colores

Los colores corporativos están configurados en:

- `config/colors.php` - Configuración de colores PHP
- `public/css/main.css` - Variables CSS
- `public/css/theme.css` - Temas visuales

**Colores principales:**
- Verde: `#0FA34A` - Color primario
- Amarillo: `#FFD166` - Color secundario
- Blanco/Gris: `#E0E0E0` - Acento
- Rojo: `#DC2626` - Alertas

---

## 🔧 Configuración en Supabase SQL Editor

### Importar esquema:

1. Abre tu proyecto de Supabase.
2. Entra a SQL Editor.
3. Selecciona `database/salvietti.sql`.
4. Ejecuta el script.

Esto creará las tablas, índices y el trigger de sincronización con `auth.users`.

---

## 📁 Estructura de Carpetas Importantes

```
sistema/
├── app/
│   ├── Models/              # Modelos de datos (Insumo, Lote, etc)
│   └── Http/Controllers/    # Controladores (Dashboard, Inventario, etc)
├── resources/
│   ├── views/               # Vistas HTML/Blade
│   │   ├── layouts/         # Layout principal
│   │   ├── dashboard/       # Vistas del dashboard
│   │   ├── inventario/      # Vistas de inventario
│   │   └── ...
│   └── css/                 # Estilos CSS
├── database/
│   ├── migrations/          # Migraciones Laravel
│   ├── seeders/             # Seeds de datos
│   └── salvietti.sql        # Script SQL
├── config/
│   └── colors.php           # Configuración de colores
├── public/
│   ├── css/                 # CSS compilado
│   ├── js/                  # JavaScript
│   └── images/              # Imágenes y assets
└── routes/                  # Rutas de la aplicación
```

---

## 🔌 Configurar Offline (PWA)

### Service Worker

El Service Worker ya está configurado en `public/js/offline.js`

Para activarlo, agregado en tu layout:
```html
<script>
    if ('serviceWorker' in navigator) {
        navigator.serviceWorker.register('/js/offline.js');
    }
</script>
```

### IndexedDB

Se inicializa automáticamente en `public/js/main.js` con las stores:
- `movimientos` - Movimientos pendientes
- `insumos` - Datos de insumos
- `alertas` - Alertas del sistema

---

## 🆘 Solución de Problemas

### Error: "Connection refused"
- Verifica que MySQL esté corriendo
- Revisa credenciales en `.env`

### Error: "Class not found"
```bash
composer dump-autoload
```

### Permiso denegado en storage
```bash
chmod -R 755 storage/
chmod -R 755 bootstrap/cache/
```

### Port 8000 ya está en uso
```bash
php artisan serve --port=8001
```

---

## 📚 Documentación Adicional

Ver archivos en:
- [README.md](./README.md) - Overview del proyecto
- `database/salvietti.sql` - Documentación de tablas

---

## ✅ Checklist de Instalación

- [ ] Requisitos previos instalados
- [ ] Proyecto descargado en la ruta correcta
- [ ] Composer install ejecutado
- [ ] .env configurado
- [ ] Clave de aplicación generada
- [ ] Base de datos creada
- [ ] Script SQL importado
- [ ] Migraciones ejecutadas (si aplica)
- [ ] Permisos de carpetas configurados
- [ ] Servidor iniciado (php artisan serve)
- [ ] Verificar en http://localhost:8000

---

## 🎯 Próximos Pasos

1. **Crear usuarios reales** en la base de datos
2. **Cargar datos de inventario** (insumos, lotes, etc)
3. **Configurar proveedores** iniciales
4. **Personalizar colores** según brand guidelines
5. **Instalar certificado SSL** para HTTPS
6. **Configurar correo** para alertas
7. **Hacer backup** de la base de datos

---

**Versión**: 1.0  
**Última actualización**: 2026-06-18  
**Estado**: Desarrollo
