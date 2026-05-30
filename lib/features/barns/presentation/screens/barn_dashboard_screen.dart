import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/time_utils.dart';
import '../../../dashboard/presentation/providers/measurement_providers.dart';
import '../../domain/barn_structure.dart';

class BarnDashboardScreen extends ConsumerWidget {
  const BarnDashboardScreen({super.key, required this.barn});

  final BarnUnit barn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = ref.watch(latestMeasurementProvider);
    final stats = ref.watch(measurementStatsProvider);
    final connectionAsync = ref.watch(connectionStatusProvider);
    final totalRunning = barn.motors.where((motor) => motor.isRunning).length;

    return Scaffold(
      appBar: AppBar(title: Text('Dashboard - ${barn.name}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: 'Linhas',
                  value: '${barn.motors.length}',
                  icon: Icons.view_week_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  label: 'Ativos',
                  value: '$totalRunning',
                  icon: Icons.play_circle_fill_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          connectionAsync.when(
            data: (connected) => _SummaryCard(
              label: 'Conexão',
              value: connected ? 'Online' : 'Offline',
              icon: connected ? Icons.wifi_rounded : Icons.wifi_off_rounded,
            ),
            loading: () => const _SummaryCard(
              label: 'Conexão',
              value: 'Verificando...',
              icon: Icons.hourglass_top_rounded,
            ),
            error: (error, stack) => const _SummaryCard(
              label: 'Conexão',
              value: 'Erro',
              icon: Icons.error_outline_rounded,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.update_rounded),
              title: const Text('Última medição recebida'),
              subtitle: Text(
                latest == null
                    ? 'Sem dados'
                    : 'RPM ${latest.rpm} - ${TimeUtils.formatTimestamp(latest.timestamp)}',
              ),
              trailing: Text('Total: ${stats.total}'),
            ),
          ),
          const SizedBox(height: 12),
          Text('Linhas', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...barn.motors.map(
            (motor) => Card(
              child: ListTile(
                leading: Icon(
                  motor.isRunning
                      ? Icons.check_circle_rounded
                      : Icons.pause_circle_rounded,
                  color: motor.isRunning ? Colors.green : Colors.grey,
                ),
                title: Text(motor.line),
                subtitle: Text(
                  motor.hasLiveData
                      ? 'Linha monitorada em tempo real'
                      : 'Linha sem telemetria ativa',
                ),
                trailing: Text(
                  motor.hasLiveData && latest != null
                      ? '${latest.rpm} RPM'
                      : '-- RPM',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(value, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
