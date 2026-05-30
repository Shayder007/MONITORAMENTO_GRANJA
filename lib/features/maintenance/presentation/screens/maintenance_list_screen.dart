import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/maintenance_record.dart';
import '../providers/maintenance_providers.dart';
import '../../../../presentation/screens/home_shell.dart';
import '../../../../presentation/widgets/app_drawer.dart';
import '../../../about/presentation/screens/about_screen.dart';
import '../../../alerts/presentation/screens/alerts_screen.dart';

class MaintenanceListScreen extends ConsumerWidget {
  const MaintenanceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(maintenanceProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Manutenções')),
            drawer: AppDrawer(
              current: DrawerDestination.maintenance,
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
                if (destination == DrawerDestination.about) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const AboutScreen()),
                  );
                }
              },
            ),
      body: records.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.build_circle_outlined,
                        size: 72,
                        color: theme.colorScheme.primary.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    const Text(
                      'Nenhuma manutenção registrada.\nAcesse um galpão e registre a primeira!',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final r = records[index];
                return _MaintenanceCard(
                  record: r,
                  onDelete: () =>
                      ref.read(maintenanceProvider.notifier).remove(r.id),
                );
              },
            ),
    );
  }
}

class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({required this.record, required this.onDelete});

  final MaintenanceRecord record;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat('dd/MM/yyyy').format(record.performedAt);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.build_rounded,
                    size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    record.type.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Text(dateStr,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.outline)),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  tooltip: 'Excluir',
                  color: theme.colorScheme.error,
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.warehouse_rounded, size: 14),
                const SizedBox(width: 4),
                Text('${record.barnName}  ·  ${record.motorLine}',
                    style: theme.textTheme.bodySmall),
              ],
            ),
            const Divider(height: 14),
            Text(record.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.person_rounded, size: 14),
                const SizedBox(width: 4),
                Text(record.technician, style: theme.textTheme.bodySmall),
              ],
            ),
            if (record.notes.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.notes_rounded, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(record.notes,
                        style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir manutenção?'),
        content:
            const Text('Este registro será removido permanentemente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
