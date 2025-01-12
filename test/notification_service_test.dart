import 'package:flutter_test/flutter_test.dart';
import 'package:pay_reminder/infrastructure/services/notification_service.dart';
import 'package:pay_reminder/domain/models/reminder.dart';

void main() {
  late NotificationService notificationService;

  setUp(() async {
    notificationService = NotificationService();
    await notificationService.init();
  });

  group('NotificationService Tests', () {
    test('should schedule a notification', () async {
      final reminder = Reminder(
        title: 'Test Reminder',
        amount: 100.0,
        dueDate: DateTime.now().add(const Duration(hours: 1)),
        category: 'Test',
      );

      // Act & Assert
      expect(
        () async =>
            await notificationService.scheduleReminderNotification(reminder),
        returnsNormally,
      );
    });

    test('should not schedule notification with empty title', () async {
      final reminder = Reminder(
        title: '',
        amount: 100.0,
        dueDate: DateTime.now().add(const Duration(hours: 1)),
        category: 'Test',
      );

      // Act & Assert
      expect(
        () => notificationService.scheduleReminderNotification(reminder),
        throwsException,
      );
    });

    test('should not schedule notification with past date', () async {
      final reminder = Reminder(
        title: 'Test',
        amount: 100.0,
        dueDate: DateTime.now().subtract(const Duration(hours: 1)),
        category: 'Test',
      );

      // Act & Assert
      expect(
        () => notificationService.scheduleReminderNotification(reminder),
        throwsException,
      );
    });
  });
}
