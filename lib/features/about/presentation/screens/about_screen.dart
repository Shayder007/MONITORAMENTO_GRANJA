import 'package:flutter/material.dart';

import '../../../../presentation/screens/home_shell.dart';
import '../../../../presentation/widgets/app_drawer.dart';
import '../../../alerts/presentation/screens/alerts_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre nós')),
      drawer: AppDrawer(
        current: DrawerDestination.about,
        onSelect: (destination) {
          Navigator.of(context).pop();
          if (destination == DrawerDestination.barns) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeShell()),
              (_) => false,
            );
          }
          if (destination == DrawerDestination.notifications) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AlertsScreen()),
            );
          }
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Text('🐔', style: TextStyle(fontSize: 24)),
            title: Text('App Granja'),
            subtitle: Text(
              'Controle simples de galpões e linhas',
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.lightbulb_outline_rounded),
            title: Text('Objetivo'),
            subtitle: Text(
              'Realizar monitoramento por galpão e reduzir quebras nas linhas de motores para reduzir gastos e possiveis perdas ',
            ),
          ),
        ],
      ),
    );
  }
}
