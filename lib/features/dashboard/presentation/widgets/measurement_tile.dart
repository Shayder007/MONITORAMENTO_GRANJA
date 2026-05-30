import 'package:flutter/material.dart';

import '../../../../data/models/measurement.dart';
import '../../../../core/utils/time_utils.dart';

class MeasurementTile extends StatelessWidget {
  const MeasurementTile({super.key, required this.measurement});

  final Measurement measurement;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorScheme.primaryContainer,
        child: const Icon(Icons.av_timer_outlined),
      ),
      title: Text('RPM: ${measurement.rpm} | Pulsos: ${measurement.pulsos}'),
      subtitle: Text('Recebido em ${TimeUtils.formatTimestamp(measurement.timestamp)}'),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}
