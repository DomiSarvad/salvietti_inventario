import 'package:flutter/material.dart';

import '../../models/insumo_model.dart';

class TarjetaInsumoWidget extends StatelessWidget {
  final InsumoModel insumo;

  const TarjetaInsumoWidget({super.key, required this.insumo});

  Color get borderColor {
    if (insumo.esCritico) {
      return Colors.red.shade600;
    }
    if (insumo.enObservacion) {
      return Colors.amber.shade700;
    }
    return Colors.green.shade900;
  }

  String get indicadorRotacion {
    if (insumo.rotacionLenta) {
      return 'Rotación lenta';
    }
    return '${insumo.diasRestantes.toStringAsFixed(1)} DÍAS';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 2.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    insumo.nombre,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: borderColor.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    insumo.esCritico ? 'CRÍTICO' : insumo.enObservacion ? 'OBSERVACIÓN' : 'ESTABLE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: borderColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Stock actual: ${insumo.stockActual.toStringAsFixed(0)} ${insumo.unidadMedida}'),
            const SizedBox(height: 8),
            Text('Lote: ${insumo.numeroLote}'),
            const SizedBox(height: 8),
            if (insumo.fechaVencimiento != null)
              Text('Vencimiento: ${insumo.fechaVencimiento!.day}/${insumo.fechaVencimiento!.month}/${insumo.fechaVencimiento!.year}'),
            const SizedBox(height: 12),
            Text(
              indicadorRotacion,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            if (insumo.rotacionLenta)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Insumo sin movimientos en 10 días',
                  style: TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
