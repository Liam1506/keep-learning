import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize local notifications for iOS
  static Future<void> init() async {
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  /// Request notification permissions from Flutter (iOS only)
  static Future<void> requestPermission() async {
    final IOSFlutterLocalNotificationsPlugin? iosPlugin =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Show a simple local push notification
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    print(iosDetails.presentBanner);

    const NotificationDetails details = NotificationDetails(iOS: iosDetails);

    await _notificationsPlugin.show(0, title, body, details);
  }
}
