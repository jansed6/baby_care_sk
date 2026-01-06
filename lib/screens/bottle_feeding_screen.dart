import 'package:flutter/cupertino.dart';
import '../models/bottle_feeding_record.dart';
import '../services/bottle_feeding_service.dart';

/// Obrazovka pre kŕmenie z fľaše so štatistikami a možnosťou pridania záznamu
class BottleFeedingScreen extends StatefulWidget {
  const BottleFeedingScreen({super.key});

  @override
  State<BottleFeedingScreen> createState() => _BottleFeedingScreenState();
}

class _BottleFeedingScreenState extends State<BottleFeedingScreen> {
  final BottleFeedingService _service = BottleFeedingService();
  List<BottleFeedingRecord> _todayRecords = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final todayRecords = await _service.getTodayRecords();

    setState(() {
      _todayRecords = todayRecords;
    });
  }

  void _showAddBottleModal() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => _AddBottleModal(
        onSave: (record) async {
          await _service.saveRecord(record);
          _loadData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todayTotal = _todayRecords.fold(0, (sum, r) => sum + r.volumeMl);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Fľaša'),
        backgroundColor: CupertinoColors.systemGroupedBackground,
        border: null,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add_circled_solid, size: 28),
          onPressed: _showAddBottleModal,
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Dnešné záznamy
            _buildTodaySection(todayTotal),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaySection(int todayTotal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dnes',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                CupertinoIcons.drop_fill,
                color: CupertinoColors.systemBlue,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                '${_todayRecords.length}× • $todayTotal ml',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (_todayRecords.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Žiadne záznamy dnes',
                style: TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 15,
                ),
              ),
            ),
          if (_todayRecords.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              height: 0.5,
              color: CupertinoColors.separator,
            ),
            const SizedBox(height: 8),
            ..._todayRecords.map((record) => _buildRecordItem(record)),
          ],
        ],
      ),
    );
  }

  Widget _buildRecordItem(BottleFeedingRecord record) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              record.formattedTime,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${record.volumeMl} ml',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '• ${record.typeLabel}',
            style: const TextStyle(
              fontSize: 15,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }
}

/// Modal pre pridanie nového záznamu o kŕmení
class _AddBottleModal extends StatefulWidget {
  final Function(BottleFeedingRecord) onSave;

  const _AddBottleModal({required this.onSave});

  @override
  State<_AddBottleModal> createState() => _AddBottleModalState();
}

class _AddBottleModalState extends State<_AddBottleModal> {
  int _volumeMl = 120; // Predvolený objem
  DateTime _selectedTime = DateTime.now();
  BottleFeedingType _selectedType = BottleFeedingType.formula;
  int? _lastClickedPreset; // Sledovanie posledného kliknutého presetu

  void _setPresetVolume(int volume) {
    setState(() {
      if (_lastClickedPreset == volume) {
        // Ak klikáme na ten istý preset, pridaj hodnotu
        _volumeMl = (_volumeMl + volume).clamp(10, 500);
      } else {
        // Pri prvom kliknutí nastav hodnotu
        _volumeMl = volume;
        _lastClickedPreset = volume;
      }
    });
  }

  void _adjustVolume(int delta) {
    setState(() {
      _volumeMl = (_volumeMl + delta).clamp(10, 500);
      _lastClickedPreset = null; // Reset presetu pri manuálnej úprave
    });
  }

  void _saveRecord() {
    if (_volumeMl <= 0) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Chyba'),
          content: const Text('Objem musí byť väčší ako 0 ml'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    final record = BottleFeedingRecord(
      dateTime: _selectedTime,
      volumeMl: _volumeMl,
      type: _selectedType,
    );

    widget.onSave(record);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: CupertinoColors.separator,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text('Zrušiť'),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Pridať kŕmenie',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text(
                    'Uložiť',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onPressed: _saveRecord,
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Predvolené objemy
                const Text(
                  'Objem',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [50, 100, 150, 200].map((volume) {
                    final isSelected = _volumeMl == volume;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          color: isSelected 
                              ? CupertinoColors.systemBlue
                              : CupertinoColors.systemGrey5,
                          onPressed: () => _setPresetVolume(volume),
                          child: Text(
                            '$volume ml',
                            style: TextStyle(
                              color: isSelected 
                                  ? CupertinoColors.white
                                  : CupertinoColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 20),
                
                // Stepper +/- 10 ml
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: CupertinoColors.systemBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.minus,
                            color: CupertinoColors.white,
                          ),
                        ),
                        onPressed: () => _adjustVolume(-10),
                      ),
                      const SizedBox(width: 32),
                      Text(
                        '$_volumeMl ml',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 32),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: CupertinoColors.systemBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.plus,
                            color: CupertinoColors.white,
                          ),
                        ),
                        onPressed: () => _adjustVolume(10),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Typ kŕmenia
                const Text(
                  'Typ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...BottleFeedingType.values.map((type) {
                  final isSelected = _selectedType == type;
                  String icon;
                  String label;
                  
                  switch (type) {
                    case BottleFeedingType.formula:
                      icon = '🍼';
                      label = 'Umelé mlieko';
                      break;
                    case BottleFeedingType.breastMilk:
                      icon = '🤱';
                      label = 'Materské mlieko';
                      break;
                    case BottleFeedingType.water:
                      icon = '💧';
                      label = 'Voda';
                      break;
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = type),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? CupertinoColors.systemBlue.withOpacity(0.1)
                              : CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                                ? CupertinoColors.systemBlue
                                : CupertinoColors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              icon,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: isSelected 
                                    ? FontWeight.w600 
                                    : FontWeight.normal,
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              const Icon(
                                CupertinoIcons.checkmark_circle_fill,
                                color: CupertinoColors.systemBlue,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                
                const SizedBox(height: 24),
                
                // Čas
                const Text(
                  'Čas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: _selectedTime,
                    onDateTimeChanged: (DateTime newTime) {
                      setState(() {
                        _selectedTime = newTime;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
