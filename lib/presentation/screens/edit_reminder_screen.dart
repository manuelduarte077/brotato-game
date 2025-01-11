import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/reminder.dart';
import '../../application/providers/reminder_providers.dart';
import '../widgets/reminder_form.dart';

class EditReminderScreen extends ConsumerWidget {
  final Reminder reminder;

  const EditReminderScreen({
    super.key,
    required this.reminder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Reminder'),
      ),
      body: ReminderForm(
        initialReminder: reminder,
        onSubmit: (title, amount, dueDate, category, description, isRecurring,
            recurrenceType, recurrenceInterval) {
          final updatedReminder = reminder.copyWith(
            title: title,
            amount: amount,
            dueDate: dueDate,
            category: category,
            description: description,
            isRecurring: isRecurring,
            recurrenceType: recurrenceType,
            recurrenceInterval: recurrenceInterval,
          );

          ref.read(reminderControllerProvider).updateReminder(updatedReminder);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
