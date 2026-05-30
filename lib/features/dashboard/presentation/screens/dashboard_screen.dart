import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/time_utils.dart';
import '../../../../data/models/measurement.dart';
import '../providers/measurement_providers.dart';
import '../widgets/connection_badge.dart';
import '../widgets/measurement_tile.dart';
import '../widgets/rpm_card.dart';
import '../widgets/rpm_chart.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({
    super.key,
    this.title = 'Painel da Linha',
    this.drawer,
  });

  final String title;
  final Widget? drawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurementsAsync = ref.watch(measurementStreamProvider);
    final latest = ref.watch(latestMeasurementProvider);
    final stats = ref.watch(measurementStatsProvider);
    final connectionAsync = ref.watch(connectionStatusProvider);

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: Text(title),
        actions: [
          connectionAsync.when(
            data: (connected) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(child: ConnectionBadge(isConnected: connected)),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.only(right: 12),
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (error, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Pull-to-refresh triggers a rebuild; stream already live.
          ref.invalidate(measurementStreamProvider);
          await Future<void>.delayed(const Duration(milliseconds: 400));
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: measurementsAsync.when(
            data: (data) => _DashboardContent(
              latest: latest,
              stats: stats,
              measurements: data,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Falha ao carregar dados: $err'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.latest,
    required this.stats,
    required this.measurements,
  });

  final Measurement? latest;
  final MeasurementStats stats;
  final List<Measurement> measurements;

  @override
  Widget build(BuildContext context) {
    final grid = MediaQuery.of(context).size.width >= 900;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (grid)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildRpmCard(context)),
                const SizedBox(width: 12),
                Expanded(child: _buildSummaryCards(context)),
              ],
            )
          else ...[
            _buildRpmCard(context),
            const SizedBox(height: 12),
            _buildSummaryCards(context),
          ],
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 260,
                child: RpmChart(measurements: measurements),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => MeasurementTile(
                measurement: measurements.reversed.toList()[index],
              ),
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemCount: measurements.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRpmCard(BuildContext context) {
    final rpm = latest?.rpm ?? 0;
    final time = TimeUtils.formatTimestamp(latest?.timestamp);
    return RpmCard(rpm: rpm, timestamp: time);
  }

  Widget _buildSummaryCards(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total de medições', style: textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      '${stats.total}',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.data_usage_rounded, size: 36),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Última atualização', style: textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      TimeUtils.formatTimestamp(stats.lastTimestamp),
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
                const Icon(Icons.update_rounded, size: 36),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
