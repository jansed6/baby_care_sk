import 'package:flutter/cupertino.dart';
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

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Dojčenie'),
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
              ? CupertinoColors.systemBlue
              : CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? CupertinoColors.systemBlue
                : CupertinoColors.systemGrey4,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? CupertinoColors.white : CupertinoColors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: _saveRecord,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBlue,
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
          ..._todayRecords.map((record) => _buildHistoryItem(record)).toList(),
      ],
    );
  }

  Widget _buildHistoryItem(BreastfeedingRecord record) {
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
            decoration: const BoxDecoration(
              color: CupertinoColors.systemPink,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${record.formattedTime}  ${record.sideLabel}',
            style: const TextStyle(fontSize: 16, color: CupertinoColors.black),
          ),
        ],
      ),
    );
  }
}
