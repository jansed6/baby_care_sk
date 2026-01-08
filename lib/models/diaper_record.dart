import 'package:uuid/uuid.dart';

/// Model pre záznam plienky
class DiaperRecord {
  final String id;
  final DateTime dateTime;
  final DiaperType type;
  final DiaperSize? size;
  final StoolColor? color;
  final String? note;

  DiaperRecord({
    String? id,
    required this.dateTime,
    required this.type,
    this.size,
    this.color,
    this.note,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'type': type.toString(),
      'size': size?.toString(),
      'color': color?.toString(),
      'note': note,
    };
  }

  factory DiaperRecord.fromJson(Map<String, dynamic> json) {
    return DiaperRecord(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      type: DiaperType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      size: json['size'] != null
          ? DiaperSize.values.firstWhere((e) => e.toString() == json['size'])
          : null,
      color: json['color'] != null
          ? StoolColor.values.firstWhere((e) => e.toString() == json['color'])
          : null,
      note: json['note'],
    );
  }

  String get formattedTime {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String get typeLabel {
    switch (type) {
      case DiaperType.wet:
        return 'Mokrá';
      case DiaperType.dirty:
        return 'Špinavá';
      case DiaperType.mixed:
        return 'Kombinovaná';
    }
  }

  String? get sizeLabel {
    if (size == null) return null;
    switch (size!) {
      case DiaperSize.small:
        return 'Malá';
      case DiaperSize.medium:
        return 'Stredná';
      case DiaperSize.large:
        return 'Veľká';
    }
  }

  String? get colorLabel {
    if (color == null) return null;
    switch (color!) {
      case StoolColor.yellow:
        return 'Žltá';
      case StoolColor.green:
        return 'Zelená';
      case StoolColor.brown:
        return 'Hnedá';
      case StoolColor.black:
        return 'Čierna';
    }
  }
}

/// Typ plienky
enum DiaperType {
  wet,    // Mokrá
  dirty,  // Špinavá
  mixed,  // Kombinovaná
}

/// Veľkosť / množstvo
enum DiaperSize {
  small,
  medium,
  large,
}

/// Farba stolice
enum StoolColor {
  yellow,
  green,
  brown,
  black,
}
