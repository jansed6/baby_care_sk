import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../models/diaper_record.dart';
import '../services/diaper_service.dart';

/// Obrazovka pre plienky s rýchlym pridávaním a históriou
class DiaperScreen extends StatefulWidget {
  const DiaperScreen({super.key});

  @override
  State<DiaperScreen> createState() => _DiaperScreenState();
}

class _DiaperScreenState extends State<DiaperScreen> {
  final DiaperService _service = DiaperService();
  List<DiaperRecord> _todayRecords = [];
  DiaperRecord? _lastRecord;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final todayRecords = await _service.getTodayRecords();
    final lastRecord = await _service.getLastRecord();

    setState(() {
      _todayRecords = todayRecords;
      _lastRecord = lastRecord;
    });
  }

  Future<void> _quickAdd(DiaperType type) async {
    final record = DiaperRecord(dateTime: DateTime.now(), type: type);
    await _service.saveRecord(record);
    _loadData();
  }

  void _showDetailModal(DiaperRecord record) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => _DiaperDetailScreen(
          record: record,
          onSave: (updated) async {
            await _service.updateRecord(updated);
            _loadData();
          },
          onDelete: () async {
            await _service.deleteRecord(record.id);
            _loadData();
          },
        ),
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
    final wetCount = _todayRecords
        .where((r) => r.type == DiaperType.wet || r.type == DiaperType.mixed)
        .length;
    final dirtyCount = _todayRecords
        .where((r) => r.type == DiaperType.dirty || r.type == DiaperType.mixed)
        .length;

    return CupertinoPageScaffold(
      backgroundColor: themeProvider.getBackgroundColor(context),
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Plienky'),
        backgroundColor: themeProvider.getBackgroundColor(context),
        border: null,
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Quick action buttons
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: _buildQuickActions(),
              ),
            ),

            // Dnešný prehľad
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: _buildTodayOverview(wetCount, dirtyCount),
              ),
            ),

            // História
            if (_todayRecords.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    'DNES',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.systemGrey.resolveFrom(context),
                    ),
                  ),
                ),
              ),

            if (_todayRecords.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'Zatiaľ žiadne záznamy dnes',
                      style: TextStyle(
                        fontSize: 15,
                        color: CupertinoColors.systemGrey.resolveFrom(context),
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final record = _todayRecords[index];
                  return _buildHistoryItem(record);
                }, childCount: _todayRecords.length),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: CupertinoIcons.drop_fill,
            label: 'Mokrá',
            color: Provider.of<ThemeProvider>(context, listen: false).getPrimaryColor(),
            onPressed: () => _quickAdd(DiaperType.wet),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: CupertinoIcons.circle_fill,
            label: 'Špinavá',
            color: CupertinoColors.systemBrown,
            onPressed: () => _quickAdd(DiaperType.dirty),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: CupertinoIcons.circle_grid_hex_fill,
            label: 'Obe',
            color: Provider.of<ThemeProvider>(context, listen: false).getPrimaryColor(),
            onPressed: () => _quickAdd(DiaperType.mixed),
          ),
        ),
      ],
    );
  }

  Widget _buildTodayOverview(int wetCount, int dirtyCount) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.chart_bar_fill,
                size: 20,
                color: CupertinoColors.systemGrey,
              ),
              const SizedBox(width: 8),
              const Text(
                'Dnes',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Celkom',
                '${_todayRecords.length}',
                CupertinoColors.systemGrey,
              ),
              Container(
                width: 1,
                height: 40,
                color: CupertinoColors.systemGrey5,
              ),
              _buildStatItem('💧', '$wetCount', themeProvider.getPrimaryColor()),
              Container(
                width: 1,
                height: 40,
                color: CupertinoColors.systemGrey5,
              ),
              _buildStatItem('💩', '$dirtyCount', CupertinoColors.systemBrown),
            ],
          ),
          if (_lastRecord != null) ...[
            const SizedBox(height: 16),
            Container(height: 1, color: CupertinoColors.systemGrey5),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  CupertinoIcons.clock,
                  size: 16,
                  color: CupertinoColors.systemGrey,
                ),
                const SizedBox(width: 6),
                Text(
                  'Posledná: ${_lastRecord!.typeLabel}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                const Spacer(),
                Text(
                  _getRelativeTime(_lastRecord!.dateTime),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(DiaperRecord record) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: themeProvider.getCardColor(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: GestureDetector(
          onTap: () => _showDetailModal(record),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getTypeColor(record.type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getTypeIcon(record.type),
                    size: 20,
                    color: _getTypeColor(record.type),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.typeLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (record.note != null && record.note!.isNotEmpty)
                        Text(
                          record.note!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.systemGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Text(
                  record.formattedTime,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                const SizedBox(width: 8),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  child: const Icon(
                    CupertinoIcons.trash,
                    size: 20,
                    color: CupertinoColors.systemRed,
                  ),
                  onPressed: () => _deleteRecord(record.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(DiaperType type) {
    switch (type) {
      case DiaperType.wet:
        return CupertinoIcons.drop_fill;
      case DiaperType.dirty:
        return CupertinoIcons.circle_fill;
      case DiaperType.mixed:
        return CupertinoIcons.circle_grid_hex_fill;
    }
  }

  Color _getTypeColor(DiaperType type) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    switch (type) {
      case DiaperType.wet:
        return themeProvider.getPrimaryColor();
      case DiaperType.dirty:
        return CupertinoColors.systemBrown;
      case DiaperType.mixed:
        return themeProvider.getPrimaryColor();
    }
  }

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'teraz';
    } else if (difference.inMinutes < 60) {
      return 'pred ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'pred ${difference.inHours} h';
    } else {
      return 'pred ${difference.inDays} d';
    }
  }
}

/// Quick action button widget
class _QuickActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(widget.icon, size: 36, color: widget.color),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Detail screen pre úpravu záznamu
class _DiaperDetailScreen extends StatefulWidget {
  final DiaperRecord record;
  final Function(DiaperRecord) onSave;
  final VoidCallback onDelete;

  const _DiaperDetailScreen({
    required this.record,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<_DiaperDetailScreen> createState() => _DiaperDetailScreenState();
}

class _DiaperDetailScreenState extends State<_DiaperDetailScreen> {
  late DiaperType _type;
  late DateTime _dateTime;
  DiaperSize? _size;
  StoolColor? _color;
  final TextEditingController _noteController = TextEditingController();
  bool _showMore = false;

  @override
  void initState() {
    super.initState();
    _type = widget.record.type;
    _dateTime = widget.record.dateTime;
    _size = widget.record.size;
    _color = widget.record.color;
    _noteController.text = widget.record.note ?? '';
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    final updated = DiaperRecord(
      id: widget.record.id,
      dateTime: _dateTime,
      type: _type,
      size: _size,
      color: _color,
      note: _noteController.text.isEmpty ? null : _noteController.text,
    );
    widget.onSave(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Detail plienky'),
        backgroundColor: CupertinoColors.systemGroupedBackground,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Zrušiť'),
          onPressed: () => Navigator.pop(context),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text(
            'Uložiť',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          onPressed: _save,
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            // Typ plienky
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: themeProvider.getCardColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Typ',
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ),
                  _buildTypeSelector(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Čas
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: themeProvider.getCardColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CupertinoButton(
                padding: const EdgeInsets.all(16),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => Container(
                      height: 250,
                      color: CupertinoColors.systemBackground.resolveFrom(
                        context,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            color: CupertinoColors.systemBackground.resolveFrom(
                              context,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CupertinoButton(
                                  child: const Text('Zrušiť'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                CupertinoButton(
                                  child: const Text('Hotovo'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.dateAndTime,
                              initialDateTime: _dateTime,
                              maximumDate: DateTime.now(),
                              onDateTimeChanged: (DateTime newDateTime) {
                                setState(() {
                                  _dateTime = newDateTime;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.clock, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Čas',
                      style: TextStyle(
                        fontSize: 16,
                        color: themeProvider.getTextColor(context),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_dateTime.day}.${_dateTime.month}. ${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Rozbaľovacia sekcia "Viac"
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: themeProvider.getCardColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.all(16),
                    onPressed: () => setState(() => _showMore = !_showMore),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.ellipsis_circle, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          'Viac',
                          style: TextStyle(
                            fontSize: 16,
                            color: themeProvider.getTextColor(context),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          _showMore
                              ? CupertinoIcons.chevron_up
                              : CupertinoIcons.chevron_down,
                          size: 20,
                          color: CupertinoColors.systemGrey,
                        ),
                      ],
                    ),
                  ),
                  if (_showMore) ...[
                    Container(height: 1, color: CupertinoColors.systemGrey5),
                    // Množstvo
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Množstvo',
                            style: TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(child: _buildSizeOption(null, '—')),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildSizeOption(
                                  DiaperSize.small,
                                  'Malá',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildSizeOption(
                                  DiaperSize.medium,
                                  'Stredná',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildSizeOption(
                                  DiaperSize.large,
                                  'Veľká',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(height: 1, color: CupertinoColors.systemGrey5),
                    // Farba stolice
                    if (_type == DiaperType.dirty || _type == DiaperType.mixed)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Farba stolice',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildColorOption(null, '—'),
                                _buildColorOption(StoolColor.yellow, 'Žltá'),
                                _buildColorOption(StoolColor.green, 'Zelená'),
                                _buildColorOption(StoolColor.brown, 'Hnedá'),
                                _buildColorOption(StoolColor.black, 'Čierna'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (_type == DiaperType.dirty || _type == DiaperType.mixed)
                      Container(height: 1, color: CupertinoColors.systemGrey5),
                    // Poznámka
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Poznámka',
                            style: TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CupertinoTextField(
                            controller: _noteController,
                            placeholder: 'Voliteľná poznámka...',
                            maxLines: 3,
                            padding: const EdgeInsets.all(12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Vymazať button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoButton(
                color: CupertinoColors.systemRed,
                onPressed: () {
                  Navigator.pop(context);
                  widget.onDelete();
                },
                child: const Text('Vymazať záznam'),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        _buildTypeOption(
          DiaperType.wet,
          'Mokrá',
          CupertinoIcons.drop_fill,
          CupertinoColors.systemBlue,
        ),
        _buildTypeOption(
          DiaperType.dirty,
          'Špinavá',
          CupertinoIcons.circle_fill,
          CupertinoColors.systemBrown,
        ),
        _buildTypeOption(
          DiaperType.mixed,
          'Obe',
          CupertinoIcons.circle_grid_hex_fill,
          CupertinoColors.systemGreen,
        ),
      ],
    );
  }

  Widget _buildTypeOption(
    DiaperType type,
    String label,
    IconData icon,
    Color color,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isSelected = _type == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _type = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.1)
                : themeProvider.getCardColor(context),
            border: Border.all(
              color: isSelected ? color : CupertinoColors.systemGrey5,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected ? color : CupertinoColors.systemGrey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? color : CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSizeOption(DiaperSize? size, String label) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isSelected = _size == size;
    return GestureDetector(
      onTap: () => setState(() => _size = size),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? CupertinoColors.activeBlue.withValues(alpha: 0.1)
              : CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? CupertinoColors.activeBlue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? CupertinoColors.activeBlue
                : themeProvider.getTextColor(context),
          ),
        ),
      ),
    );
  }

  Widget _buildColorOption(StoolColor? color, String label) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isSelected = _color == color;
    return GestureDetector(
      onTap: () => setState(() => _color = color),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? CupertinoColors.activeBlue.withValues(alpha: 0.1)
              : CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? CupertinoColors.activeBlue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? CupertinoColors.activeBlue
                : themeProvider.getTextColor(context),
          ),
        ),
      ),
    );
  }
}
