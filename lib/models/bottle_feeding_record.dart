import 'package:uuid/uuid.dart';

/// Model pre záznam kŕmenia z fľaše
class BottleFeedingRecord {
  final String id;
  final DateTime dateTime;
  final int volumeMl;
  final BottleFeedingType type;
  final String? note;

  BottleFeedingRecord({
    String? id,
    required this.dateTime,
    required this.volumeMl,
    required this.type,
    this.note,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'volumeMl': volumeMl,
      'type': type.toString(),
      'note': note,
    };
  }

  factory BottleFeedingRecord.fromJson(Map<String, dynamic> json) {
    return BottleFeedingRecord(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      volumeMl: json['volumeMl'],
      type: BottleFeedingType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      note: json['note'],
    );
  }

  String get formattedTime {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String get typeLabel {
    switch (type) {
      case BottleFeedingType.formula:
        return 'Umelé mlieko';
      case BottleFeedingType.breastMilk:
        return 'Materské mlieko';
      case BottleFeedingType.water:
        return 'Voda';
    }
  }
}

/// Typ kŕmenia z fľaše
enum BottleFeedingType {
  formula,    // Umelé mlieko
  breastMilk, // Materské mlieko
  water,      // Voda
}
