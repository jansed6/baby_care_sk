import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sleep_record.dart';

class SleepService {
  static const String _storageKey = 'sleep_records';
  final SharedPreferences _prefs;

  SleepService(this._prefs);

  List<SleepRecord> getRecords() {
    final String? recordsJson = _prefs.getString(_storageKey);
    if (recordsJson == null) return [];

    final List<dynamic> decoded = jsonDecode(recordsJson);
    return decoded.map((json) => SleepRecord.fromJson(json)).toList();
  }

  List<SleepRecord> getAllRecords() {
    return getRecords();
  }

  List<SleepRecord> getTodayRecords() {
    final records = getRecords();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return records.where((record) {
      // Zobraz záznam ak:
      // 1. Začal dnes
      // 2. ALEBO skončil dnes (spánok cez polnoc)
      // 3. ALEBO stále prebieha a začal pred dneškom
      final startedToday =
          record.startTime.isAfter(today) &&
          record.startTime.isBefore(tomorrow);
      final endedToday =
          record.endTime != null &&
          record.endTime!.isAfter(today) &&
          record.endTime!.isBefore(tomorrow);
      final isActiveFromBefore =
          record.isActive && record.startTime.isBefore(tomorrow);

      return startedToday || endedToday || isActiveFromBefore;
    }).toList();
  }

  List<SleepRecord> getRecentRecords({int daysAgo = 7}) {
    final records = getRecords();
    final now = DateTime.now();
    final startDate = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: daysAgo));

    return records.where((record) {
      // Zobraz záznam ak začal v posledných N dňoch
      // alebo stále prebieha
      return record.startTime.isAfter(startDate) || record.isActive;
    }).toList();
  }

  SleepRecord? getActiveRecord() {
    final records = getRecords();
    try {
      return records.firstWhere((record) => record.isActive);
    } catch (e) {
      return null;
    }
  }

  Future<void> addRecord(SleepRecord record) async {
    final records = getRecords();
    records.add(record);
    await _saveRecords(records);
  }

  Future<void> updateRecord(SleepRecord record) async {
    final records = getRecords();
    final index = records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      records[index] = record;
      await _saveRecords(records);
    }
  }

  Future<void> deleteRecord(String id) async {
    final records = getRecords();
    records.removeWhere((record) => record.id == id);
    await _saveRecords(records);
  }

  Future<void> _saveRecords(List<SleepRecord> records) async {
    final List<Map<String, dynamic>> jsonList = records
        .map((record) => record.toJson())
        .toList();
    await _prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  Duration getTotalSleepToday() {
    final todayRecords = getTodayRecords();
    Duration total = Duration.zero;

    for (var record in todayRecords) {
      if (record.duration != null) {
        total += record.duration!;
      }
    }

    return total;
  }

  int getSleepCountToday() {
    return getTodayRecords().where((r) => !r.isActive).length;
  }

  Future<void> generateTestData() async {
    final random = Random();
    final now = DateTime.now();
    final testRecords = <SleepRecord>[];
    int idCounter = 0;

    // Generuj dáta za posledných 365 dní
    for (int dayOffset = 0; dayOffset < 365; dayOffset++) {
      final date = now.subtract(Duration(days: dayOffset));

      // Náhodný počet spánkov za deň (1-4)
      final sleepsPerDay = 1 + random.nextInt(4);

      for (int i = 0; i < sleepsPerDay; i++) {
        // Náhodný čas začiatku spánku
        final startHour = random.nextInt(24);
        final startMinute = random.nextInt(60);

        final sleepStartTime = DateTime(
          date.year,
          date.month,
          date.day,
          startHour,
          startMinute,
        );

        // Náhodná dĺžka spánku (30 min až 4 hodiny)
        final durationMinutes = 30 + random.nextInt(210);
        final sleepEndTime = sleepStartTime.add(
          Duration(minutes: durationMinutes),
        );

        testRecords.add(
          SleepRecord(
            id: 'test_${idCounter++}',
            startTime: sleepStartTime,
            endTime: sleepEndTime,
          ),
        );
      }
    }

    // Ulož všetky testovacie záznamy
    final jsonList = testRecords.map((r) => r.toJson()).toList();
    await _prefs.setString(_storageKey, jsonEncode(jsonList));
  }
}
