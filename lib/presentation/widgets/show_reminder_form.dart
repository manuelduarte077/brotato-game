import 'package:flutter/material.dart';
import '../../domain/models/reminder.dart';

class ShowReminderForm extends StatelessWidget {
  final Reminder reminder;

  const ShowReminderForm({
    super.key,
    required this.reminder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Detalles del Pago',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        _buildInfoField('Title', reminder.title),
        const SizedBox(height: 16),
        _buildInfoField('Description', reminder.description ?? '', maxLines: 3),
        const SizedBox(height: 16),
        _buildInfoField('Amount', '\$${reminder.amount}'),
        const SizedBox(height: 16),
        _buildInfoField('Category', reminder.category),
        const SizedBox(height: 16),
        _buildInfoField('Due Date',
            '${reminder.dueDate.year}-${reminder.dueDate.month}-${reminder.dueDate.day}'),
        const SizedBox(height: 16),
        _buildInfoField(
            'Recurring Payment', reminder.isRecurring ? 'Yes' : 'No'),
        if (reminder.isRecurring) ...[
          const SizedBox(height: 16),
          _buildInfoField('Recurrence Type', reminder.recurrenceType ?? ''),
          const SizedBox(height: 16),
          _buildInfoField('Recurrence Interval',
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
