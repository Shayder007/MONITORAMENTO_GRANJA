import 'package:flutter/material.dart';

enum DrawerDestination { barns, maintenance, notifications, about }

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.current, required this.onSelect});

  final DrawerDestination current;
  final ValueChanged<DrawerDestination> onSelect;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const ListTile(
              leading: Text('🐔', style: TextStyle(fontSize: 24)),
              title: Text('App Granja'),
              subtitle: Text('Monitoramento de galpoes e linhas'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.warehouse_rounded),
              selected: current == DrawerDestination.barns,
              title: const Text('Galpoes'),
              onTap: () => onSelect(DrawerDestination.barns),
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active_rounded),
              selected: current == DrawerDestination.notifications,
              title: const Text('Notificacoes'),
              onTap: () => onSelect(DrawerDestination.notifications),
            ),
            ListTile(
              leading: const Icon(Icons.build_circle_rounded),
              selected: current == DrawerDestination.maintenance,
              title: const Text('Manutencoes'),
              onTap: () => onSelect(DrawerDestination.maintenance),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              selected: current == DrawerDestination.about,
              title: const Text('Sobre nos'),
              onTap: () => onSelect(DrawerDestination.about),
            ),
          ],
        ),
      ),
    );
  }
}
