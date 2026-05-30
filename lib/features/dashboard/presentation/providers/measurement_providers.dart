import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/measurement.dart';
import '../../../../data/repositories/measurement_repository.dart';

final measurementStreamProvider = StreamProvider<List<Measurement>>((ref) {
  final repo = ref.watch(measurementRepositoryProvider);
  return repo.watchMeasurements();
});

final latestMeasurementProvider = Provider<Measurement?>((ref) {
  final asyncData = ref.watch(measurementStreamProvider);
  return asyncData.maybeWhen(data: (list) => list.isNotEmpty ? list.last : null, orElse: () => null);
});

final measurementStatsProvider = Provider<MeasurementStats>((ref) {
  final asyncData = ref.watch(measurementStreamProvider);
  return asyncData.when(
    data: (list) => MeasurementStats(
      total: list.length,
      lastTimestamp: list.isNotEmpty ? list.last.timestamp : null,
    ),
    error: (error, _) => MeasurementStats(total: 0, lastTimestamp: null),
    loading: () => MeasurementStats(total: 0, lastTimestamp: null),
  );
});

final connectionStatusProvider = StreamProvider<bool>((ref) {
  final repo = ref.watch(measurementRepositoryProvider);
  return repo.watchConnection();
});

class MeasurementStats {
  const MeasurementStats({required this.total, required this.lastTimestamp});
  final int total;
  final int? lastTimestamp;
}
