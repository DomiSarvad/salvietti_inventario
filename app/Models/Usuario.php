<?php

namespace App\Models;

/**
 * Modelo Usuario
 * Representa los usuarios del sistema con sus roles y permisos
 */
class Usuario
{
    private $id;
    private $nombre;
    private $email;
    private $contrasena;
    private $rol;
    private $empresa;
    private $telefono;
    private $estado;
    private $fecha_creacion;
    private $ultimo_login;

    public function __construct($nombre, $email, $contrasena, $rol)
    {
        $this->nombre = $nombre;
        $this->email = $email;
        $this->contrasena = password_hash($contrasena, PASSWORD_BCRYPT);
        $this->rol = $rol;
        $this->estado = true;
        $this->fecha_creacion = date('Y-m-d H:i:s');
    }

    // Getters y Setters
    public function getId() { return $this->id; }
    public function getNombre() { return $this->nombre; }
    public function setNombre($nombre) { $this->nombre = $nombre; }
    public function getEmail() { return $this->email; }
    public function setEmail($email) { $this->email = $email; }
    public function getRol() { return $this->rol; }
    public function setRol($rol) { $this->rol = $rol; }
    public function getEstado() { return $this->estado; }
    public function setEstado($estado) { $this->estado = $estado; }

    // Métodos de autenticación
    public function login()
    {
        // Lógica de login
        $this->ultimo_login = date('Y-m-d H:i:s');
        return true;
    }

    public function logout()
    {
        // Lógica de logout
        return true;
    }

    // Métodos de validación de permisos
    public function puedeLeer($recurso)
    {
        // Validar permisos de lectura
        return in_array($recurso, $this->obtenerPermisos('lectura'));
    }

    public function puedeEscribir($recurso)
    {
        // Validar permisos de escritura
        return in_array($recurso, $this->obtenerPermisos('escritura'));
    }

    private function obtenerPermisos($tipo)
    {
        // Obtener permisos según el rol
        $permisos = [
            'gerente' => ['*'],
            'jefe_produccion' => ['inventario', 'produccion', 'reportes'],
            'encargado_almacen' => ['inventario.entradas', 'inventario.consulta'],
            'encargado_jarabes' => ['inventario.consulta', 'produccion.consumo']
        ];
        
        return $permisos[$this->rol] ?? [];
    }
}
