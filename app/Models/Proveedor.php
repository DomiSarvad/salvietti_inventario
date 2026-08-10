<?php

namespace App\Models;

/**
 * Modelo Proveedor
 * Gestiona la información de proveedores
 */
class Proveedor
{
    private $id;
    private $nombre;
    private $nit;
    private $contacto_nombre;
    private $contacto_telefono;
    private $contacto_email;
    private $ciudad;
    private $direccion;
    private $insumos_suministrados; // Array de insumos
    private $estado;
    private $fecha_creacion;

    public function __construct($nombre, $nit, $contacto_email)
    {
        $this->nombre = $nombre;
        $this->nit = $nit;
        $this->contacto_email = $contacto_email;
        $this->insumos_suministrados = [];
        $this->estado = true;
        $this->fecha_creacion = date('Y-m-d H:i:s');
    }

    // Getters y Setters
    public function getId() { return $this->id; }
    public function getNombre() { return $this->nombre; }
    public function setNombre($nombre) { $this->nombre = $nombre; }
    public function getNit() { return $this->nit; }
    public function getContactoEmail() { return $this->contacto_email; }
    public function setContactoEmail($email) { $this->contacto_email = $email; }
    public function getEstado() { return $this->estado; }
    public function setEstado($estado) { $this->estado = $estado; }

    // Métodos de insumos
    public function agregarInsumo($id_insumo)
    {
        if (!in_array($id_insumo, $this->insumos_suministrados)) {
            $this->insumos_suministrados[] = $id_insumo;
        }
    }

    public function eliminarInsumo($id_insumo)
    {
        $key = array_search($id_insumo, $this->insumos_suministrados);
        if ($key !== false) {
            unset($this->insumos_suministrados[$key]);
        }
    }

    public function getInsumosSuministrados()
    {
        return $this->insumos_suministrados;
    }

    // Registrar proveedor
    public function registrar()
    {
        if (empty($this->nombre) || empty($this->nit)) {
            throw new \Exception("Nombre y NIT son requeridos");
        }
        return true;
    }

    // Actualizar proveedor
    public function actualizar()
    {
        return $this->registrar();
    }
}
