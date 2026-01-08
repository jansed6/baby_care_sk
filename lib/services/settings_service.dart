import 'package:shared_preferences/shared_preferences.dart';

enum ThemeMode {
  light,
  dark,
}

enum ColorTheme {
  neutral,
  girl,
  boy,
}

/// Service pre správu nastavení aplikácie
class SettingsService {
  static const String _themeModeKey = 'theme_mode';
  static const String _colorThemeKey = 'color_theme';
  static const String _vitaminDNotificationKey = 'vitamin_d_notification_enabled';
  static const String _vitaminDNotificationTimeKey = 'vitamin_d_notification_time';

  /// Získanie aktuálneho režimu témy
  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_themeModeKey) ?? 0;
    return ThemeMode.values[modeIndex];
  }

  /// Uloženie režimu témy
  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
  }

  /// Získanie farebnej témy
  Future<ColorTheme> getColorTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_colorThemeKey) ?? 0;
    return ColorTheme.values[themeIndex];
  }

  /// Uloženie farebnej témy
  Future<void> setColorTheme(ColorTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorThemeKey, theme.index);
  }

  /// Zistenie, či sú notifikácie vitamínu D zapnuté
  Future<bool> getVitaminDNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_vitaminDNotificationKey) ?? false;
  }

  /// Nastavenie notifikácií vitamínu D
  Future<void> setVitaminDNotificationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vitaminDNotificationKey, enabled);
  }

  /// Získanie času notifikácie vitamínu D (formát HH:mm)
  Future<String> getVitaminDNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_vitaminDNotificationTimeKey) ?? '20:00';
  }

  /// Nastavenie času notifikácie vitamínu D
  Future<void> setVitaminDNotificationTime(String time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_vitaminDNotificationTimeKey, time);
  }
}
