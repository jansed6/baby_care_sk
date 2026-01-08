import 'package:flutter/cupertino.dart';
import '../services/settings_service.dart';

/// Provider pre správu témy aplikácie
class ThemeProvider extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();
  ThemeMode _themeMode = ThemeMode.light;
  ColorTheme _colorTheme = ColorTheme.neutral;

  ThemeMode get themeMode => _themeMode;
  ColorTheme get colorTheme => _colorTheme;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _themeMode = await _settingsService.getThemeMode();
    _colorTheme = await _settingsService.getColorTheme();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _settingsService.setThemeMode(mode);
    notifyListeners();
  }

  Future<void> setColorTheme(ColorTheme theme) async {
    _colorTheme = theme;
    await _settingsService.setColorTheme(theme);
    notifyListeners();
  }

  /// Získa primárnu farbu podľa témy
  Color getPrimaryColor() {
    switch (_colorTheme) {
      case ColorTheme.neutral:
        return const Color(0xFF34C759); // Tmavšia zelená
      case ColorTheme.girl:
        return const Color(0xFFFF2D55); // Tmavšia ružová
      case ColorTheme.boy:
        return const Color(0xFF007AFF); // Tmavšia modrá
    }
  }

  /// Získa farbu pozadia
  Color getBackgroundColor(BuildContext context) {
    if (isDarkMode) {
      // Tmavý režim - jemný farebný nádych
      switch (_colorTheme) {
        case ColorTheme.neutral:
          return const Color(0xFF0A0F0A); // Veľmi tmavá s jemným zeleným nádychom
        case ColorTheme.girl:
          return const Color(0xFF0F0A0D); // Veľmi tmavá s jemným ružovým nádychom
        case ColorTheme.boy:
          return const Color(0xFF0A0C0F); // Veľmi tmavá s jemným modrým nádychom
      }
    } else {
      // Svetlý režim - jemné pastelové pozadie
      switch (_colorTheme) {
        case ColorTheme.neutral:
          return const Color(0xFFF0F9F0); // Veľmi svetlá zelená
        case ColorTheme.girl:
          return const Color(0xFFFFF0F5); // Veľmi svetlá ružová (lavender blush)
        case ColorTheme.boy:
          return const Color(0xFFF0F5FF); // Veľmi svetlá modrá (alice blue)
      }
    }
  }

  /// Získa farbu karty
  Color getCardColor(BuildContext context) {
    if (isDarkMode) {
      // Tmavý režim - trochu svetlejšie ako pozadie
      switch (_colorTheme) {
        case ColorTheme.neutral:
          return const Color(0xFF1C1C1C);
        case ColorTheme.girl:
          return const Color(0xFF1C1818); // Jemný ružový nádych
        case ColorTheme.boy:
          return const Color(0xFF18181C); // Jemný modrý nádych
      }
    } else {
      // Svetlý režim - biela s jemným farebným nádychom
      switch (_colorTheme) {
        case ColorTheme.neutral:
          return const Color(0xFFFFFFFF);
        case ColorTheme.girl:
          return const Color(0xFFFFFAFC); // Takmer biela s ružovým nádychom
        case ColorTheme.boy:
          return const Color(0xFFFAFCFF); // Takmer biela s modrým nádychom
      }
    }
  }

  /// Získa farbu textu
  Color getTextColor(BuildContext context) {
    return isDarkMode 
        ? CupertinoColors.white 
        : CupertinoColors.black;
  }

  /// Získa sekundárnu farbu textu
  Color getSecondaryTextColor(BuildContext context) {
    return CupertinoColors.systemGrey;
  }

  /// Získa svetlú akcentovú farbu podľa témy (pre pozadia)
  Color getAccentColorLight() {
    switch (_colorTheme) {
      case ColorTheme.neutral:
        return CupertinoColors.systemGreen.withOpacity(0.15);
      case ColorTheme.girl:
        return CupertinoColors.systemPink.withOpacity(0.15);
      case ColorTheme.boy:
        return CupertinoColors.systemBlue.withOpacity(0.15);
    }
  }
}
