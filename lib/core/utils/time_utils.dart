import 'package:intl/intl.dart';

class TimeUtils {
  static String formatTimestamp(int? timestamp) {
    if (timestamp == null || timestamp <= 0) return 'Indisponível';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
  }

  static String formatShortTime(int? timestamp) {
    if (timestamp == null || timestamp <= 0) return '--:--:--';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('HH:mm:ss').format(date);
  }
}
