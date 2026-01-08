import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../models/breastfeeding_record.dart';
import '../services/breastfeeding_service.dart';

/// Obrazovka pre zaznamenávanie dojčenia
class BreastfeedingScreen extends StatefulWidget {
  const BreastfeedingScreen({super.key});

  @override
  State<BreastfeedingScreen> createState() => _BreastfeedingScreenState();
}

class _BreastfeedingScreenState extends State<BreastfeedingScreen> {
  final BreastfeedingService _service = BreastfeedingService();

  // Výber strany
  BreastfeedingSide _selectedSide = BreastfeedingSide.left;

  // História
  List<BreastfeedingRecord> _todayRecords = [];

  @override
  void initState() {
    super.initState();
    _loadTodayRecords();
  }

  Future<void> _loadTodayRecords() async {
    final records = await _service.getTodayRecords();
    setState(() {
      _todayRecords = records.reversed.toList(); // najnovšie navrchu
    });
  }

  Future<void> _saveRecord() async {
    final record = BreastfeedingRecord(
      time: DateTime.now(),
      side: _selectedSide,
    );

    await _service.saveRecord(record);
    await _loadTodayRecords();
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
      await _loadTodayRecords();
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return CupertinoPageScaffold(
      backgroundColor: themeProvider.getBackgroundColor(context),
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Dojčenie'),
        backgroundColor: themeProvider.getBackgroundColor(context),
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
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w300,
                      color: themeProvider.getTextColor(context),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            _buildSideSelector(),
            const SizedBox(height: 24),
            _buildSaveButton(),
            const SizedBox(height: 32),
            _buildHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildSideSelector() {
    return Row(
      children: [
        Expanded(child: _buildSideButton('Ľavé', BreastfeedingSide.left)),
        const SizedBox(width: 12),
        Expanded(child: _buildSideButton('Obidve', BreastfeedingSide.both)),
        const SizedBox(width: 12),
        Expanded(child: _buildSideButton('Pravé', BreastfeedingSide.right)),
      ],
    );
  }

  Widget _buildSideButton(String label, BreastfeedingSide side) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isSelected = _selectedSide == side;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSide = side;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? themeProvider.getPrimaryColor()
              : themeProvider.getCardColor(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? themeProvider.getPrimaryColor()
                : CupertinoColors.systemGrey4,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? CupertinoColors.white
                : themeProvider.getTextColor(context),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: _saveRecord,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: themeProvider.getPrimaryColor(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Uložiť záznam',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildHistory() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'História:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: themeProvider.getTextColor(context),
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
          ..._todayRecords.map((record) => _buildHistoryItem(record)).toList(),
      ],
    );
  }

  Widget _buildHistoryItem(BreastfeedingRecord record) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: themeProvider.getCardColor(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: themeProvider.getPrimaryColor(),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${record.formattedTime}  ${record.sideLabel}',
              style: TextStyle(
                fontSize: 16,
                color: themeProvider.getTextColor(context),
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
