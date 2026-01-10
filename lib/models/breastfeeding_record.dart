import 'package:uuid/uuid.dart';

class BreastfeedingRecord {
  final String id;
  final DateTime time;
  final BreastfeedingSide side;

  BreastfeedingRecord({
    String? id,
    required this.time,
    required this.side,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time.toIso8601String(),
      'side': side.toString(),
    };
  }

  factory BreastfeedingRecord.fromJson(Map<String, dynamic> json) {
    // Podpora starého formátu (startTime) aj nového (time)
    final timeString = json['time'] ?? json['startTime'];
    return BreastfeedingRecord(
      id: json['id'],
      time: DateTime.parse(timeString),
      side: BreastfeedingSide.values.firstWhere(
        (e) => e.toString() == json['side'],
      ),
    );
  }

  String get formattedTime {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String get sideLabel {
    switch (side) {
      case BreastfeedingSide.left:
        return 'Ľavé';
      case BreastfeedingSide.right:
        return 'Pravé';
      case BreastfeedingSide.both:
        return 'Obidve';
    }
  }
}

enum BreastfeedingSide {
  left,
  right,
  both,
}
