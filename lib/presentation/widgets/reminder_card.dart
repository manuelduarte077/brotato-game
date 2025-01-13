import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/models/reminder.dart';
import '../features/reminders/edit_reminder_screen.dart';
import '../../application/providers/reminder_providers.dart';

class ReminderCard extends ConsumerWidget {
  final Reminder reminder;

  const ReminderCard({
    super.key,
    required this.reminder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Card(
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                reminder.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (reminder.isSynced)
              const Icon(Icons.cloud_done, size: 16, color: Colors.green)
            else
              const Icon(Icons.cloud_off, size: 16, color: Colors.grey),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (reminder.description != null) Text(reminder.description!),
            Text(
              'Due: ${DateFormat.yMMMd().format(reminder.dueDate)}',
              style: TextStyle(
                color: reminder.dueDate.isBefore(DateTime.now())
                    ? Colors.red
                    : null,
              ),
            ),
            Text(
              'Amount: ${currencyFormat.format(reminder.amount)}',
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  scrollControlDisabledMaxHeightRatio: 0.9,
                  builder: (builder) {
                    return EditReminderScreen(reminder: reminder);
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      'Delete Reminder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: const Text('Are you sure?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(reminderControllerProvider)
                              .deleteReminder(reminder.id!);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
