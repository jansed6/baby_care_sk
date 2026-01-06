import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/breastfeeding_record.dart';

class BreastfeedingService {
  static const String _storageKey = 'breastfeeding_records';

  Future<void> saveRecord(BreastfeedingRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getAllRecords();
    records.add(record);

    final jsonList = records.map((r) => r.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  Future<List<BreastfeedingRecord>> getAllRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => BreastfeedingRecord.fromJson(json)).toList();
  }

  Future<List<BreastfeedingRecord>> getTodayRecords() async {
    final allRecords = await getAllRecords();
    final today = DateTime.now();

    return allRecords.where((record) {
      return record.time.year == today.year &&
          record.time.month == today.month &&
          record.time.day == today.day;
    }).toList();
  }

  Future<int> getTodayCount() async {
    final todayRecords = await getTodayRecords();
    return todayRecords.length;
  }

  Future<List<BreastfeedingRecord>> getRecordsByDate(DateTime date) async {
    final allRecords = await getAllRecords();

    return allRecords.where((record) {
      return record.time.year == date.year &&
          record.time.month == date.month &&
          record.time.day == date.day;
    }).toList();
  }

  Future<void> clearAllRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  Future<void> generateTestData() async {
    final random = Random();
    final now = DateTime.now();
    final testRecords = <BreastfeedingRecord>[];
    final sides = [
      BreastfeedingSide.left,
      BreastfeedingSide.right,
      BreastfeedingSide.both,
    ];

    // Generuj dáta za posledných 365 dní
    for (int dayOffset = 0; dayOffset < 365; dayOffset++) {
      final date = now.subtract(Duration(days: dayOffset));

      // Náhodný počet dojčení za deň (2-8)
      final feedingsPerDay = 2 + random.nextInt(7);

      for (int i = 0; i < feedingsPerDay; i++) {
        // Náhodný čas v priebehu dňa
        final hour = random.nextInt(24);
        final minute = random.nextInt(60);

        final feedingTime = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );

        // Náhodná strana
        final side = sides[random.nextInt(sides.length)];

        testRecords.add(BreastfeedingRecord(time: feedingTime, side: side));
      }
    }

    // Ulož všetky testovacie záznamy
    final prefs = await SharedPreferences.getInstance();
    final jsonList = testRecords.map((r) => r.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }
}
