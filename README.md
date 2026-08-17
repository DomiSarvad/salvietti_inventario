
## Descripción
Sistema web progresivo (PWA) para la gestión integral del inventario de materia prima e insumos de la empresa Salvietti. 

## Características Principales
- ✅ Registro de entradas de materia prima
- ✅ Registro de consumo por orden de producción
- ✅ Consulta de stock en tiempo real
- ✅ Alertas de stock mínimo y vencimiento
- ✅ Módulo predictivo de rotación
- ✅ Dashboard ejecutivo
- ✅ Gestión de proveedores
- ✅ Sincronización offline/online
- ✅ Soporte multiusuario con roles

## Stack Tecnológico
- **Frontend/App**: Flutter + Dart
- **Base de Datos**: Supabase + PostgreSQL
- **Autenticación**: Supabase Auth
- **Persistencia local**: Hive + sincronización offline
- **Plataformas**: Android, Windows, Web y móvil híbrido

## Estructura de Carpetas

```
sistema/
├── app/
│   ├── Models/              # Modelos de datos
│   ├── Http/
│   │   ├── Controllers/     # Controladores
│   │   └── Middleware/      # Middleware personalizado
├── resources/
│   ├── views/               # Vistas (HTML)
│   │   ├── layouts/         # Layouts base
│   │   ├── dashboard/       # Vistas del dashboard
│   │   ├── inventario/      # Vistas de inventario
│   │   ├── produccion/      # Vistas de producción
│   │   └── ...
│   ├── css/                 # Estilos
│   └── js/                  # Scripts frontend
├── database/
│   ├── migrations/          # Migraciones de BD
│   └── seeders/             # Seeds de datos
├── config/                  # Archivos de configuración
├── routes/                  # Rutas de la aplicación
├── public/                  # Archivos públicos
└── storage/                 # Archivos generados
```

## Colores de la Marca
- 🟢 **Verde**: #0FA34A (Primario)
- 🟡 **Amarillo**: #FFD166 (Secundario)
- ⚪ **Blanco/Gris**: #E0E0E0 (Acento)
- 🔴 **Rojo**: #DC2626 (Alertas)

## Instalación

### Requisitos
- PHP 8.1+
- MySQL 8.0+
- Composer
- Node.js (opcional, para assets)

### Pasos
1. Clonar el repositorio
2. Copiar `.env.example` a `.env`
3. Configurar base de datos en `.env`
4. Ejecutar: `composer install`
5. Ejecutar: `php artisan migrate`
6. Ejecutar: `php artisan serve`

## Módulos Principales

### 1. Inventario
- Registro de entradas
- Consulta de stock
- Gestión de lotes
- Alertas de stock

### 2. Producción
- Órdenes de producción
- Registro de consumo
- Trazabilidad

### 3. Proveedores
- Gestión de proveedores
- Historial de compras

### 4. Dashboard
- Indicadores clave
- Gráficos de consumo
- Análisis predictivo

## Modelos de Datos

- **Usuario**: Empleados del sistema
- **Empleado**: Datos laborales
- **Insumo**: Materias primas y insumos
- **Lote**: Partidas de insumos
- **Movimiento**: Histórico de movimientos
- **Proveedor**: Proveedores de insumos
- **OrdenProduccion**: Órdenes de producción
- **Alerta**: Sistema de notificaciones

## API y Funcionalidades

### Endpoints Principales
- `/api/inventario` - Gestión de inventario
- `/api/proveedores` - Gestión de proveedores
- `/api/produccion` - Órdenes de producción
- `/api/alertas` - Sistema de alertas
- `/api/dashboard` - Datos del dashboard

## Roles y Permisos

- **Gerente**: Acceso total, reportes
- **Jefe de Producción**: Producción, inventario, análisis
- **Encargado de Almacén**: Registro de entradas, consulta stock
- **Encargado de Jarabes**: Consumo de insumos específicos

## Contribuciones
Para contribuir al proyecto, por favor crear un branch con tu feature y enviar un pull request.

## Soporte
Para reportar issues o solicitar features, contactar al equipo de desarrollo.

## Licencia
Privada - Salvietti
