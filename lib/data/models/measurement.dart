class Measurement {
  Measurement({
    required this.id,
    required this.rpm,
    required this.pulsos,
    required this.timestamp,
  });

  final String id;
  final int rpm;
  final int pulsos;
  final int timestamp;

  factory Measurement.fromMap(
    String id,
    Map<dynamic, dynamic> data, {
    int? fallbackTimestamp,
  }) {
    final normalizedTimestamp = _normalizeEpochMilliseconds(data['timestamp']);
    final fallbackMs = fallbackTimestamp != null ? _normalizeEpochMilliseconds(fallbackTimestamp) : null;

    return Measurement(
      id: id,
      rpm: _toInt(data['rpm']),
      pulsos: _toInt(data['pulsos']),
      timestamp: _pickBestTimestamp(normalizedTimestamp, fallbackMs),
    );
  }

  Measurement copyWith({
    String? id,
    int? rpm,
    int? pulsos,
    int? timestamp,
  }) {
    return Measurement(
      id: id ?? this.id,
      rpm: rpm ?? this.rpm,
      pulsos: pulsos ?? this.pulsos,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static int _normalizeEpochMilliseconds(dynamic rawValue) {
    final value = _toInt(rawValue);
    if (value <= 0) return 0;

    // Accepts timestamps in seconds, milliseconds, microseconds or nanoseconds.
    if (value >= 1000000000000000000) return value ~/ 1000000;
    if (value >= 1000000000000000) return value ~/ 1000;
    if (value >= 1000000000000) return value;
    if (value >= 1000000000) return value * 1000;

    return 0;
  }

  static int _pickBestTimestamp(int primaryMs, int? fallbackMs) {
    if (fallbackMs != null && _isPlausibleEpochMs(fallbackMs)) {
      if (!_isPlausibleEpochMs(primaryMs)) return fallbackMs;

      // If source and server-based times drift too much, trust server-side fallback.
      final drift = (primaryMs - fallbackMs).abs();
      if (drift > 15552000000) return fallbackMs; // 180 days
      return primaryMs;
    }

    if (_isPlausibleEpochMs(primaryMs)) return primaryMs;
    return primaryMs > 0 ? primaryMs : 0;
  }

  static bool _isPlausibleEpochMs(int value) {
    // Jan 1, 2020 and Jan 1, 2100.
    return value >= 1577836800000 && value <= 4102444800000;
  }
}
