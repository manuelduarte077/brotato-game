import 'package:flutter/material.dart';
import 'package:pay_reminder/i18n/translations.g.dart';
import '../../domain/models/reminder.dart';

class ShowReminderForm extends StatelessWidget {
  final Reminder reminder;

  const ShowReminderForm({
    super.key,
    required this.reminder,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts.app.home;
    final showReminder = context.texts.app.reminders;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          texts.paymentDetails,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        _buildInfoField(showReminder.title, reminder.title),
        const SizedBox(height: 16),
        _buildInfoField(showReminder.description, reminder.description ?? '',
            maxLines: 3),
        const SizedBox(height: 16),
        _buildInfoField(showReminder.amount, '\$${reminder.amount}'),
        const SizedBox(height: 16),
        _buildInfoField(showReminder.category, reminder.category),
        const SizedBox(height: 16),
        _buildInfoField(showReminder.dueDate,
            '${reminder.dueDate.year}-${reminder.dueDate.month}-${reminder.dueDate.day}'),
        const SizedBox(height: 16),
        _buildInfoField(
            showReminder.recurringPayment, reminder.isRecurring ? 'Yes' : 'No'),
        if (reminder.isRecurring) ...[
          const SizedBox(height: 16),
          _buildInfoField(
              showReminder.recurrenceType, reminder.recurrenceType ?? ''),
          const SizedBox(height: 16),
          _buildInfoField(showReminder.recurrenceInterval,
              reminder.recurrenceInterval?.toString() ?? ''),
        ],
      ],
    );
  }

  Widget _buildInfoField(String label, String value, {int maxLines = 1}) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xFFEEEEEE),
      ),
      child: Text(value, maxLines: maxLines),
    );
  }
}
