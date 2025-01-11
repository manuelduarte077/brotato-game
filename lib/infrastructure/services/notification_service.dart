import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../domain/models/reminder.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  Future<void> scheduleReminderNotification(Reminder reminder) async {
    final id = reminder.id ?? DateTime.now().millisecondsSinceEpoch;

    await _notifications.zonedSchedule(
      id,
      'Payment Reminder: ${reminder.title}',
      'Amount: \$${reminder.amount} due today',
      tz.TZDateTime.from(reminder.dueDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders_channel',
          'Reminders',
          channelDescription: 'Payment reminder notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    if (reminder.isRecurring && reminder.recurrenceType != null) {
      // Schedule next recurring notification
      final nextDate = _calculateNextRecurrence(
        reminder.dueDate,
        reminder.recurrenceType!,
        reminder.recurrenceInterval ?? 1,
      );

      await _notifications.zonedSchedule(
        id + 1,
        'Payment Reminder: ${reminder.title}',
        'Amount: \$${reminder.amount} due today',
        tz.TZDateTime.from(nextDate, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'reminders_channel',
            'Reminders',
            channelDescription: 'Payment reminder notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  DateTime _calculateNextRecurrence(
    DateTime current,
    String recurrenceType,
    int interval,
  ) {
    switch (recurrenceType.toLowerCase()) {
      case 'daily':
        return current.add(Duration(days: interval));
      case 'weekly':
        return current.add(Duration(days: 7 * interval));
      case 'monthly':
        return DateTime(
          current.year,
          current.month + interval,
          current.day,
        );
      case 'yearly':
        return DateTime(
          current.year + interval,
          current.month,
          current.day,
        );
      default:
        return current;
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}
