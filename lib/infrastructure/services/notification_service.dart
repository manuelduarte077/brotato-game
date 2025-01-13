import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
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
    if (reminder.dueDate.isBefore(DateTime.now())) {
      debugPrint('No se programa notificación para fecha pasada');
      return;
    }

    // Programar notificación para el día del vencimiento
    await _scheduleNotification(
      reminder,
      reminder.dueDate,
      notificationType: 'due',
    );

    // Programar notificación 1 día antes
    final oneDayBefore = reminder.dueDate.subtract(const Duration(days: 1));
    if (oneDayBefore.isAfter(DateTime.now())) {
      await _scheduleNotification(
        reminder,
        oneDayBefore,
        notificationType: 'day_before',
      );
    }
  }

  Future<void> _scheduleNotification(
    Reminder reminder,
    DateTime scheduledDate, {
    required String notificationType,
  }) async {
    final int notificationId =
        reminder.id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000);

    // Ajustar ID para diferenciar entre tipos de notificación
    final adjustedId =
        notificationType == 'due' ? notificationId : notificationId + 1000;

    final String message = notificationType == 'due'
        ? 'Pago vence hoy: \$${reminder.amount}'
        : 'Pago vence mañana: \$${reminder.amount}';

    final androidDetails = AndroidNotificationDetails(
      'reminders_channel',
      'Recordatorios de Pago',
      channelDescription: 'Notificaciones de recordatorios de pago',
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notifications.zonedSchedule(
      adjustedId,
      reminder.title,
      message,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint('Notificación programada para ${scheduledDate.toString()}');
  }

  Future<void> cancelReminderNotifications(int reminderId) async {
    // Cancelar notificación del día de vencimiento
    await _notifications.cancel(reminderId);
    // Cancelar notificación del día anterior
    await _notifications.cancel(reminderId + 1000);
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
