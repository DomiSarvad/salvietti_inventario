<?php

namespace App\Models;

/**
 * Modelo Insumo
 * Representa los insumos y materias primas del sistema
 */
class Insumo
{
    private $id;
    private $nombre;
    private $unidad_medida;
    private $stock_actual;
    private $stock_minimo;
    private $ubicacion_almacen;
    private $estado;
    private $fecha_creacion;

    public function __construct($nombre, $unidad_medida, $stock_minimo)
    {
        $this->nombre = $nombre;
        $this->unidad_medida = $unidad_medida;
        $this->stock_minimo = $stock_minimo;
        $this->stock_actual = 0;
        $this->estado = true;
        $this->fecha_creacion = date('Y-m-d H:i:s');
    }

    // Getters y Setters
    public function getId() { return $this->id; }
    public function getNombre() { return $this->nombre; }
    public function setNombre($nombre) { $this->nombre = $nombre; }
    public function getUnidadMedida() { return $this->unidad_medida; }
    public function getStockActual() { return $this->stock_actual; }
    public function setStockActual($cantidad) { $this->stock_actual = $cantidad; }
    public function getStockMinimo() { return $this->stock_minimo; }
    public function setStockMinimo($minimo) { $this->stock_minimo = $minimo; }
    public function getEstado() { return $this->estado; }

    // Métodos de validación
    public function verificarStockCritico()
    {
        return $this->stock_actual < $this->stock_minimo;
    }

    public function calcularDiasExistencia($consumo_diario)
    {
        if ($consumo_diario <= 0) return 0;
        return round($this->stock_actual / $consumo_diario, 2);
    }

    public function tieneStockDisponible($cantidad)
    {
        return $this->stock_actual >= $cantidad;
    }

    // Métodos de movimiento
    public function aumentarStock($cantidad, $razon = 'Entrada')
    {
        $this->stock_actual += $cantidad;
        // Registrar movimiento
        return true;
    }

    public function disminuirStock($cantidad, $razon = 'Salida')
    {
        if (!$this->tieneStockDisponible($cantidad)) {
            throw new \Exception("Stock insuficiente para " . $this->nombre);
        }
        $this->stock_actual -= $cantidad;
        // Registrar movimiento
        return true;
    }

    // Método para obtener el estado visual del stock
    public function obtenerEstadoVisual()
    {
        if ($this->stock_actual == 0) {
            return 'rojo'; // Stock crítico
        } elseif ($this->stock_actual < $this->stock_minimo) {
            return 'amarillo'; // Por debajo del mínimo
        }
        return 'verde'; // Óptimo
    }
}
