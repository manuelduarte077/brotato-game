import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../application/providers/notification_providers.dart';
import '../../domain/models/reminder.dart';
import 'package:riverpod/riverpod.dart';
import 'dart:convert';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final _notifications = FlutterLocalNotificationsPlugin();
  final _container = ProviderContainer();

  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  void _onNotificationTapped(NotificationResponse details) {
    if (details.payload != null) {
      try {
        final payloadData = Map<String, dynamic>.from(
          json.decode(details.payload!) as Map,
        );
        final notification = NotificationRecord(
          id: payloadData['id'] as int,
          title: payloadData['title'] as String,
          body: payloadData['body'] as String,
          timestamp: DateTime.parse(payloadData['timestamp'] as String),
        );

        _container
            .read(notificationHistoryProvider.notifier)
            .addNotification(notification);
      } catch (e) {
        debugPrint('Error processing notification payload: $e');
      }
    }
  }

  Future<void> scheduleReminderNotification(Reminder reminder) async {
    if (reminder.dueDate.isBefore(DateTime.now())) {
      debugPrint('No se programa notificación para fecha pasada');
      return;
    }

    await _scheduleNotification(
      reminder,
      reminder.dueDate,
      notificationType: 'due',
    );

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
    final adjustedId =
        notificationType == 'due' ? notificationId : notificationId + 1000;

    final String message = notificationType == 'due'
        ? 'Pago vence hoy: \$${reminder.amount}'
        : 'Pago vence mañana: \$${reminder.amount}';

    final payload = json.encode({
      'id': adjustedId,
      'title': reminder.title,
      'body': message,
      'timestamp': scheduledDate.toIso8601String(),
      'reminderId': reminder.id,
    });

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'reminders_channel',
        'Recordatorios de Pago',
        channelDescription: 'Notificaciones de recordatorios de pago',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        interruptionLevel: InterruptionLevel.active,
      ),
    );

    try {
      await _notifications.zonedSchedule(
        adjustedId,
        reminder.title,
        message,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );

      // Guardar en el historial
      final notification = NotificationRecord(
        id: adjustedId,
        title: reminder.title,
        body: message,
        timestamp: scheduledDate,
      );

      _container
          .read(notificationHistoryProvider.notifier)
          .addNotification(notification);

      debugPrint('Notificación programada para ${scheduledDate.toString()}');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
      rethrow;
    }
  }

  Future<void> cancelReminderNotifications(int reminderId) async {
    await _notifications.cancel(reminderId);
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
