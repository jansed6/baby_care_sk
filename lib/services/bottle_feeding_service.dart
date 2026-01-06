import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bottle_feeding_record.dart';

/// Service pre správu záznamov o kŕmení z fľaše
class BottleFeedingService {
  static const String _storageKey = 'bottle_feeding_records';

  /// Uloženie nového záznamu
  Future<void> saveRecord(BottleFeedingRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getAllRecords();
    records.add(record);

    // Zoraď záznamy podľa času (najnovšie navrchu)
    records.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    final jsonList = records.map((r) => r.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  /// Získanie všetkých záznamov
  Future<List<BottleFeedingRecord>> getAllRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => BottleFeedingRecord.fromJson(json)).toList();
  }

  /// Získanie dnešných záznamov
  Future<List<BottleFeedingRecord>> getTodayRecords() async {
    final allRecords = await getAllRecords();
    final today = DateTime.now();

    return allRecords.where((record) {
      return record.dateTime.year == today.year &&
          record.dateTime.month == today.month &&
          record.dateTime.day == today.day;
    }).toList();
  }

  /// Počet kŕmení dnes
  Future<int> getTodayCount() async {
    final todayRecords = await getTodayRecords();
    return todayRecords.length;
  }

  /// Celkový objem dnes v ml
  Future<int> getTodayTotalVolume() async {
    final todayRecords = await getTodayRecords();
    return todayRecords.fold<int>(0, (sum, record) => sum + record.volumeMl);
  }

  /// Získanie záznamov pre konkrétny deň
  Future<List<BottleFeedingRecord>> getRecordsByDate(DateTime date) async {
    final allRecords = await getAllRecords();

    return allRecords.where((record) {
      return record.dateTime.year == date.year &&
          record.dateTime.month == date.month &&
          record.dateTime.day == date.day;
    }).toList();
  }

  /// Celkový objem pre konkrétny deň v ml
  Future<int> getTotalVolumeByDate(DateTime date) async {
    final records = await getRecordsByDate(date);
    return records.fold<int>(0, (sum, record) => sum + record.volumeMl);
  }

  /// Získanie záznamov za posledných N dní (vrátane dnešného dňa)
  Future<List<BottleFeedingRecord>> getRecordsForLastNDays(int days) async {
    final allRecords = await getAllRecords();
    final cutoffDate = DateTime.now().subtract(Duration(days: days - 1));
    final cutoffMidnight = DateTime(cutoffDate.year, cutoffDate.month, cutoffDate.day);

    return allRecords
        .where((record) => record.dateTime.isAfter(cutoffMidnight))
        .toList();
  }

  /// Štatistika: zoskupenie záznamov podľa dní (pre grafy)
  /// Vráti mapu: dátum -> celkový objem v ml
  Future<Map<DateTime, int>> getVolumeByDay(int days) async {
    final records = await getRecordsForLastNDays(days);
    final Map<DateTime, int> volumeByDay = {};

    for (var record in records) {
      final day = DateTime(record.dateTime.year, record.dateTime.month, record.dateTime.day);
      volumeByDay[day] = (volumeByDay[day] ?? 0) + record.volumeMl;
    }

    return volumeByDay;
  }

  /// Štatistika: priemerný denný príjem za posledných N dní
  Future<double> getAverageDailyVolume(int days) async {
    final volumeByDay = await getVolumeByDay(days);
    
    if (volumeByDay.isEmpty) {
      return 0;
    }

    final totalVolume = volumeByDay.values.fold(0, (sum, vol) => sum + vol);
    return totalVolume / days; // Počítame aj dni bez záznamov
  }

  /// Štatistika: priemerný objem jednej fľaše za posledných N dní
  Future<double> getAverageBottleSize(int days) async {
    final records = await getRecordsForLastNDays(days);
    
    if (records.isEmpty) {
      return 0;
    }

    final totalVolume = records.fold(0, (sum, record) => sum + record.volumeMl);
    return totalVolume / records.length;
  }

  /// Vymazanie záznamu
  Future<void> deleteRecord(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getAllRecords();
    records.removeWhere((record) => record.id == id);

    final jsonList = records.map((r) => r.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  /// Generovanie testovacích dát pre vývoj a demonštráciu
  Future<void> generateTestData() async {
    final prefs = await SharedPreferences.getInstance();
    final random = Random();
    final records = <BottleFeedingRecord>[];
    
    // Vygeneruj dáta za posledných 365 dní
    final now = DateTime.now();
    
    for (int dayOffset = 0; dayOffset < 365; dayOffset++) {
      final date = now.subtract(Duration(days: dayOffset));
      
      // 3-6 kŕmení denne
      final feedingsPerDay = 3 + random.nextInt(4);
      
      for (int i = 0; i < feedingsPerDay; i++) {
        // Rozdelené cez deň (6:00 - 22:00)
        final hour = 6 + (16 * i ~/ feedingsPerDay);
        final minute = random.nextInt(60);
        
        final feedingTime = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );
        
        // Objem: 60-180 ml (typické pre dojčatá)
        final volumes = [60, 90, 120, 150, 180];
        final volume = volumes[random.nextInt(volumes.length)];
        
        // Typ: väčšinou umelé mlieko, niekedy materské alebo voda
        final typeRandom = random.nextDouble();
        final type = typeRandom < 0.7
            ? BottleFeedingType.formula
            : typeRandom < 0.9
                ? BottleFeedingType.breastMilk
                : BottleFeedingType.water;
        
        records.add(BottleFeedingRecord(
          dateTime: feedingTime,
          volumeMl: volume,
          type: type,
        ));
      }
    }
    
    // Zoraď a ulož
    records.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    final jsonList = records.map((r) => r.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }
}
