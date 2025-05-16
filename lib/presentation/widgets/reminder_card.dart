import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/models/reminder.dart';
import '../features/reminders/show_reminder_screen.dart';

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
        onTap: () {
          showModalBottomSheet(
            context: context,
            scrollControlDisabledMaxHeightRatio: 0.9,
            showDragHandle: true,
            builder: (context) => ShowReminderScreen(reminder: reminder),
          );
        },
        title: Row(
          children: [
            Expanded(
              child: Text(
                reminder.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (reminder.description != null)
              Text(
                reminder.description ?? '',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
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
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
