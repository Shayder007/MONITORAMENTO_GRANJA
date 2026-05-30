import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';
import '../models/measurement.dart';
import 'measurement_service.dart';

class FirebaseMeasurementService implements MeasurementService {
  FirebaseMeasurementService({
    FirebaseApp? app,
    FirebaseDatabase? database,
    this.historyLimit = 50,
    this.measurementsPath = '/rpm',
  }) : _db = database ?? FirebaseDatabase.instanceFor(
          app: app ?? Firebase.app(),
          databaseURL: DefaultFirebaseOptions.currentPlatform.databaseURL,
        );

  final FirebaseDatabase _db;
  final int historyLimit;
  final String measurementsPath;
  static const String _pushChars = '-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz';

  @override
  Stream<List<Measurement>> measurementStream() {
    final ref = _db.ref(measurementsPath);
    return ref
        .orderByChild('timestamp')
        .limitToLast(historyLimit)
        .onValue
        .asyncMap((event) async {
          final serverNowMs = await _resolveServerNowMs();
          return _mapEventToList(event, serverNowMs: serverNowMs);
        })
        .handleError((error, stack) {
          debugPrint('Firebase stream error: $error');
        });
  }

  @override
  Stream<bool> connectionStream() {
    final infoRef = _db.ref('.info/connected');
    return infoRef.onValue.map((event) {
      final value = event.snapshot.value;
      return value == true;
    }).distinct();
  }

  List<Measurement> _mapEventToList(DatabaseEvent event, {int? serverNowMs}) {
    final List<Measurement> items = [];

    final raw = event.snapshot.value;
    if (raw is Map<dynamic, dynamic>) {
      // Accepts the flat format: /rpm { rpm, pulsos, timestamp }
      if (_isMeasurementPayload(raw)) {
        items.add(
          Measurement.fromMap(
            event.snapshot.key ?? 'latest',
            raw,
            fallbackTimestamp: _decodePushKeyTimestampMs(event.snapshot.key) ?? serverNowMs,
          ),
        );
        return items;
      }
    }

    // Accepts the list format: /rpm/{pushId} { rpm, pulsos, timestamp }
    for (final child in event.snapshot.children) {
      final data = child.value;
      if (data is Map<dynamic, dynamic> && _isMeasurementPayload(data)) {
        items.add(
          Measurement.fromMap(
            child.key ?? 'n/a',
            data,
            fallbackTimestamp: _decodePushKeyTimestampMs(child.key) ?? serverNowMs,
          ),
        );
      }
    }
    items.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return items;
  }

  bool _isMeasurementPayload(Map<dynamic, dynamic> data) {
    return data.containsKey('rpm') && data.containsKey('pulsos') && data.containsKey('timestamp');
  }

  int? _decodePushKeyTimestampMs(String? key) {
    if (key == null || key.length < 8) return null;

    var timestamp = 0;
    for (var i = 0; i < 8; i++) {
      final index = _pushChars.indexOf(key[i]);
      if (index < 0) return null;
      timestamp = timestamp * 64 + index;
    }
    return timestamp;
  }

  Future<int?> _resolveServerNowMs() async {
    try {
      final offsetSnapshot = await _db.ref('.info/serverTimeOffset').get();
      final offsetValue = offsetSnapshot.value;
      final offsetMs = offsetValue is num ? offsetValue.round() : 0;
      return DateTime.now().millisecondsSinceEpoch + offsetMs;
    } catch (_) {
      return null;
    }
  }
}
