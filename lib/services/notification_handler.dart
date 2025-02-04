import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationHandler {
  // Private constructor
  NotificationHandler._privateConstructor();

  // Singleton instance
  static final NotificationHandler _instance =
      NotificationHandler._privateConstructor();

  // Factory constructor to return the same instance
  factory NotificationHandler() {
    return _instance;
  }
  FlutterLocalNotificationsPlugin? _notificationsPlugin;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }


    // Check the status again after requesting
    status = await Permission.notification.status;
    if (status.isGranted) {
      _notificationsPlugin = FlutterLocalNotificationsPlugin();
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await _notificationsPlugin!.initialize(initializationSettings);
    }
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "daily_channel_id",
        "Daily Notification",
        channelDescription: "Daily Notification Channel",
        importance: Importance.max,
        priority: Priority.max,
      ),
    );
  }

  // Method to show notification
  Future<void> showNotification(String title, String message, int id) async {
    if (_notificationsPlugin == null) {
      await init();
      return;
    }
    return _notificationsPlugin!
        .show(id, title, message, notificationDetails());
  }
}
