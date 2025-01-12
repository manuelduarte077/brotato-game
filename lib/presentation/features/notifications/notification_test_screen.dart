import 'package:flutter/material.dart';
import '../../../domain/models/reminder.dart';
import '../../../infrastructure/services/notification_service.dart';

class NotificationTestScreen extends StatelessWidget {
  NotificationTestScreen({super.key});

  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Notifications'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final reminder = Reminder(
                  id: 1,
                  title: 'Test Notification',
                  amount: 100.0,
                  dueDate: DateTime.now().add(const Duration(seconds: 5)),
                  category: 'Test',
                );

                try {
                  await _notificationService
                      .scheduleReminderNotification(reminder);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Notification scheduled for 5 seconds from now')),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Error scheduling notification: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Schedule Test Notification (5 seconds)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final pendingNotifications =
                      await _notificationService.getPendingReminders();
                  if (!context.mounted) return;

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Pending Notifications'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: pendingNotifications
                              .map((notification) => ListTile(
                                    title: Text(notification.title),
                                    subtitle: Text(notification.body),
                                  ))
                              .toList(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Error fetching notifications: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Show Pending Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}
