import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/insumo_model.dart';
import '../models/usuario_model.dart';
import 'hive_service.dart';

class DatabaseService {
  static SupabaseClient? _client;

  static Future<void> initSupabase({required String url, required String publishableKey}) async {
    if (_client == null) {
      await Supabase.initialize(url: url, publishableKey: publishableKey);
      _client = Supabase.instance.client;
    }
  }

  static bool get isInitialized => _client != null;

  static Future<UsuarioModel> login({required String email, required String password}) async {
    if (!isInitialized) {
      throw Exception('Supabase no está inicializado');
    }

    final response = await _client!.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw Exception('Credenciales inválidas');
    }

    final metadata = user.userMetadata ?? <String, dynamic>{};
    final role = metadata['role']?.toString() ?? 'Encargado de Almacén';
    final nombre = metadata['nombre']?.toString() ?? user.email ?? 'Usuario';

    final usuario = UsuarioModel(
      id: user.id,
      nombre: nombre,
      email: email,
      rol: role,
      activo: true,
    );

    await saveAuditLog(
      usuarioId: usuario.id,
      evento: 'Inicio de sesión como ${usuario.rol}',
    );

    return usuario;
  }

  static Future<List<InsumoModel>> fetchInsumos() async {
    if (!isInitialized) {
      return HiveService.getInsumos();
    }

    try {
      final data = await _client!
          .from('insumos')
          .select('*')
          .eq('activo', true)
          .order('nombre', ascending: true) as List<dynamic>;

      return data.map((item) => InsumoModel.fromMap(Map<String, dynamic>.from(item))).toList();
    } catch (_) {
      return HiveService.getInsumos();
    }
  }

  static Future<bool> saveEntrada({
    required String insumoId,
    required String proveedorId,
    required double cantidad,
    required String unidadMedida,
    required String numeroLote,
    required DateTime fechaVencimiento,
  }) async {
    final payload = {
      'insumo_id': insumoId,
      'proveedor_id': proveedorId,
      'cantidad': cantidad,
      'unidad_medida': unidadMedida,
      'numero_lote': numeroLote,
      'fecha_vencimiento': fechaVencimiento.toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
      'activo': true,
    };

    if (!isInitialized) {
      return await HiveService.saveOfflineEntrada(payload);
    }

    try {
      await _client!.from('entradas').insert(payload);
      return true;
    } catch (_) {
      return await HiveService.saveOfflineEntrada(payload);
    }
  }

  static Future<void> saveAuditLog({
    required String usuarioId,
    required String evento,
  }) async {
    final log = {
      'usuario_id': usuarioId,
      'evento': evento,
      'timestamp': DateTime.now().toIso8601String(),
      'activo': true,
    };
    if (!isInitialized) {
      await HiveService.saveOfflineAudit(log);
      return;
    }

    try {
      await _client!.from('auditoria').insert(log);
    } catch (_) {
      await HiveService.saveOfflineAudit(log);
    }
  }

  static Future<void> logicalDeleteProveedor(String proveedorId) async {
    if (!isInitialized) {
      return;
    }
    await _client!
        .from('proveedores')
        .update({'activo': false})
        .eq('id', proveedorId);
  }

  static Future<List<double>> fetchConsumoSemanal() async {
    if (!isInitialized) {
      return [3.0, 5.2, 4.5, 6.0, 4.8, 5.0, 3.3];
    }
    try {
      final data = await _client!
          .from('consumo_semanal')
          .select('*')
          .limit(7)
          .order('dia', ascending: true) as List<dynamic>;

      return data
          .map<double>((item) => ((item['valor'] ?? 0) as num).toDouble())
          .toList();
    } catch (_) {
      return [3.0, 5.2, 4.5, 6.0, 4.8, 5.0, 3.3];
    }
  }
}
