import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
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

  void _showAddBottleModal({BottleFeedingRecord? prefillWith}) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => _AddBottleModal(
        onSave: (record) async {
          await _service.saveRecord(record);
          _loadData();
        },
        prefillWith: prefillWith,
      ),
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
      await _service.deleteRecord(id);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final todayTotal = _todayRecords.fold(0, (sum, r) => sum + r.volumeMl);

    return CupertinoPageScaffold(
      backgroundColor: themeProvider.getBackgroundColor(context),
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Fľaša'),
        backgroundColor: themeProvider.getBackgroundColor(context),
        border: null,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add_circled_solid, size: 28),
          onPressed: _showAddBottleModal,
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header s dnešným sumárom
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _buildTodayHeader(todayTotal),
              ),
            ),

            // Quick action button
            if (_todayRecords.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: _buildQuickAddButton(),
                ),
              ),

            // História ako list
            if (_todayRecords.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.drop,
                        size: 64,
                        color: CupertinoColors.systemGrey.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Žiadne záznamy dnes',
                        style: TextStyle(
                          fontSize: 17,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pridaj prvé kŕmenie',
                        style: TextStyle(
                          fontSize: 15,
                          color: CupertinoColors.systemGrey2,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final record = _todayRecords[index];
                  return _buildRecordListItem(record, index);
                }, childCount: _todayRecords.length),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayHeader(int todayTotal) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: themeProvider.getAccentColorLight(),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              CupertinoIcons.drop_fill,
              color: themeProvider.getPrimaryColor(),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dnes celkom',
                  style: TextStyle(
                    fontSize: 15,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_todayRecords.length}× • $todayTotal ml',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.getTextColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddButton() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final lastRecord = _todayRecords.first;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _showAddBottleModal(prefillWith: lastRecord),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: themeProvider.getAccentColorLight(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: themeProvider.getPrimaryColor().withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.arrow_clockwise,
              color: themeProvider.getPrimaryColor(),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Pridať rovnaké (${lastRecord.volumeMl} ml ${lastRecord.typeLabel})',
              style: TextStyle(
                color: themeProvider.getPrimaryColor(),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordListItem(BottleFeedingRecord record, int index) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      margin: EdgeInsets.fromLTRB(
        16,
        index == 0 ? 0 : 8,
        16,
        index == _todayRecords.length - 1 ? 16 : 0,
      ),
      decoration: BoxDecoration(
        color: themeProvider.getCardColor(context),
        borderRadius: BorderRadius.vertical(
          top: index == 0 ? const Radius.circular(12) : Radius.zero,
          bottom: index == _todayRecords.length - 1
              ? const Radius.circular(12)
              : Radius.zero,
        ),
        border: Border(
          bottom: index == _todayRecords.length - 1
              ? BorderSide.none
              : const BorderSide(color: CupertinoColors.separator, width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: themeProvider.getAccentColorLight(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                record.formattedTime,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: themeProvider.getPrimaryColor(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${record.volumeMl} ml',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: themeProvider.getTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    record.typeLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: () => _deleteRecord(record.id),
              child: const Icon(
                CupertinoIcons.delete,
                size: 20,
                color: CupertinoColors.systemRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modal pre pridanie nového záznamu o kŕmení
class _AddBottleModal extends StatefulWidget {
  final Function(BottleFeedingRecord) onSave;
  final BottleFeedingRecord? prefillWith;

  const _AddBottleModal({required this.onSave, this.prefillWith});

  @override
  State<_AddBottleModal> createState() => _AddBottleModalState();
}

class _AddBottleModalState extends State<_AddBottleModal> {
  late int _volumeMl;
  late DateTime _selectedTime;
  late BottleFeedingType _selectedType;
  int? _lastClickedPreset; // Sledovanie posledného kliknutého presetu

  @override
  void initState() {
    super.initState();
    if (widget.prefillWith != null) {
      _volumeMl = widget.prefillWith!.volumeMl;
      _selectedType = widget.prefillWith!.type;
      _selectedTime = DateTime.now();
    } else {
      _volumeMl = 120;
      _selectedType = BottleFeedingType.formula;
      _selectedTime = DateTime.now();
    }
  }

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

    // Skombinuj dnešný dátum s vybratým časom
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final record = BottleFeedingRecord(
      dateTime: dateTime,
      volumeMl: _volumeMl,
      type: _selectedType,
    );

    widget.onSave(record);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: themeProvider.getBackgroundColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                Text(
                  'Pridať kŕmenie',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.getTextColor(context),
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
                Text(
                  'Objem',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.getTextColor(context),
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
                            ? themeProvider.getPrimaryColor()
                              : CupertinoColors.systemGrey5,
                          onPressed: () => _setPresetVolume(volume),
                          child: Text(
                            '$volume ml',
                            style: TextStyle(
                              color: isSelected
                                  ? CupertinoColors.white
                                  : themeProvider.getTextColor(context),
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
                    color: themeProvider.getCardColor(context),
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
                          decoration: BoxDecoration(
                            color: themeProvider.getPrimaryColor(),
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
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.getTextColor(context),
                        ),
                      ),
                      const SizedBox(width: 32),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: themeProvider.getPrimaryColor(),
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
                Text(
                  'Typ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.getTextColor(context),
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
                              ? themeProvider.getAccentColorLight()
                              : themeProvider.getCardColor(context),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? themeProvider.getPrimaryColor()
                                : CupertinoColors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(icon, style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 12),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: themeProvider.getTextColor(context),
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              Icon(
                                CupertinoIcons.checkmark_circle_fill,
                                color: themeProvider.getPrimaryColor(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: 24),

                // Čas
                Text(
                  'Čas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.getTextColor(context),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: themeProvider.getCardColor(context),
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
