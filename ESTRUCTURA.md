```
ESTRUCTURA COMPLETA DEL PROYECTO SALVIETTI
===========================================

sistema/
│
├── 📄 README.md                          # Documentación principal
├── 📄 INSTALACION.md                     # Guía de instalación
├── 📄 composer.json                      # Dependencias PHP
├── 📄 .env.example                       # Variables de entorno ejemplo
│
├── 📁 app/                               # Código de aplicación
│   ├── Models/                           # Modelos de datos
│   │   ├── Usuario.php
│   │   ├── Insumo.php
│   │   ├── Lote.php
│   │   ├── MovimientoInventario.php
│   │   ├── Proveedor.php
│   │   └── Alerta.php
│   │
│   └── Http/
│       ├── Controllers/                  # Controladores MVC
│       │   ├── DashboardController.php
│       │   ├── InventarioController.php
│       │   └── ProveedoresController.php
│       │
│       └── Middleware/                   # Middleware personalizado
│
├── 📁 resources/                         # Recursos (vistas, CSS, JS)
│   ├── views/
│   │   ├── layouts/
│   │   │   └── app.blade.php             # Layout principal
│   │   ├── dashboard/
│   │   │   └── index.blade.php           # Dashboard ejecutivo
│   │   ├── inventario/
│   │   │   ├── index.blade.php
│   │   │   ├── entrada.blade.php
│   │   │   ├── consumo.blade.php
│   │   │   └── stock.blade.php
│   │   ├── produccion/                   # Vistas de producción
│   │   ├── proveedores/                  # Vistas de proveedores
│   │   ├── usuarios/                     # Vistas de usuarios
│   │   └── alertas/                      # Vistas de alertas
│   │
│   ├── css/                              # Estilos fuente
│   │   └── estilos.css
│   │
│   └── js/                               # JavaScript fuente
│       └── scripts.js
│
├── 📁 database/                          # Base de datos
│   ├── migrations/                       # Migraciones Laravel
│   ├── seeders/                          # Seeds de datos
│   └── salvietti.sql                     # Script SQL completo
│
├── 📁 config/                            # Configuración
│   ├── app.php                           # Configuración general
│   └── colors.php                        # Colores corporativos
│
├── 📁 routes/                            # Rutas
│   └── routes.php                        # Definición de rutas
│
├── 📁 public/                            # Archivos públicos (web root)
│   ├── index.php                         # Entrada principal
│   │
│   ├── css/                              # Estilos compilados
│   │   ├── main.css                      # Estilos principales
│   │   └── theme.css                     # Tema y personalización
│   │
│   ├── js/                               # JavaScript compilado
│   │   ├── main.js                       # Script principal
│   │   └── offline.js                    # Service Worker offline
│   │
│   └── images/                           # Imágenes y assets
│       └── logo.png                      # Logo de Salvietti
│
└── 📁 storage/                           # Almacenamiento
    ├── app/                              # Archivos de aplicación
    ├── logs/                             # Logs del sistema
    └── cache/                            # Caché


COLORES CORPORATIVOS
====================

Verde Primario:    #0FA34A  (rgb(15, 163, 74))
Amarillo:          #FFD166  (rgb(255, 209, 102))
Blanco/Gris:       #E0E0E0  (rgb(224, 224, 224))
Rojo Alertas:      #DC2626  (rgb(220, 38, 38))


MODELOS DE DATOS (MVC)
======================

USUARIOS
├── Autenticación
├── Roles (Gerente, Jefe, Encargado, etc)
└── Permisos

INSUMOS
├── Nombre, unidad de medida
├── Stock actual y mínimo
├── Ubicación en almacén
└── Estado

LOTES
├── Código, cantidad
├── Fecha vencimiento
├── Proveedor
└── Estado FIFO

MOVIMIENTOS
├── Entradas de materia prima
├── Salidas/Consumos
├── Sincronización offline
└── Registro histórico

ALERTAS
├── Stock mínimo
├── Próximo a vencer
├── Stock crítico
└── Notificaciones


FUNCIONALIDADES PRINCIPALES
============================

✅ Registro de entradas de materia prima
✅ Consulta de stock en tiempo real
✅ Alertas de stock mínimo y vencimiento
✅ Registro de consumo por orden
✅ Dashboard ejecutivo
✅ Gestión de proveedores
✅ Funcionamiento offline
✅ Sincronización automática
✅ Indicadores semafóricos (verde/amarillo/rojo)


TABLAS DE BASE DE DATOS
=======================

MASTER
├── usuarios
├── empleados
├── proveedores
├── insumos

TRANSACCIONALES
├── lotes
├── movimientos_inventario
├── entradas_insumo
├── salidas_insumo
├── detalles_consumo

OPERACIONALES
├── ordenes_produccion
├── alertas
├── sincronizador_offline

REFERENCIA
└── dashboard


RUTAS PRINCIPALES
=================

Dashboard:      /dashboard
Inventario:     /inventario
Entradas:       /inventario/entradas
Consumo:        /inventario/consumo
Proveedores:    /proveedores
Alertas:        /alertas
Usuarios:       /usuarios
API:            /api/*


REQUISITOS TÉCNICOS
===================

Backend:
  • PHP 8.1+
  • Laravel 10
  • MySQL 8.0+

Frontend:
  • HTML5
  • CSS3
  • JavaScript Vanilla
  • Service Worker
  • IndexedDB

Offline:
  • Service Worker
  • Cache API
  • IndexedDB
  • Sincronización

Servidor:
  • Apache/Nginx
  • Composer
  • Node.js (opcional)


INSTALACIÓN RÁPIDA
==================

1. cd sistema
2. composer install
3. cp .env.example .env
4. php artisan key:generate
5. mysql < database/salvietti.sql
6. php artisan serve
7. Acceder: http://localhost:8000


VERSIÓN Y ESTADO
================

Versión:  1.0.0
Estado:   Desarrollo
Fecha:    2026-06-18
License:  Privada - Salvietti

```
