import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/measurement.dart';
import '../services/firebase_measurement_service.dart';
import '../services/measurement_service.dart';
class MeasurementRepository {
  MeasurementRepository(this._service);

  final MeasurementService _service;

  Stream<List<Measurement>> watchMeasurements() => _service.measurementStream();

  Stream<bool> watchConnection() => _service.connectionStream();
}

final measurementRepositoryProvider = Provider<MeasurementRepository>((ref) {
  return MeasurementRepository(FirebaseMeasurementService());
});
