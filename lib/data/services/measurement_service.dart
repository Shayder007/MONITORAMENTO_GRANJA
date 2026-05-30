import '../models/measurement.dart';

abstract class MeasurementService {
  Stream<List<Measurement>> measurementStream();
  Stream<bool> connectionStream();
}
