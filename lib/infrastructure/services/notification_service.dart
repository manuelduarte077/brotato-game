import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../domain/models/reminder.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  static const _channelId = 'reminders_channel';
  static const _channelName = 'Reminders';
  static const _channelDescription = 'Payment reminder notifications';
  static const _recurringIdOffset = 1000;

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

  Future<bool> isNotificationScheduled(int id) async {
    final pendingNotifications =
        await _notifications.pendingNotificationRequests();
    return pendingNotifications.any((notification) => notification.id == id);
  }

  Future<void> scheduleReminderNotification(Reminder reminder) async {
    try {
      // Validación de datos de entrada
      if (reminder.title.isEmpty) {
        throw Exception('Reminder title cannot be empty');
      }
      if (reminder.amount <= 0) {
        throw Exception('Reminder amount must be greater than 0');
      }
      if (reminder.dueDate.isBefore(DateTime.now())) {
        throw Exception('Due date must be in the future');
      }

      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        throw Exception('Notification permissions not granted');
      }

      final baseId = reminder.id ??
          (DateTime.now().millisecondsSinceEpoch % 100000).toInt();

      final androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(''),
      );

      debugPrint('Scheduling notification for reminder: ${reminder.title}');

      await _notifications.zonedSchedule(
        baseId,
        'Payment Reminder: ${reminder.title}',
        'Amount: \$${reminder.amount} due today',
        tz.TZDateTime.from(reminder.dueDate, tz.local),
        NotificationDetails(
          android: androidDetails,
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      if (reminder.isRecurring && reminder.recurrenceType != null) {
        // Schedule next recurring notification
        final nextDate = _calculateNextRecurrence(
          reminder.dueDate,
          reminder.recurrenceType!,
          reminder.recurrenceInterval ?? 1,
        );

        await _notifications.zonedSchedule(
          baseId + _recurringIdOffset,
          'Payment Reminder: ${reminder.title}',
          'Amount: \$${reminder.amount} due today',
          tz.TZDateTime.from(nextDate, tz.local),
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              _channelName,
              channelDescription: _channelDescription,
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
      throw Exception('Failed to schedule notification: $e');
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

  Future<List<PendingReminderNotification>> getPendingReminders() async {
    final pendingNotifications =
        await _notifications.pendingNotificationRequests();
    return pendingNotifications
        .where((notification) => notification.id < _recurringIdOffset)
        .map((notification) => PendingReminderNotification(
              id: notification.id,
              title: notification.title ?? '',
              body: notification.body ?? '',
            ))
        .toList();
  }

  Future<void> cancelAllNotifications() async {
    debugPrint('Cancelling all notifications');
    await _notifications.cancelAll();
  }

  Future<bool> requestPermissions() async {
    final android = await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    final ios = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    return (android ?? false) || (ios ?? false);
  }
}

// Clase auxiliar para manejar notificaciones pendientes
class PendingReminderNotification {
  final int id;
  final String title;
  final String body;

  PendingReminderNotification({
    required this.id,
    required this.title,
    required this.body,
  });
}
