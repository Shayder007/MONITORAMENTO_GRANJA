import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/maintenance_record.dart';

class MaintenanceNotifier extends StateNotifier<List<MaintenanceRecord>> {
  MaintenanceNotifier() : super([]);

  void add(MaintenanceRecord record) {
    state = [record, ...state];
  }

  void remove(String id) {
    state = state.where((r) => r.id != id).toList(growable: false);
  }
}

final maintenanceProvider =
    StateNotifierProvider<MaintenanceNotifier, List<MaintenanceRecord>>(
  (_) => MaintenanceNotifier(),
);
