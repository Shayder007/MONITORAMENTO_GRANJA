import 'package:flutter/material.dart';

import '../../../about/presentation/screens/about_screen.dart';
import '../../../../presentation/screens/home_shell.dart';
import '../../../../presentation/widgets/app_drawer.dart';
import '../../../maintenance/presentation/screens/maintenance_list_screen.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alertas')),
      drawer: AppDrawer(
        current: DrawerDestination.notifications,
        onSelect: (destination) {
          Navigator.of(context).pop();
          if (destination == DrawerDestination.barns) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeShell()),
              (_) => false,
            );
          }
          if (destination == DrawerDestination.about) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            );
          }
          if (destination == DrawerDestination.maintenance) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MaintenanceListScreen()),
            );
          }
        },
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications_none_rounded, size: 72, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              const Text(
                'Ainda nao ha dados de alertas. Esta tela esta pronta para quando o dispositivo comecar a envia-los.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
