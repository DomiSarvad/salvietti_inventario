<?php
/**
 * Routes - Rutas principales del sistema
 */

// Archivo de rutas de la aplicación
// Aquí se definirán todos los endpoints del sistema

return [
    'base_url' => env('APP_URL', 'http://localhost'),
    'api_prefix' => '/api',
    'routes' => [
        // Rutas de autenticación
        'auth' => [
            'login' => '/login',
            'logout' => '/logout',
            'register' => '/register'
        ],
        
        // Rutas de Dashboard
        'dashboard' => [
            'index' => '/dashboard',
            'data' => '/api/dashboard/data'
        ],
        
        // Rutas de Inventario
        'inventario' => [
            'index' => '/inventario',
            'entradas' => '/inventario/entradas',
            'salidas' => '/inventario/salidas',
            'stock' => '/api/inventario/stock',
            'movimientos' => '/api/inventario/movimientos'
        ],
        
        // Rutas de Producción
        'produccion' => [
            'ordenes' => '/produccion/ordenes',
            'consumos' => '/produccion/consumos',
            'api' => '/api/produccion'
        ],
        
        // Rutas de Proveedores
        'proveedores' => [
            'index' => '/proveedores',
            'crear' => '/proveedores/crear',
            'editar' => '/proveedores/:id/editar',
            'api' => '/api/proveedores'
        ],
        
        // Rutas de Alertas
        'alertas' => [
            'index' => '/alertas',
            'api' => '/api/alertas'
        ],
        
        // Rutas de Usuarios
        'usuarios' => [
            'index' => '/usuarios',
            'crear' => '/usuarios/crear',
            'editar' => '/usuarios/:id/editar',
            'api' => '/api/usuarios'
        ]
    ]
];
