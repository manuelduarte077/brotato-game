import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/models/reminder.dart';

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
      ),
    );
  }
}
