# Guía de Instalación y Configuración
# Sistema de Gestión de Inventario - Salvietti

## 📋 Requisitos Previos

- PHP 8.1 o superior
- MySQL 8.0 o superior
- Composer
- Node.js 14+ (opcional)
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

```bash
copy .env.example .env
```

Editar `.env` y configurar:
```
APP_NAME="Sistema Salvietti"
APP_ENV=local
APP_KEY=base64:TuClaveAqui
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=salvietti_db
DB_USERNAME=root
DB_PASSWORD=TuContraseña
```

### 4. Generar Clave de Aplicación

```bash
php artisan key:generate
```

### 5. Crear Base de Datos MySQL

#### Opción A: Usando MySQL CLI

```bash
mysql -u root -p
CREATE DATABASE salvietti_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
exit;
```

#### Opción B: Ejecutar Script SQL

```bash
mysql -u root -p salvietti_db < database/salvietti.sql
```

### 6. Ejecutar Migraciones (si usas Laravel)

```bash
php artisan migrate
php artisan db:seed
```

### 7. Dar Permisos a Carpetas

En Windows (PowerShell como admin):
```powershell
# Si es necesario, dar permisos a storage
icacls "C:\Users\HP\Desktop\Trabajos\CCA 2026\Salvietti\sistema\storage" /grant Users:F /T
```

### 8. Iniciar Servidor de Desarrollo

```bash
php artisan serve
```

La aplicación estará disponible en: `http://localhost:8000`

---

## 🗄️ Estructura de Base de Datos

La base de datos incluye las siguientes tablas principales:

### Gestión de Usuarios
- `usuarios` - Usuarios del sistema con roles
- `empleados` - Información de empleados

### Inventario
- `insumos` - Catálogo de materias primas
- `lotes` - Lotes con fecha de vencimiento
- `movimientos_inventario` - Histórico de movimientos

### Proveedores
- `proveedores` - Información de proveedores

### Producción
- `ordenes_produccion` - Órdenes de producción
- `detalles_consumo` - Consumos por orden

### Sistema
- `alertas` - Alertas del sistema
- `salidas_insumo` - Registro de salidas
- `sincronizador_offline` - Control de sincronización

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

## 🔧 Configuración en MySQL Workbench

### Crear conexión en Workbench:

1. Abrir MySQL Workbench
2. Click en `+` para nueva conexión
3. Configurar:
   - **Connection Name**: Salvietti
   - **Hostname**: 127.0.0.1
   - **Port**: 3306
   - **Username**: root
   - **Password**: (tu contraseña)

4. Test Connection
5. Doble-click para conectar

### Importar esquema:

1. Ir a: File > Import SQL Script
2. Seleccionar: `database/salvietti.sql`
3. Ejecutar

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
