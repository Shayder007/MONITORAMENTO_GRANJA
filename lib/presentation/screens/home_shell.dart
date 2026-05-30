import 'package:flutter/material.dart';

import '../../features/about/presentation/screens/about_screen.dart';
import '../../features/barns/domain/barn_structure.dart';
import '../../features/barns/presentation/screens/barn_dashboard_screen.dart';
import '../../features/barns/presentation/screens/barn_detail_screen.dart';
import '../../features/alerts/presentation/screens/alerts_screen.dart';
import '../../features/barns/presentation/screens/barns_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/motors/presentation/screens/motor_screen.dart';
import '../../features/maintenance/presentation/screens/maintenance_list_screen.dart';
import '../widgets/app_drawer.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late List<BarnUnit> _barns;

  @override
  void initState() {
    super.initState();
    _barns = defaultBarns;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Galpões')),
      drawer: AppDrawer(
        current: DrawerDestination.barns,
        onSelect: (destination) {
          Navigator.of(context).pop();
          if (destination == DrawerDestination.notifications) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AlertsScreen()));
            return;
          }
          if (destination == DrawerDestination.about) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AboutScreen()));
                    if (destination == DrawerDestination.maintenance) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const MaintenanceListScreen()),
                      );
                    }
          }
        },
      ),
      body: BarnsScreen(
        barns: _barns,
        onOpenBarn: _openBarn,
        onRenameBarn: _renameBarn,
      ),
    );
  }

  Future<void> _renameBarn(BarnUnit barn) async {
    final controller = TextEditingController(text: barn.name);
    final renamed = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Renomear galpão'),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Novo nome',
            hintText: 'Ex: Galpão Leste',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (renamed == null || renamed.isEmpty) return;

    setState(() {
      _barns = _barns
          .map(
            (item) => item.id == barn.id ? item.copyWith(name: renamed) : item,
          )
          .toList(growable: false);
    });
  }

  void _openBarn(BarnUnit barn) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BarnDetailScreen(
          barn: barn,
          onOpenBarnDashboard: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BarnDashboardScreen(barn: barn),
              ),
            );
          },
          onOpenMotor: (motor) {
            if (motor.hasLiveData) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      DashboardScreen(title: 'Dashboard - ${motor.name}'),
                ),
              );
              return;
            }

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    MotorScreen(motorName: motor.name, hasLiveData: false),
              ),
            );
          },
        ),
      ),
    );
  }
}
