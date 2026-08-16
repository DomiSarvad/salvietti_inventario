class InsumoModel {
  final String id;
  final String nombre;
  final double stockActual;
  final String unidadMedida;
  final String numeroLote;
  final DateTime? fechaVencimiento;
  final String proveedorId;
  final String proveedorNombre;
  final double consumoPromedio7;
  final double consumoPromedio15;
  final double consumoPromedio30;
  final double cantidadMinima;
  final double puntoRetorno;
  final DateTime? ultimoMovimiento;
  final bool activo;

  InsumoModel({
    required this.id,
    required this.nombre,
    required this.stockActual,
    required this.unidadMedida,
    required this.numeroLote,
    required this.fechaVencimiento,
    required this.proveedorId,
    required this.proveedorNombre,
    required this.consumoPromedio7,
    required this.consumoPromedio15,
    required this.consumoPromedio30,
    required this.cantidadMinima,
    required this.puntoRetorno,
    required this.ultimoMovimiento,
    required this.activo,
  });

  factory InsumoModel.fromMap(Map<String, dynamic> map) {
    DateTime? vencimiento;
    DateTime? ultimoMovimiento;

    if (map['fecha_vencimiento'] != null) {
      vencimiento = DateTime.tryParse(map['fecha_vencimiento'].toString());
    }
    if (map['ultimo_movimiento'] != null) {
      ultimoMovimiento = DateTime.tryParse(map['ultimo_movimiento'].toString());
    }

    return InsumoModel(
      id: map['id']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? 'Desconocido',
      stockActual: (map['stock_actual'] ?? 0).toDouble(),
      unidadMedida: map['unidad_medida']?.toString() ?? 'uds',
      numeroLote: map['numero_lote']?.toString() ?? 'N/A',
      fechaVencimiento: vencimiento,
      proveedorId: map['proveedor_id']?.toString() ?? '',
      proveedorNombre: map['proveedor_nombre']?.toString() ?? 'N/D',
      consumoPromedio7: (map['consumo_promedio_7'] ?? 0).toDouble(),
      consumoPromedio15: (map['consumo_promedio_15'] ?? 0).toDouble(),
      consumoPromedio30: (map['consumo_promedio_30'] ?? 0).toDouble(),
      cantidadMinima: (map['cantidad_minima'] ?? 0).toDouble(),
      puntoRetorno: (map['punto_retorno'] ?? 0).toDouble(),
      ultimoMovimiento: ultimoMovimiento,
      activo: map['activo'] == null ? true : map['activo'] == true || map['activo'] == 'true',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'stock_actual': stockActual,
      'unidad_medida': unidadMedida,
      'numero_lote': numeroLote,
      'fecha_vencimiento': fechaVencimiento?.toIso8601String(),
      'proveedor_id': proveedorId,
      'proveedor_nombre': proveedorNombre,
      'consumo_promedio_7': consumoPromedio7,
      'consumo_promedio_15': consumoPromedio15,
      'consumo_promedio_30': consumoPromedio30,
      'cantidad_minima': cantidadMinima,
      'punto_retorno': puntoRetorno,
      'ultimo_movimiento': ultimoMovimiento?.toIso8601String(),
      'activo': activo,
    };
  }

  double get diasRestantes {
    if (consumoPromedio30 <= 0) {
      return double.infinity;
    }
    return stockActual / consumoPromedio30;
  }

  bool get esCritico {
    return stockActual <= cantidadMinima || diasRestantes <= 3;
  }

  bool get enObservacion {
    return !esCritico && stockActual <= puntoRetorno;
  }

  bool get rotacionLenta {
    if (ultimoMovimiento == null) {
      return true;
    }
    final diferencia = DateTime.now().difference(ultimoMovimiento!);
    return diferencia.inDays >= 10;
  }
}
