import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/measurement.dart';
import '../../../../core/utils/time_utils.dart';

class RpmChart extends StatelessWidget {
  const RpmChart({super.key, required this.measurements});

  final List<Measurement> measurements;

  @override
  Widget build(BuildContext context) {
    if (measurements.isEmpty) {
      return const Center(child: Text('Sem histórico de RPM disponível'));
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < measurements.length; i++) {
      spots.add(FlSpot(i.toDouble(), measurements[i].rpm.toDouble()));
    }

    final lastIndex = measurements.length - 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: lastIndex.toDouble(),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipPadding: const EdgeInsets.all(8),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  final measurement = measurements[touchedSpot.x.toInt()];
                  return LineTooltipItem(
                    'RPM: ${measurement.rpm}\n${TimeUtils.formatShortTime(measurement.timestamp)}',
                    Theme.of(context).textTheme.bodyMedium!,
                  );
                }).toList();
              },
            ),
          ),
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: measurements.length > 6 ? (measurements.length / 6).ceilToDouble() : 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= measurements.length) return const SizedBox.shrink();
                  return Text(TimeUtils.formatShortTime(measurements[index].timestamp), style: Theme.of(context).textTheme.bodySmall);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: _calcInterval(spots),
                getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: Theme.of(context).textTheme.bodySmall),
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calcInterval(List<FlSpot> spots) {
    if (spots.isEmpty) return 100;
    final values = spots.map((e) => e.y).toList();
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = (max - min).abs();
    if (range <= 0) return (max / 2).clamp(10, 500);
    return (range / 4).clamp(10, 800);
  }
}
