-- ============================================================
-- BASE DE DATOS: salvietti_db
-- Sistema de Gestión de Inventario - Salvietti
-- ============================================================

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS salvietti_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE salvietti_db;

-- ============================================================
-- TABLA: usuarios
-- Usuarios del sistema con roles
-- ============================================================
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    rol ENUM('gerente', 'jefe_produccion', 'encargado_almacen', 'encargado_jarabes') NOT NULL,
    empresa VARCHAR(255),
    telefono VARCHAR(20),
    estado BOOLEAN DEFAULT TRUE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    ultimo_login DATETIME,
    INDEX idx_email (email),
    INDEX idx_rol (rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: empleados
-- Información de empleados
-- ============================================================
CREATE TABLE IF NOT EXISTS empleados (
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    nombre_empleado VARCHAR(255) NOT NULL,
    cargo VARCHAR(255),
    telefono_trabajo VARCHAR(20),
    id_usuario INT UNIQUE,
    fecha_contratacion DATE,
    estado BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    INDEX idx_nombre (nombre_empleado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: proveedores
-- Información de proveedores
-- ============================================================
CREATE TABLE IF NOT EXISTS proveedores (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    nombre_proveedor VARCHAR(255) NOT NULL,
    nit VARCHAR(20) UNIQUE,
    contacto_nombre VARCHAR(255),
    contacto_telefono VARCHAR(20),
    telefono_general VARCHAR(20),
    correo_electronico VARCHAR(255),
    ciudad VARCHAR(100),
    direccion TEXT,
    estado BOOLEAN DEFAULT TRUE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_nombre (nombre_proveedor),
    INDEX idx_nit (nit)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: insumos
-- Catálogo de insumos y materias primas
-- ============================================================
CREATE TABLE IF NOT EXISTS insumos (
    id_insumo INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    unidad_medida VARCHAR(50) NOT NULL,
    stock_actual DECIMAL(10, 2) NOT NULL DEFAULT 0,
    stock_minimo DECIMAL(10, 2) NOT NULL,
    ubicacion_almacen VARCHAR(100),
    estado BOOLEAN DEFAULT TRUE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_nombre (nombre),
    INDEX idx_nombre (nombre),
    INDEX idx_stock (stock_actual)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: lotes
-- Lotes de insumos con fecha de vencimiento
-- ============================================================
CREATE TABLE IF NOT EXISTS lotes (
    id_lote INT PRIMARY KEY AUTO_INCREMENT,
    codigo_lote VARCHAR(100) NOT NULL UNIQUE,
    id_insumo INT NOT NULL,
    cantidad DECIMAL(10, 2) NOT NULL,
    cantidad_consumida DECIMAL(10, 2) DEFAULT 0,
    id_proveedor INT,
    fecha_recepcion DATE,
    fecha_vencimiento DATE,
    estado ENUM('valido', 'proximo_a_vencer', 'vencido') DEFAULT 'valido',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_insumo) REFERENCES insumos(id_insumo) ON DELETE CASCADE,
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor) ON DELETE SET NULL,
    INDEX idx_codigo (codigo_lote),
    INDEX idx_insumo (id_insumo),
    INDEX idx_fecha_venc (fecha_vencimiento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: movimientos_inventario
-- Registro de todos los movimientos
-- ============================================================
CREATE TABLE IF NOT EXISTS movimientos_inventario (
    id_movimiento INT PRIMARY KEY AUTO_INCREMENT,
    id_insumo INT NOT NULL,
    tipo ENUM('entrada', 'salida', 'consumo') NOT NULL,
    cantidad DECIMAL(10, 2) NOT NULL,
    id_lote INT,
    id_empleado INT,
    fecha_movimiento DATETIME DEFAULT CURRENT_TIMESTAMP,
    nota TEXT,
    sincronizado BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_insumo) REFERENCES insumos(id_insumo) ON DELETE CASCADE,
    FOREIGN KEY (id_lote) REFERENCES lotes(id_lote) ON DELETE SET NULL,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado) ON DELETE SET NULL,
    INDEX idx_tipo (tipo),
    INDEX idx_fecha (fecha_movimiento),
    INDEX idx_insumo (id_insumo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: entradas_insumo
-- Registro de entradas de insumos
-- ============================================================
CREATE TABLE IF NOT EXISTS entradas_insumo (
    id_entrada INT PRIMARY KEY AUTO_INCREMENT,
    id_lote INT NOT NULL,
    factura VARCHAR(100),
    nota_entrega VARCHAR(255),
    cantidad_recibida DECIMAL(10, 2) NOT NULL,
    estado ENUM('confirmada', 'pendiente') DEFAULT 'pendiente',
    fecha_entrada DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_lote) REFERENCES lotes(id_lote) ON DELETE CASCADE,
    INDEX idx_lote (id_lote),
    INDEX idx_fecha (fecha_entrada)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: ordenes_produccion
-- Órdenes de producción
-- ============================================================
CREATE TABLE IF NOT EXISTS ordenes_produccion (
    id_orden INT PRIMARY KEY AUTO_INCREMENT,
    codigo_orden VARCHAR(100) NOT NULL UNIQUE,
    producto VARCHAR(255),
    cantidad_producida DECIMAL(10, 2),
    estado ENUM('activa', 'completada', 'cancelada') DEFAULT 'activa',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_finalizacion DATE,
    INDEX idx_codigo (codigo_orden),
    INDEX idx_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: detalles_consumo
-- Detalle de consumo por orden de producción
-- ============================================================
CREATE TABLE IF NOT EXISTS detalles_consumo (
    id_detalle INT PRIMARY KEY AUTO_INCREMENT,
    id_movimiento INT NOT NULL,
    id_orden INT NOT NULL,
    cantidad_consumida DECIMAL(10, 2) NOT NULL,
    costo_consumo DECIMAL(12, 2),
    FOREIGN KEY (id_movimiento) REFERENCES movimientos_inventario(id_movimiento) ON DELETE CASCADE,
    FOREIGN KEY (id_orden) REFERENCES ordenes_produccion(id_orden) ON DELETE CASCADE,
    INDEX idx_orden (id_orden)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: alertas
-- Sistema de alertas
-- ============================================================
CREATE TABLE IF NOT EXISTS alertas (
    id_alerta INT PRIMARY KEY AUTO_INCREMENT,
    tipo ENUM('stock_minimo', 'vencimiento', 'critico') NOT NULL,
    id_insumo INT,
    id_lote INT,
    mensaje TEXT NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    leida BOOLEAN DEFAULT FALSE,
    id_usuario INT,
    FOREIGN KEY (id_insumo) REFERENCES insumos(id_insumo) ON DELETE CASCADE,
    FOREIGN KEY (id_lote) REFERENCES lotes(id_lote) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    INDEX idx_tipo (tipo),
    INDEX idx_fecha (fecha_creacion),
    INDEX idx_usuario (id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: salidas_insumo
-- Registro de salidas de insumos
-- ============================================================
CREATE TABLE IF NOT EXISTS salidas_insumo (
    id_salida INT PRIMARY KEY AUTO_INCREMENT,
    id_insumo INT NOT NULL,
    area_destino VARCHAR(100),
    cantidad DECIMAL(10, 2) NOT NULL,
    fecha_salida DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT,
    confirmada BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_insumo) REFERENCES insumos(id_insumo) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    INDEX idx_fecha (fecha_salida),
    INDEX idx_insumo (id_insumo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: sincronizador_offline
-- Datos pendientes de sincronización
-- ============================================================
CREATE TABLE IF NOT EXISTS sincronizador_offline (
    id_sincronizacion INT PRIMARY KEY AUTO_INCREMENT,
    cola_pendientes JSON,
    estado_red BOOLEAN,
    ultima_sincronizacion DATETIME,
    INDEX idx_estado (estado_red)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: dashboard
-- Datos del dashboard ejecutivo
-- ============================================================
CREATE TABLE IF NOT EXISTS dashboard (
    id_dashboard INT PRIMARY KEY AUTO_INCREMENT,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_fecha (fecha_actualizacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- ÍNDICES DE RENDIMIENTO
-- ============================================================

-- Crear índices compuestos para búsquedas comunes
CREATE INDEX idx_insumo_fecha ON movimientos_inventario(id_insumo, fecha_movimiento);
CREATE INDEX idx_lote_insumo ON lotes(id_insumo, fecha_vencimiento);
CREATE INDEX idx_usuario_rol ON usuarios(rol, estado);

-- ============================================================
-- INSERTAR DATOS DE PRUEBA
-- ============================================================

-- Usuario de prueba
INSERT INTO usuarios (nombre, email, contrasena, rol, empresa, telefono, estado) VALUES
('Gerente Sistema', 'gerente@salvietti.com', '$2y$10$hash_bcrypt_aqui', 'gerente', 'Salvietti', '1234567890', TRUE),
('Jefe Producción', 'jefe@salvietti.com', '$2y$10$hash_bcrypt_aqui', 'jefe_produccion', 'Salvietti', '0987654321', TRUE),
('Almacén', 'almacen@salvietti.com', '$2y$10$hash_bcrypt_aqui', 'encargado_almacen', 'Salvietti', '1111111111', TRUE);

-- Proveedores de prueba
INSERT INTO proveedores (nombre_proveedor, nit, contacto_nombre, contacto_email, telefono_general, estado) VALUES
('Proveedor A', '123456789', 'Juan Pérez', 'juan@proveedora.com', '5551234567', TRUE),
('Proveedor B', '987654321', 'María García', 'maria@proveedorb.com', '5559876543', TRUE);

-- Insumos de prueba (TAPAS)
INSERT INTO insumos (nombre, unidad_medida, stock_minimo, ubicacion_almacen) VALUES
('Tapa Short 32oz', 'unidad', 500, 'TAPAS-A1'),
('Tapa Pet 16oz', 'unidad', 300, 'TAPAS-A2'),
('Tapa Pet 24oz', 'unidad', 400, 'TAPAS-A3');

-- Insumos de prueba (PREFORMAS)
INSERT INTO insumos (nombre, unidad_medida, stock_minimo, ubicacion_almacen) VALUES
('Preforma 32oz', 'unidad', 1000, 'PREFORMAS-B1'),
('Preforma 24oz', 'unidad', 800, 'PREFORMAS-B2'),
('Preforma 20oz', 'unidad', 600, 'PREFORMAS-B3');

-- ============================================================
-- VISTAS ÚTILES
-- ============================================================

-- Vista de insumos con estado actual
CREATE VIEW vista_insumos_estado AS
SELECT 
    i.id_insumo,
    i.nombre,
    i.unidad_medida,
    i.stock_actual,
    i.stock_minimo,
    CASE 
        WHEN i.stock_actual < i.stock_minimo THEN 'critico'
        WHEN i.stock_actual < (i.stock_minimo * 1.5) THEN 'bajo'
        ELSE 'normal'
    END AS estado,
    CASE 
        WHEN i.stock_actual < i.stock_minimo THEN 'rojo'
        WHEN i.stock_actual < (i.stock_minimo * 1.5) THEN 'amarillo'
        ELSE 'verde'
    END AS indicador
FROM insumos i
WHERE i.estado = TRUE;

-- Vista de movimientos por período
CREATE VIEW vista_movimientos_periodo AS
SELECT 
    DATE(m.fecha_movimiento) AS fecha,
    m.tipo,
    COUNT(*) AS total_movimientos,
    SUM(m.cantidad) AS cantidad_total,
    i.nombre AS insumo
FROM movimientos_inventario m
JOIN insumos i ON m.id_insumo = i.id_insumo
GROUP BY DATE(m.fecha_movimiento), m.tipo, i.id_insumo;

-- Vista de lotes por vencer
CREATE VIEW vista_lotes_vencer AS
SELECT 
    l.id_lote,
    l.codigo_lote,
    i.nombre AS insumo,
    l.cantidad,
    l.cantidad_consumida,
    (l.cantidad - l.cantidad_consumida) AS cantidad_disponible,
    l.fecha_vencimiento,
    DATEDIFF(l.fecha_vencimiento, CURDATE()) AS dias_restantes,
    CASE 
        WHEN DATEDIFF(l.fecha_vencimiento, CURDATE()) <= 0 THEN 'vencido'
        WHEN DATEDIFF(l.fecha_vencimiento, CURDATE()) <= 7 THEN 'critico'
        WHEN DATEDIFF(l.fecha_vencimiento, CURDATE()) <= 30 THEN 'proximo'
        ELSE 'normal'
    END AS estado_vencimiento
FROM lotes l
JOIN insumos i ON l.id_insumo = i.id_insumo
WHERE l.estado != 'vencido';

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
