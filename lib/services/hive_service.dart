import 'package:hive_flutter/hive_flutter.dart';

import '../models/insumo_model.dart';

class HiveService {
  static const String _insumoBox = 'insumos';
  static const String _pendingEntradasBox = 'entradas_offline';
  static const String _auditBox = 'auditoria_offline';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_insumoBox);
    await Hive.openBox(_pendingEntradasBox);
    await Hive.openBox(_auditBox);
  }

  static Future<bool> saveOfflineEntrada(Map<String, dynamic> record) async {
    final box = Hive.box(_pendingEntradasBox);
    box.add(record);
    return true;
  }

  static Future<void> saveOfflineAudit(Map<String, dynamic> record) async {
    final box = Hive.box(_auditBox);
    box.add(record);
  }

  static Future<List<InsumoModel>> getInsumos() async {
    final box = Hive.box(_insumoBox);
    final stored = box.values.toList();
    return stored
        .whereType<Map<String, dynamic>>()
        .map((item) => InsumoModel.fromMap(item))
        .toList();
  }

  static Future<int> getPendingEntradasCount() async {
    final box = Hive.box(_pendingEntradasBox);
    return box.length;
  }

  static Future<void> cacheInsumos(List<InsumoModel> insumos) async {
    final box = Hive.box(_insumoBox);
    await box.clear();
    for (final insumo in insumos) {
      await box.add(insumo.toMap());
    }
  }
}
