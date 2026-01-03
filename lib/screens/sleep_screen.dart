import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sleep_record.dart';
import '../services/sleep_service.dart';

/// Obrazovka pre zaznamenávanie spánku
class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  late SleepService _sleepService;
  bool _isLoading = true;
  SleepRecord? _activeRecord;
  List<SleepRecord> _todayRecords = [];

  @override
  void initState() {
    super.initState();
    _initService();
  }

  Future<void> _initService() async {
    final prefs = await SharedPreferences.getInstance();
    _sleepService = SleepService(prefs);
    _loadData();
  }

  void _loadData() {
    setState(() {
      _activeRecord = _sleepService.getActiveRecord();
      _todayRecords = _sleepService.getTodayRecords();
      _isLoading = false;
    });
  }

  Future<void> _startSleep() async {
    final record = SleepRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: DateTime.now(),
    );
    await _sleepService.addRecord(record);
    _loadData();
  }

  Future<void> _stopSleep() async {
    if (_activeRecord != null) {
      final updated = _activeRecord!.copyWith(endTime: DateTime.now());
      await _sleepService.updateRecord(updated);
      _loadData();
    }
  }

  Future<void> _showAddManualDialog() async {
    DateTime startTime = DateTime.now().subtract(const Duration(hours: 1));
    DateTime endTime = DateTime.now();
    final now = DateTime.now();
    final oneDayAgo = now.subtract(const Duration(days: 1));

    await showCupertinoDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return CupertinoAlertDialog(
              title: const Text('Pridať spánok'),
              content: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Začiatok
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Začiatok',
                            style: TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () async {
                              await showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) => Container(
                                  height: 216,
                                  padding: const EdgeInsets.only(top: 6),
                                  color: CupertinoColors.systemBackground
                                      .resolveFrom(context),
                                  child: SafeArea(
                                    top: false,
                                    child: CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.dateAndTime,
                                      initialDateTime: startTime,
                                      minimumDate: oneDayAgo,
                                      maximumDate: now,
                                      use24hFormat: true,
                                      onDateTimeChanged: (DateTime newTime) {
                                        setDialogState(() {
                                          startTime = newTime;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              '${startTime.day}.${startTime.month}. ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 17,
                                color: CupertinoColors.activeBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Koniec
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Koniec',
                            style: TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () async {
                              await showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) => Container(
                                  height: 216,
                                  padding: const EdgeInsets.only(top: 6),
                                  color: CupertinoColors.systemBackground
                                      .resolveFrom(context),
                                  child: SafeArea(
                                    top: false,
                                    child: CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.dateAndTime,
                                      initialDateTime: endTime,
                                      minimumDate: oneDayAgo,
                                      maximumDate: now,
                                      use24hFormat: true,
                                      onDateTimeChanged: (DateTime newTime) {
                                        setDialogState(() {
                                          endTime = newTime;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              '${endTime.day}.${endTime.month}. ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 17,
                                color: CupertinoColors.activeBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Zrušiť'),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    if (endTime.isAfter(startTime)) {
                      final record = SleepRecord(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        startTime: startTime,
                        endTime: endTime,
                      );
                      await _sleepService.addRecord(record);
                      _loadData();
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }
                    }
                  },
                  child: const Text('Pridať'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteRecord(String id) async {
    final shouldDelete = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Vymazať záznam'),
        content: const Text('Naozaj chcete vymazať tento záznam?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Zrušiť'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Vymazať'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await _sleepService.deleteRecord(id);
      _loadData();
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    final totalSleep = _sleepService.getTotalSleepToday();
    final sleepCount = _sleepService.getSleepCountToday();

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Spánok'),
        backgroundColor: CupertinoColors.systemGroupedBackground,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 20),
            // Aktuálny čas
            Center(
              child: StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Text(
                    _getCurrentTime(),
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w300,
                      color: CupertinoColors.black,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Súhrn za dnes
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Celkový čas',
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDuration(totalSleep),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: CupertinoColors.systemGrey5,
                  ),
                  Column(
                    children: [
                      const Text(
                        'Počet',
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$sleepCount',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Hlavné tlačidlo
            _buildMainButton(),
            const SizedBox(height: 12),
            // Manuálne pridanie
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _showAddManualDialog,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.systemGrey4),
                ),
                child: const Text(
                  'Pridať manuálne',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.systemBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: _activeRecord == null ? _startSleep : _stopSleep,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _activeRecord == null
              ? CupertinoColors.systemBlue
              : CupertinoColors.systemOrange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _activeRecord == null ? 'Začať spánok' : 'Ukončiť spánok',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'História:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 12),
        if (_todayRecords.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'Zatiaľ žiadne záznamy',
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
          )
        else
          ..._todayRecords.reversed
              .map((record) => _buildHistoryItem(record))
              .toList(),
      ],
    );
  }

  Widget _buildHistoryItem(SleepRecord record) {
    final isActive = record.isActive;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive
                  ? CupertinoColors.systemOrange
                  : CupertinoColors.systemIndigo,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${record.startTime.hour.toString().padLeft(2, '0')}:${record.startTime.minute.toString().padLeft(2, '0')} - ${record.endTime != null ? '${record.endTime!.hour.toString().padLeft(2, '0')}:${record.endTime!.minute.toString().padLeft(2, '0')}' : 'prebieha'}  ${record.duration != null ? _formatDuration(record.duration!) : ''}',
              style: const TextStyle(
                fontSize: 16,
                color: CupertinoColors.black,
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 0,
            onPressed: () => _deleteRecord(record.id),
            child: const Icon(
              CupertinoIcons.delete,
              size: 20,
              color: CupertinoColors.systemRed,
            ),
          ),
        ],
      ),
    );
  }
}
