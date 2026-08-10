<?php

namespace App\Models;

/**
 * Modelo MovimientoInventario
 * Registra todos los movimientos de inventario (entradas, salidas, consumos)
 */
class MovimientoInventario
{
    private $id;
    private $id_insumo;
    private $tipo; // 'entrada', 'salida', 'consumo'
    private $cantidad;
    private $fecha;
    private $usuario;
    private $nota;
    private $sincronizado;
    private $id_lote;

    public function __construct($id_insumo, $tipo, $cantidad, $usuario, $id_lote = null)
    {
        $this->id_insumo = $id_insumo;
        $this->tipo = $tipo;
        $this->cantidad = $cantidad;
        $this->usuario = $usuario;
        $this->id_lote = $id_lote;
        $this->fecha = date('Y-m-d H:i:s');
        $this->sincronizado = false;
    }

    // Getters y Setters
    public function getId() { return $this->id; }
    public function getIdInsumo() { return $this->id_insumo; }
    public function getTipo() { return $this->tipo; }
    public function getCantidad() { return $this->cantidad; }
    public function getFecha() { return $this->fecha; }
    public function getUsuario() { return $this->usuario; }
    public function getNota() { return $this->nota; }
    public function setNota($nota) { $this->nota = $nota; }
    public function isSincronizado() { return $this->sincronizado; }
    public function setSincronizado($valor) { $this->sincronizado = $valor; }

    // Métodos de validación
    public function esValido()
    {
        $tipos_validos = ['entrada', 'salida', 'consumo'];
        return in_array($this->tipo, $tipos_validos) && $this->cantidad > 0;
    }

    // Registrar movimiento
    public function registrar()
    {
        if (!$this->esValido()) {
            throw new \Exception("Movimiento no válido");
        }
        // Guardar en BD local (IndexedDB)
        return true;
    }

    // Sincronizar con servidor
    public function sincronizar()
    {
        // Enviar al servidor
        $this->sincronizado = true;
        return true;
    }

    public function obtenerDescripcion()
    {
        $descripcion = [
            'entrada' => 'Entrada de materia prima',
            'salida' => 'Salida de almacén',
            'consumo' => 'Consumo por producción'
        ];
        
        return $descripcion[$this->tipo] ?? 'Movimiento';
    }
}
