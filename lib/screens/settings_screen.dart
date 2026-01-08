import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';

/// Obrazovka s nastaveniami aplikácie
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  final NotificationService _notificationService = NotificationService();
  
  bool _vitaminDNotificationEnabled = false;
  String _vitaminDNotificationTime = '20:00';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final notificationEnabled = await _settingsService.getVitaminDNotificationEnabled();
    final notificationTime = await _settingsService.getVitaminDNotificationTime();

    setState(() {
      _vitaminDNotificationEnabled = notificationEnabled;
      _vitaminDNotificationTime = notificationTime;
    });
  }

  Future<void> _setVitaminDNotificationEnabled(bool enabled) async {
    await _settingsService.setVitaminDNotificationEnabled(enabled);
    setState(() {
      _vitaminDNotificationEnabled = enabled;
    });

    // Aktualizuj notifikácie
    if (enabled) {
      final timeParts = _vitaminDNotificationTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      await _notificationService.scheduleDailyVitaminDReminder(hour, minute);
    } else {
      await _notificationService.cancelVitaminDReminder();
    }
  }

  Future<void> _setVitaminDNotificationTime(String time) async {
    await _settingsService.setVitaminDNotificationTime(time);
    setState(() {
      _vitaminDNotificationTime = time;
    });

    // Ak sú notifikácie zapnuté, aktualizuj čas
    if (_vitaminDNotificationEnabled) {
      final timeParts = time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      await _notificationService.scheduleDailyVitaminDReminder(hour, minute);
    }
  }

  void _showTimePicker() {
    final timeParts = _vitaminDNotificationTime.split(':');
    final initialHour = int.parse(timeParts[0]);
    final initialMinute = int.parse(timeParts[1]);

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              height: 50,
              color: CupertinoColors.systemBackground.resolveFrom(context),
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
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                initialDateTime: DateTime(2000, 1, 1, initialHour, initialMinute),
                onDateTimeChanged: (DateTime newDateTime) {
                  final time = '${newDateTime.hour.toString().padLeft(2, '0')}:${newDateTime.minute.toString().padLeft(2, '0')}';
                  _setVitaminDNotificationTime(time);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return CupertinoPageScaffold(
      backgroundColor: themeProvider.getBackgroundColor(context),
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Nastavenia'),
        backgroundColor: themeProvider.getBackgroundColor(context),
        border: null,
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 24),
            // Sekcia vzhľad
            _buildSectionHeader('Vzhľad'),
            _buildSettingsGroup([
              _buildThemeSelector(),
              _buildDivider(),
              _buildColorThemeSelector(),
            ]),

            const SizedBox(height: 32),

            // Sekcia pripomienky
            _buildSectionHeader('Pripomienky'),
            _buildSettingsGroup([
              _buildVitaminDNotificationToggle(),
              if (_vitaminDNotificationEnabled) ...[
                _buildDivider(),
                _buildVitaminDTimePicker(),
              ],
            ]),

            const SizedBox(height: 32),

            // Sekcia o aplikácii
            _buildSectionHeader('O aplikácii'),
            _buildSettingsGroup([
              _buildInfoRow('Verzia', '1.0.0'),
            ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: themeProvider.getCardColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      height: 1,
      color: CupertinoColors.systemGrey5,
    );
  }

  Widget _buildThemeSelector() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(CupertinoIcons.brightness, size: 24, color: CupertinoColors.systemGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tmavý režim',
              style: TextStyle(fontSize: 16, color: themeProvider.getTextColor(context)),
            ),
          ),
          CupertinoSwitch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildColorThemeSelector() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              const Icon(CupertinoIcons.paintbrush, size: 24, color: CupertinoColors.systemGrey),
              const SizedBox(width: 12),
              Text(
                'Farebná téma',
                style: TextStyle(fontSize: 16, color: themeProvider.getTextColor(context)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: _buildColorThemeOption(
                  'Neutrálna',
                  ColorTheme.neutral,
                  CupertinoColors.systemGreen,
                  themeProvider,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildColorThemeOption(
                  'Dievča',
                  ColorTheme.girl,
                  CupertinoColors.systemPink,
                  themeProvider,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildColorThemeOption(
                  'Chlapec',
                  ColorTheme.boy,
                  CupertinoColors.systemBlue,
                  themeProvider,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorThemeOption(String label, ColorTheme theme, Color color, ThemeProvider themeProvider) {
    final isSelected = themeProvider.colorTheme == theme;
    return GestureDetector(
      onTap: () => themeProvider.setColorTheme(theme),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : CupertinoColors.systemGrey5,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? const Icon(
                      CupertinoIcons.check_mark,
                      color: CupertinoColors.white,
                      size: 18,
                    )
                  : null,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? color : CupertinoColors.systemGrey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitaminDNotificationToggle() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(CupertinoIcons.bell, size: 24, color: CupertinoColors.systemGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pripomienka Vitamín D',
                  style: TextStyle(fontSize: 16, color: themeProvider.getTextColor(context)),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Upozorní, ak nie je zaškrtnutý',
                  style: TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: _vitaminDNotificationEnabled,
            onChanged: _setVitaminDNotificationEnabled,
          ),
        ],
      ),
    );
  }

  Widget _buildVitaminDTimePicker() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onPressed: _showTimePicker,
      child: Row(
        children: [
          const Icon(CupertinoIcons.clock, size: 24, color: CupertinoColors.systemGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Čas pripomienky',
              style: TextStyle(fontSize: 16, color: themeProvider.getTextColor(context)),
            ),
          ),
          Text(
            _vitaminDNotificationTime,
            style: const TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
          ),
          const SizedBox(width: 8),
          const Icon(CupertinoIcons.chevron_right, size: 20, color: CupertinoColors.systemGrey3),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(CupertinoIcons.info_circle, size: 24, color: CupertinoColors.systemGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: themeProvider.getTextColor(context)),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
          ),
        ],
      ),
    );
  }
}
