import 'package:uuid/uuid.dart';

class SleepRecord {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final String? note;

  SleepRecord({
    String? id,
    required this.startTime,
    this.endTime,
    this.note,
  }) : id = id ?? const Uuid().v4();

  Duration? get duration {
    if (endTime == null) return null;
    return endTime!.difference(startTime);
  }

  bool get isActive => endTime == null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'note': note,
    };
  }

  factory SleepRecord.fromJson(Map<String, dynamic> json) {
    return SleepRecord(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      note: json['note'],
    );
  }

  SleepRecord copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    String? note,
  }) {
    return SleepRecord(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      note: note ?? this.note,
    );
  }
}
