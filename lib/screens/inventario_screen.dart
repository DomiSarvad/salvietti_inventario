import 'package:flutter/material.dart';

import '../models/insumo_model.dart';
import '../models/usuario_model.dart';
import '../services/database_service.dart';
import '../services/hive_service.dart';
import 'componentes/grafico_consumo.widget.dart';
import 'componentes/tarjeta_insumo.widget.dart';

class InventarioScreen extends StatefulWidget {
  final UsuarioModel usuario;

  const InventarioScreen({super.key, required this.usuario});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  late Future<List<InsumoModel>> _insumosFuture;
  late Future<int> _pendingEntradasFuture;
  late Future<List<double>> _consumoSemanalFuture;
  final ValueNotifier<bool> _isOffline = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    _insumosFuture = DatabaseService.fetchInsumos();
    _pendingEntradasFuture = HiveService.getPendingEntradasCount();
    _consumoSemanalFuture = DatabaseService.fetchConsumoSemanal();
  }

  Color get _statusColor => _isOffline.value ? Colors.orange.shade700 : Colors.green.shade700;
  String get _statusLabel => _isOffline.value ? 'OFFLINE - MODO LOCAL' : 'ONLINE';

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Salvietti', style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.bold, fontSize: 22)),
          const SizedBox(height: 4),
          Text('Monitoreo de insumos y consumo proyectado', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
        ],
      ),
      actions: [
        ValueListenableBuilder<bool>(
          valueListenable: _isOffline,
          builder: (context, isOffline, child) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isOffline ? Colors.orange.shade100 : Colors.green.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(isOffline ? Icons.cloud_off : Icons.cloud_done, color: _statusColor, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    _statusLabel,
                    style: TextStyle(color: _statusColor, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          },
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications_none, color: Colors.grey.shade800),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(right: 18),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green.shade700,
                child: const Text('RQ'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.usuario.nombre, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  Text(widget.usuario.rol, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSideMenu() {
    return Container(
      width: 240,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      color: Colors.grey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Panel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),
          const _MenuItem(icon: Icons.dashboard, label: 'Dashboard', selected: true),
          const SizedBox(height: 12),
          const _MenuItem(icon: Icons.inventory_2_outlined, label: 'Stock Health'),
          const SizedBox(height: 12),
          const _MenuItem(icon: Icons.trending_up, label: 'Tendencias'),
          const SizedBox(height: 12),
          const _MenuItem(icon: Icons.receipt_long, label: 'Auditoría'),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ALERTAS CRÍTICAS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade800)),
                const SizedBox(height: 12),
                const Text('Preformas PET 2L Gas CO2 Insumo', style: TextStyle(fontSize: 13)),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
                  child: const Text('RESOLVER AHORA'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCentralPanel(List<InsumoModel> insumos) {
    final tarjetas = insumos.where((item) => item.activo).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Estado de Planta', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Registrar Movimiento'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text('Monitoreo de insumos y consumo proyectado • ${DateTime.now().day} ${_monthName(DateTime.now().month)} ${DateTime.now().year}', style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 26),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: tarjetas.map((insumo) => SizedBox(width: 320, child: TarjetaInsumoWidget(insumo: insumo))).toList(),
        ),
      ],
    );
  }

  Widget _buildRightPanel(List<double> valores) {
    const eficiencia = 94.2;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          GraficoConsumoWidget(valores: valores),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('EFICIENCIA', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('${eficiencia.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Icon(Icons.show_chart_outlined, size: 40, color: Colors.green.shade700),
            ],
          ),
        ],
      ),
    );
  }

  static String _monthName(int month) {
    const names = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return names[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(preferredSize: const Size.fromHeight(92), child: _buildAppBar()),
      body: FutureBuilder<List<InsumoModel>>(
        future: _insumosFuture,
        builder: (context, snapshot) {
          final insumos = snapshot.data ?? [];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSideMenu(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildCentralPanel(insumos)),
                            const SizedBox(width: 22),
                            FutureBuilder<List<double>>(
                              future: _consumoSemanalFuture,
                              builder: (context, chartSnapshot) {
                                final valores = chartSnapshot.data ?? [3.0, 5.2, 4.5, 6.0, 4.8, 5.0, 3.3];
                                return SizedBox(width: 420, child: _buildRightPanel(valores));
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<int>(
                        future: _pendingEntradasFuture,
                        builder: (context, pendingSnapshot) {
                          final pendientes = pendingSnapshot.data ?? 0;
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${_statusLabel == 'OFFLINE - MODO LOCAL' ? 'Modo Off-line activo' : 'Conexión Online estable'} • Pendientes: $pendientes',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _MenuItem({required this.icon, required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: selected ? Colors.green.shade700 : Colors.white,
        foregroundColor: selected ? Colors.white : Colors.black87,
        elevation: selected ? 2 : 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      ),
    );
  }
}
