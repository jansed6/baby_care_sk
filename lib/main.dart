import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializuj notifikačný servis
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Načítaj nastavenia a naplánuj notifikácie ak sú zapnuté
  final settingsService = SettingsService();
  final notificationEnabled = await settingsService.getVitaminDNotificationEnabled();
  if (notificationEnabled) {
    final notificationTime = await settingsService.getVitaminDNotificationTime();
    final timeParts = notificationTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    await notificationService.scheduleDailyVitaminDReminder(hour, minute);
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const BabyCareApp(),
    ),
  );
}

/// Hlavná aplikácia s iOS štýlom
class BabyCareApp extends StatelessWidget {
  const BabyCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return CupertinoApp(
          title: 'BabyCare SK',
          theme: CupertinoThemeData(
            primaryColor: themeProvider.getPrimaryColor(),
            brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
          ),
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
