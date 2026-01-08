import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// Service pre správu lokálnych notifikácií
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Inicializácia notifikačného servisu
  Future<void> initialize() async {
    // Inicializuj timezone databázu
    tz.initializeTimeZones();
    
    // Android nastavenia
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS nastavenia
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);

    // Požiadaj o povolenia pre iOS
    await _requestPermissions();
  }

  /// Požiadaj o povolenia pre notifikácie
  Future<void> _requestPermissions() async {
    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  /// Naplánuj dennú pripomienku na vitamín D
  Future<void> scheduleDailyVitaminDReminder(int hour, int minute) async {
    // Zruš existujúcu pripomienku
    await cancelVitaminDReminder();

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Ak je čas už prešiel dnes, naplánuj na zajtra
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      0, // ID notifikácie
      'Vitamín D',
      'Nezabudni dať dieťaťu vitamín D!',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'vitamin_d_channel',
          'Vitamín D pripomienky',
          channelDescription: 'Denné pripomienky na podanie vitamínu D',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Opakuj každý deň
    );
  }

  /// Zruš pripomienku na vitamín D
  Future<void> cancelVitaminDReminder() async {
    await _notifications.cancel(0);
  }
}
