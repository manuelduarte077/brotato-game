import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/reminder_providers.dart';
import '../../widgets/reminder_form.dart';

class CreateReminderScreen extends ConsumerWidget {
  const CreateReminderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBottomSheet = ModalRoute.of(context)?.settings.name == null;
    print('isBottomSheet: $isBottomSheet');

    return Scaffold(
      appBar: isBottomSheet
          ? null
          : AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
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
