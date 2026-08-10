<?php

namespace App\Models;

/**
 * Modelo Alerta
 * Sistema de notificaciones para stock mínimo y vencimiento
 */
class Alerta
{
    private $id;
    private $tipo; // 'stock_minimo', 'vencimiento', 'critico'
    private $id_insumo;
    private $mensaje;
    private $fecha_creacion;
    private $leida;
    private $id_usuario;

    public function __construct($tipo, $id_insumo, $mensaje, $id_usuario)
    {
        $this->tipo = $tipo;
        $this->id_insumo = $id_insumo;
        $this->mensaje = $mensaje;
        $this->id_usuario = $id_usuario;
        $this->fecha_creacion = date('Y-m-d H:i:s');
        $this->leida = false;
    }

    // Getters y Setters
    public function getId() { return $this->id; }
    public function getTipo() { return $this->tipo; }
    public function getIdInsumo() { return $this->id_insumo; }
    public function getMensaje() { return $this->mensaje; }
    public function getFechaCreacion() { return $this->fecha_creacion; }
    public function isLeida() { return $this->leida; }
    public function marcarComoLeida() { $this->leida = true; }

    // Generar alertas automáticamente
    public static function generarAlertaStockMinimo($insumo)
    {
        if ($insumo->verificarStockCritico()) {
            $mensaje = "Stock bajo para " . $insumo->getNombre();
            return new self('stock_minimo', $insumo->getId(), $mensaje, 1);
        }
        return null;
    }

    public static function generarAlertaVencimiento($lote)
    {
        if ($lote->venceProximamente()) {
            $mensaje = "Lote " . $lote->getCodigoLote() . " vence en " . $lote->diasRestantes() . " días";
            return new self('vencimiento', $lote->getIdInsumo(), $mensaje, 1);
        }
        return null;
    }

    public function obtenerColor()
    {
        switch ($this->tipo) {
            case 'critico':
                return 'rojo';
            case 'vencimiento':
                return 'amarillo';
            default:
                return 'azul';
        }
    }
}
