class UsuarioModel {
  final String id;
  final String nombre;
  final String email;
  final String rol;
  final bool activo;

  UsuarioModel({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
    required this.activo,
  });

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? 'Usuario',
      email: map['email']?.toString() ?? '',
      rol: map['rol']?.toString() ?? 'Encargado de Almacén',
      activo: map['activo'] == null ? true : map['activo'] == true || map['activo'] == 'true',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'rol': rol,
      'activo': activo,
    };
  }
}
