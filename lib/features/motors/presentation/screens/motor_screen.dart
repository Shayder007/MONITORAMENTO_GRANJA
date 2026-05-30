import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/time_utils.dart';
import '../../../../data/models/measurement.dart';
import '../../../dashboard/presentation/providers/measurement_providers.dart';
import '../../../dashboard/presentation/widgets/status_indicator.dart';

class MotorScreen extends ConsumerWidget {
  const MotorScreen({
    super.key,
    required this.motorName,
    this.hasLiveData = true,
  });

  final String motorName;
  final bool hasLiveData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = ref.watch(latestMeasurementProvider);

    return Scaffold(
      appBar: AppBar(title: Text(motorName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MotorHeader(
              latest: hasLiveData ? latest : null,
              hasLiveData: hasLiveData,
            ),
            const SizedBox(height: 16),
            Text('Estados', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  StatusIndicator(
                    label: 'Funcionando',
                    status: hasLiveData && (latest?.rpm ?? 0) > 0
                        ? 'Ativo'
                        : 'Indisponível',
                    color: Colors.blueGrey,
                    icon: Icons.play_circle_fill,
                  ),
                  const StatusIndicator(
                    label: 'Alerta',
                    status: 'Indisponível',
                    color: Colors.amber,
                    icon: Icons.warning_amber_rounded,
                  ),
                  const StatusIndicator(
                    label: 'Proteção ativada',
                    status: 'Indisponível',
                    color: Colors.deepPurple,
                    icon: Icons.shield_moon,
                  ),
                  const StatusIndicator(
                    label: 'Manutenção',
                    status: 'Indisponível',
                    color: Colors.teal,
                    icon: Icons.build_circle_rounded,
                  ),
                  StatusIndicator(
                    label: 'Offline',
                    status: hasLiveData ? 'Não' : 'Sim',
                    color: Colors.redAccent,
                    icon: Icons.power_settings_new_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MotorHeader extends StatelessWidget {
  const _MotorHeader({required this.latest, required this.hasLiveData});

  final Measurement? latest;
  final bool hasLiveData;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Text('🐔', style: TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Último RPM ativo', style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${latest?.rpm ?? 0}',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pulsos: ${latest?.pulsos ?? 0}',
                    style: textTheme.bodyLarge,
                  ),
                  Text(
                    hasLiveData
                        ? 'Atualizado em: ${TimeUtils.formatTimestamp(latest?.timestamp)}'
                        : 'Sem telemetria para esta linha',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
