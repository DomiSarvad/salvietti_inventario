<?php
/**
 * Archivo de Configuración de Aplicación
 * app.php - Configuración general del sistema
 */

return [
    /*
    |--------------------------------------------------------------------------
    | Nombre de la Aplicación
    |--------------------------------------------------------------------------
    */
    'name' => env('APP_NAME', 'Sistema Salvietti'),
    'version' => '1.0.0',
    'ambiente' => env('APP_ENV', 'production'),
    'debug' => env('APP_DEBUG', false),

    /*
    |--------------------------------------------------------------------------
    | Configuración de Inventario
    |--------------------------------------------------------------------------
    */
    'inventario' => [
        'habilitar_stock_negativo' => false,
        'metodo_valuacion' => 'FIFO', // FIFO, LIFO, Promedio
        'dias_alerta_vencimiento' => 7,
        'dias_alerta_prox_vencer' => 30,
    ],

    /*
    |--------------------------------------------------------------------------
    | Configuración de Alertas
    |--------------------------------------------------------------------------
    */
    'alertas' => [
        'stock_minimo_activo' => true,
        'vencimiento_activo' => true,
        'correo_notificacion' => true,
        'sms_notificacion' => false,
        'frecuencia_check' => 'hourly', // hourly, daily, weekly
    ],

    /*
    |--------------------------------------------------------------------------
    | Configuración de Offline
    |--------------------------------------------------------------------------
    */
    'offline' => [
        'habilitado' => true,
        'cache_size_mb' => 50,
        'sync_automatico' => true,
        'sync_interval_minutos' => 5,
    ],

    /*
    |--------------------------------------------------------------------------
    | Roles y Permisos
    |--------------------------------------------------------------------------
    */
    'roles' => [
        'gerente' => [
            'descripcion' => 'Acceso total al sistema',
            'permisos' => ['*']
        ],
        'jefe_produccion' => [
            'descripcion' => 'Gestión de producción e inventario',
            'permisos' => ['inventario.*', 'produccion.*', 'reportes.ver', 'alertas.ver']
        ],
        'encargado_almacen' => [
            'descripcion' => 'Gestión de almacén',
            'permisos' => ['inventario.entradas', 'inventario.consulta', 'alertas.ver']
        ],
        'encargado_jarabes' => [
            'descripcion' => 'Consumo de insumos',
            'permisos' => ['inventario.consulta', 'produccion.consumo', 'alertas.ver']
        ]
    ],

    /*
    |--------------------------------------------------------------------------
    | Configuración de Colores
    |--------------------------------------------------------------------------
    */
    'colores' => [
        'primario' => '#0FA34A',      // Verde Salvietti
        'secundario' => '#FFD166',     // Amarillo
        'acento' => '#E0E0E0',         // Blanco/Gris
        'peligro' => '#DC2626',        // Rojo
    ],

    /*
    |--------------------------------------------------------------------------
    | Configuración de Módulos
    |--------------------------------------------------------------------------
    */
    'modulos' => [
        'inventario' => true,
        'produccion' => true,
        'proveedores' => true,
        'dashboard' => true,
        'alertas' => true,
        'reportes' => true,
        'usuarios' => true,
    ],

    /*
    |--------------------------------------------------------------------------
    | Configuración de Reportes
    |--------------------------------------------------------------------------
    */
    'reportes' => [
        'formato_predeterminado' => 'PDF', // PDF, Excel, CSV
        'auto_generados' => [
            'diario' => true,
            'semanal' => true,
            'mensual' => true,
        ]
    ],

    /*
    |--------------------------------------------------------------------------
    | Configuración de Base de Datos
    |--------------------------------------------------------------------------
    */
    'database' => [
        'backup_automatico' => true,
        'frecuencia_backup' => 'diaria',
        'retener_backups' => 30, // días
    ],

    /*
    |--------------------------------------------------------------------------
    | Configuración de Sincronización
    |--------------------------------------------------------------------------
    */
    'sincronizacion' => [
        'habilitada' => true,
        'bidireccional' => true,
        'registro_completo' => true,
        'tiempo_retencion_sync' => 30, // días
    ]
];
