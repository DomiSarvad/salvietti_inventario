<?php

namespace App\Models;

/**
 * Modelo Lote
 * Representa los lotes de insumos con información de vencimiento
 */
class Lote
{
    private $id;
    private $codigo_lote;
    private $id_insumo;
    private $cantidad;
    private $proveedor;
    private $fecha_recepcion;
    private $fecha_vencimiento;
    private $cantidad_consumida;

    public function __construct($codigo_lote, $id_insumo, $cantidad, $fecha_vencimiento, $proveedor)
    {
        $this->codigo_lote = $codigo_lote;
        $this->id_insumo = $id_insumo;
        $this->cantidad = $cantidad;
        $this->fecha_vencimiento = $fecha_vencimiento;
        $this->proveedor = $proveedor;
        $this->cantidad_consumida = 0;
        $this->fecha_recepcion = date('Y-m-d H:i:s');
    }

    // Getters y Setters
    public function getId() { return $this->id; }
    public function getCodigoLote() { return $this->codigo_lote; }
    public function getIdInsumo() { return $this->id_insumo; }
    public function getCantidad() { return $this->cantidad; }
    public function getCantidadDisponible() { return $this->cantidad - $this->cantidad_consumida; }
    public function getFechaVencimiento() { return $this->fecha_vencimiento; }
    public function getProveedor() { return $this->proveedor; }

    // Validación de vencimiento
    public function estaVencido()
    {
        $hoy = new \DateTime();
        $vencimiento = new \DateTime($this->fecha_vencimiento);
        return $hoy > $vencimiento;
    }

    public function diasRestantes()
    {
        $hoy = new \DateTime();
        $vencimiento = new \DateTime($this->fecha_vencimiento);
        
        if ($this->estaVencido()) {
            return 0;
        }
        
        $diferencia = $vencimiento->diff($hoy);
        return $diferencia->days;
    }

    public function venceProximamente($dias = 7)
    {
        $dias_restantes = $this->diasRestantes();
        return $dias_restantes > 0 && $dias_restantes <= $dias;
    }

    // Consumo del lote (método FIFO)
    public function consumir($cantidad)
    {
        if ($cantidad > $this->getCantidadDisponible()) {
            throw new \Exception("Cantidad insuficiente en lote " . $this->codigo_lote);
        }
        
        $this->cantidad_consumida += $cantidad;
        return true;
    }

    public function obtenerEstadoVencimiento()
    {
        if ($this->estaVencido()) {
            return 'vencido';
        } elseif ($this->venceProximamente()) {
            return 'proximo_a_vencer';
        }
        return 'valido';
    }
}
