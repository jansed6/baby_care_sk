import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/breastfeeding_record.dart';
import '../services/breastfeeding_service.dart';
import '../services/bottle_feeding_service.dart';
import '../services/sleep_service.dart';
import '../components/period_selector.dart';
import '../components/breastfeeding_statistics_card.dart';
import '../components/bottle_feeding_statistics_card.dart';
import '../components/sleep_statistics_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final BreastfeedingService _breastfeedingService = BreastfeedingService();
  final BottleFeedingService _bottleFeedingService = BottleFeedingService();
  late SleepService _sleepService;
  StatisticsPeriod _selectedPeriod = StatisticsPeriod.week;
  Map<DateTime, Map<BreastfeedingSide, int>> _breastfeedingStatistics = {};
  Map<DateTime, int> _bottleFeedingStatistics = {};
  Map<DateTime, Duration> _sleepStatistics = {};
  bool _isLoading = true;
  bool _isServiceInitialized = false;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final prefs = await SharedPreferences.getInstance();
    _sleepService = SleepService(prefs);
    setState(() {
      _isServiceInitialized = true;
    });
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    if (!_isServiceInitialized) return;

    setState(() => _isLoading = true);

    // Načítaj dojčenie
    final allBreastfeedingRecords = await _breastfeedingService.getAllRecords();
    final breastfeedingStats = <DateTime, Map<BreastfeedingSide, int>>{};

    // Načítaj fľašu
    final allBottleFeedingRecords = await _bottleFeedingService.getAllRecords();
    final bottleFeedingStats = <DateTime, int>{};

    // Načítaj spánok
    final allSleepRecords = _sleepService.getAllRecords();
    final sleepStats = <DateTime, Duration>{};

    final now = DateTime.now();
    DateTime startDate;
    switch (_selectedPeriod) {
      case StatisticsPeriod.week:
        startDate = now.subtract(Duration(days: 6));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        break;
      case StatisticsPeriod.month:
        startDate = now.subtract(Duration(days: 29));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        break;
      case StatisticsPeriod.year:
        startDate = DateTime(now.year - 1, now.month, 1);
        break;
    }

    // Spracuj dojčenie
    for (var record in allBreastfeedingRecords) {
      DateTime recordDate;

      if (_selectedPeriod == StatisticsPeriod.year) {
        recordDate = DateTime(record.time.year, record.time.month, 1);
      } else if (_selectedPeriod == StatisticsPeriod.month) {
        final daysFromMonday = (record.time.weekday - 1);
        final weekStart = record.time.subtract(Duration(days: daysFromMonday));
        recordDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
      } else {
        recordDate = DateTime(
          record.time.year,
          record.time.month,
          record.time.day,
        );
      }

      if (recordDate.isAfter(startDate.subtract(Duration(days: 1))) &&
          recordDate.isBefore(now.add(Duration(days: 1)))) {
        if (!breastfeedingStats.containsKey(recordDate)) {
          breastfeedingStats[recordDate] = {
            BreastfeedingSide.left: 0,
            BreastfeedingSide.right: 0,
            BreastfeedingSide.both: 0,
          };
        }

        breastfeedingStats[recordDate]![record.side] =
            breastfeedingStats[recordDate]![record.side]! + 1;
      }
    }

    // Spracuj fľašu
    for (var record in allBottleFeedingRecords) {
      DateTime recordDate;

      if (_selectedPeriod == StatisticsPeriod.year) {
        recordDate = DateTime(record.dateTime.year, record.dateTime.month, 1);
      } else if (_selectedPeriod == StatisticsPeriod.month) {
        final daysFromMonday = (record.dateTime.weekday - 1);
        final weekStart = record.dateTime.subtract(Duration(days: daysFromMonday));
        recordDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
      } else {
        recordDate = DateTime(
          record.dateTime.year,
          record.dateTime.month,
          record.dateTime.day,
        );
      }

      if (recordDate.isAfter(startDate.subtract(Duration(days: 1))) &&
          recordDate.isBefore(now.add(Duration(days: 1)))) {
        bottleFeedingStats[recordDate] = 
            (bottleFeedingStats[recordDate] ?? 0) + record.volumeMl;
      }
    }

    // Spracuj spánok
    for (var record in allSleepRecords) {
      if (record.duration == null) continue; // Preskoč aktívne záznamy

      DateTime recordDate;

      if (_selectedPeriod == StatisticsPeriod.year) {
        recordDate = DateTime(record.startTime.year, record.startTime.month, 1);
      } else if (_selectedPeriod == StatisticsPeriod.month) {
        final daysFromMonday = (record.startTime.weekday - 1);
        final weekStart = record.startTime.subtract(
          Duration(days: daysFromMonday),
        );
        recordDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
      } else {
        recordDate = DateTime(
          record.startTime.year,
          record.startTime.month,
          record.startTime.day,
        );
      }

      if (recordDate.isAfter(startDate.subtract(Duration(days: 1))) &&
          recordDate.isBefore(now.add(Duration(days: 1)))) {
        if (!sleepStats.containsKey(recordDate)) {
          sleepStats[recordDate] = Duration.zero;
        }
        sleepStats[recordDate] = sleepStats[recordDate]! + record.duration!;
      }
    }

    setState(() {
      _breastfeedingStatistics = breastfeedingStats;
      _bottleFeedingStatistics = bottleFeedingStats;
      _sleepStatistics = sleepStats;
      _isLoading = false;
    });
  }

  void _onPeriodChanged(StatisticsPeriod period) {
    setState(() {
      _selectedPeriod = period;
    });
    _loadStatistics();
  }

  Future<void> _generateTestData() async {
    final shouldGenerate = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Generovať testovacie dáta?'),
        content: const Text(
          'Toto vytvorí náhodné dojčenie, fľašu a spánok za posledný rok. Existujúce dáta budú nahradené.',
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Zrušiť'),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Generovať'),
          ),
        ],
      ),
    );

    if (shouldGenerate == true && _isServiceInitialized) {
      setState(() => _isLoading = true);
      await _breastfeedingService.generateTestData();
      await _bottleFeedingService.generateTestData();
      await _sleepService.generateTestData();
      await _loadStatistics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Statistiky'),
        backgroundColor: CupertinoColors.systemGroupedBackground,
        border: null,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _generateTestData,
          child: const Icon(CupertinoIcons.chart_bar_alt_fill, size: 24),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            PeriodSelector(
              selectedPeriod: _selectedPeriod,
              onPeriodChanged: _onPeriodChanged,
            ),
            const SizedBox(height: 24),
            BreastfeedingStatisticsCard(
              statistics: _breastfeedingStatistics,
              selectedPeriod: _selectedPeriod,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
            SleepStatisticsCard(
              statistics: _sleepStatistics,
              selectedPeriod: _selectedPeriod,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
            BottleFeedingStatisticsCard(
              statistics: _bottleFeedingStatistics,
              selectedPeriod: _selectedPeriod,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
