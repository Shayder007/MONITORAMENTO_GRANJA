import 'package:flutter/material.dart';

import '../../domain/barn_structure.dart';
import '../../../maintenance/presentation/screens/maintenance_form_screen.dart';

class BarnDetailScreen extends StatelessWidget {
  const BarnDetailScreen({
    super.key,
    required this.barn,
    required this.onOpenBarnDashboard,
    required this.onOpenMotor,
  });

  final BarnUnit barn;
  final VoidCallback onOpenBarnDashboard;
  final ValueChanged<BarnMotor> onOpenMotor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(barn.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.dashboard_customize_rounded),
              title: const Text('Dashboard do galpão'),
              subtitle: const Text('Visão de todas as linhas'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: onOpenBarnDashboard,
            ),
          ),
          const SizedBox(height: 12),
          Text('Linhas', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...barn.motors.map(
            (motor) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    motor.isRunning
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded,
                  ),
                ),
                title: Text(motor.line),
                subtitle: Text(
                  motor.hasLiveData ? 'Com dados em tempo real' : 'Sem dados em tempo real',
                ),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      tooltip: 'Registrar manutenção',
                      icon: const Icon(Icons.build_rounded),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MaintenanceFormScreen(
                            barn: barn,
                            motor: motor,
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
                onTap: () => onOpenMotor(motor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
