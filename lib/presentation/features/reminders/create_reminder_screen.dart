import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/reminder_providers.dart';
import '../../widgets/reminder_form.dart';

class CreateReminderScreen extends ConsumerWidget {
  const CreateReminderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Reminder'),
      ),
      body: ReminderForm(
        onSubmit: (title, amount, dueDate, category, description, isRecurring,
            recurrenceType, recurrenceInterval) {
          ref.read(reminderControllerProvider).createReminder(
                title: title,
                amount: amount,
                dueDate: dueDate,
                category: category,
                description: description,
                isRecurring: isRecurring,
                recurrenceType: recurrenceType,
                recurrenceInterval: recurrenceInterval,
              );
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
