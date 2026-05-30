import 'package:flutter/material.dart';

import '../../domain/barn_structure.dart';

class BarnsScreen extends StatelessWidget {
  const BarnsScreen({
    super.key,
    required this.barns,
    required this.onOpenBarn,
    required this.onRenameBarn,
  });

  final List<BarnUnit> barns;
  final ValueChanged<BarnUnit> onOpenBarn;
  final ValueChanged<BarnUnit> onRenameBarn;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: barns.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final barn = barns[index];
        final activeCount = barn.motors
            .where((motor) => motor.isRunning)
            .length;
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            leading: const CircleAvatar(child: Icon(Icons.warehouse_rounded)),
            title: Text(barn.name),
            subtitle: Text(
              '${barn.motors.length} linhas - $activeCount em funcionamento',
            ),
            trailing: Wrap(
              spacing: 4,
              children: [
                IconButton(
                  tooltip: 'Renomear galpão',
                  onPressed: () => onRenameBarn(barn),
                  icon: const Icon(Icons.edit_rounded),
                ),
                IconButton(
                  tooltip: 'Abrir galpão',
                  onPressed: () => onOpenBarn(barn),
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                ),
              ],
            ),
            onTap: () => onOpenBarn(barn),
          ),
        );
      },
    );
  }
}
