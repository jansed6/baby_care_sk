import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diaper_record.dart';

/// Service pre správu záznamov o plienkach
class DiaperService {
  static const String _storageKey = 'diaper_records';

  /// Uloženie nového záznamu
  Future<void> saveRecord(DiaperRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getAllRecords();
    records.add(record);

    // Zoraď záznamy podľa času (najnovšie navrchu)
    records.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    final jsonList = records.map((r) => r.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  /// Získanie všetkých záznamov
  Future<List<DiaperRecord>> getAllRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => DiaperRecord.fromJson(json)).toList();
  }

  /// Získanie dnešných záznamov
  Future<List<DiaperRecord>> getTodayRecords() async {
    final allRecords = await getAllRecords();
    final today = DateTime.now();

    return allRecords.where((record) {
      return record.dateTime.year == today.year &&
          record.dateTime.month == today.month &&
          record.dateTime.day == today.day;
    }).toList();
  }

  /// Počet plienok dnes
  Future<int> getTodayCount() async {
    final todayRecords = await getTodayRecords();
    return todayRecords.length;
  }

  /// Počet mokrých plienok dnes
  Future<int> getTodayWetCount() async {
    final todayRecords = await getTodayRecords();
    return todayRecords.where((r) => r.type == DiaperType.wet || r.type == DiaperType.mixed).length;
  }

  /// Počet špinavých plienok dnes
  Future<int> getTodayDirtyCount() async {
    final todayRecords = await getTodayRecords();
    return todayRecords.where((r) => r.type == DiaperType.dirty || r.type == DiaperType.mixed).length;
  }

  /// Posledný záznam
  Future<DiaperRecord?> getLastRecord() async {
    final allRecords = await getAllRecords();
    if (allRecords.isEmpty) return null;
    return allRecords.first;
  }

  /// Vymazanie záznamu
  Future<void> deleteRecord(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getAllRecords();
    records.removeWhere((record) => record.id == id);

    final jsonList = records.map((r) => r.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  /// Aktualizácia existujúceho záznamu
  Future<void> updateRecord(DiaperRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getAllRecords();
    
    final index = records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      records[index] = record;
      records.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      
      final jsonList = records.map((r) => r.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
    }
  }

  /// Generovanie testovacích dát
  Future<void> generateTestData() async {
    final prefs = await SharedPreferences.getInstance();
    final random = Random();
    final now = DateTime.now();
    final testRecords = <DiaperRecord>[];
    final types = [DiaperType.wet, DiaperType.dirty, DiaperType.mixed];

    // Generuj dáta za posledných 365 dní
    for (int dayOffset = 0; dayOffset < 365; dayOffset++) {
      final date = now.subtract(Duration(days: dayOffset));

      // Náhodný počet plienok za deň (4-10)
      final diapersPerDay = 4 + random.nextInt(7);

      for (int i = 0; i < diapersPerDay; i++) {
        // Náhodný čas v priebehu dňa
        final hour = random.nextInt(24);
        final minute = random.nextInt(60);

        final diaperTime = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );

        // Náhodný typ plienky
        final type = types[random.nextInt(types.length)];

        testRecords.add(DiaperRecord(
          dateTime: diaperTime,
          type: type,
        ));
      }
    }

    // Ulož všetky testovacie záznamy
    final jsonList = testRecords.map((r) => r.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }
}
