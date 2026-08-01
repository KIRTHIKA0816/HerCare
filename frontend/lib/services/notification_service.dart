import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'hercare_channel',
      'HerCare Reminders',
      channelDescription: 'Period and symptom tracking reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(id, title, body, details);
  }

  // Example: call this to remind the user their period is expected soon
  static Future<void> schedulePeriodReminder() async {
    await showNotification(
      id: 1,
      title: 'HerCare Reminder',
      body: 'Your period is expected in 2 days. Get ready! 💗',
    );
  }
}
