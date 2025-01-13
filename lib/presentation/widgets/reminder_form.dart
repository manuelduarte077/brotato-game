import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/reminder.dart';

class ReminderForm extends StatefulWidget {
  final Reminder? initialReminder;
  final void Function(
    String title,
    double amount,
    DateTime dueDate,
    String category,
    String? description,
    bool isRecurring,
    String? recurrenceType,
    int? recurrenceInterval,
  ) onSubmit;

  const ReminderForm({
    super.key,
    this.initialReminder,
    required this.onSubmit,
  });

  @override
  State<ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;
  late String _selectedCategory;
  late bool _isRecurring;
  String? _recurrenceType;
  int? _recurrenceInterval;

  final List<String> _categories = ['Bills', 'Rent', 'Utilities', 'Other'];
  final List<String> _recurrenceTypes = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly'
  ];

  @override
  void initState() {
    super.initState();
    final reminder = widget.initialReminder;

    _titleController = TextEditingController(text: reminder?.title);
    _descriptionController = TextEditingController(text: reminder?.description);
    _amountController = TextEditingController(
      text: reminder?.amount.toString() ?? '',
    );
    _selectedDate = reminder?.dueDate ?? DateTime.now();
    _selectedCategory = reminder?.category ?? _categories.first;
    _isRecurring = reminder?.isRecurring ?? false;
    _recurrenceType = reminder?.recurrenceType;
    _recurrenceInterval = reminder?.recurrenceInterval;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  String _getHelperText(String? type, int? interval) {
    if (type == null || interval == null) return '';

    switch (type) {
      case 'Daily':
        return 'Se repetirá cada $interval día(s)';
      case 'Weekly':
        return 'Se repetirá cada $interval semana(s)';
      case 'Monthly':
        return 'Se repetirá cada $interval mes(es)';
      case 'Yearly':
        return 'Se repetirá cada $interval año(s)';
      default:
        return '';
    }
  }

  String _getSuffixText(String? type) {
    switch (type) {
      case 'Daily':
        return 'días';
      case 'Weekly':
        return 'semanas';
      case 'Monthly':
        return 'meses';
      case 'Yearly':
        return 'años';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    ///
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Que pago quieres recordar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
              prefixText: '\$',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedCategory = value);
              }
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Due Date'),
            subtitle: Text(
              '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
              );
              if (date != null) {
                setState(() => _selectedDate = date);
              }
            },
          ),
          SwitchListTile(
            title: const Text('Recurring Payment'),
            value: _isRecurring,
            onChanged: (value) {
              setState(() => _isRecurring = value);
            },
          ),
          if (_isRecurring) ...[
            DropdownButtonFormField<String>(
              value: _recurrenceType,
              decoration: const InputDecoration(
                labelText: 'Recurrence Type',
                border: OutlineInputBorder(),
              ),
              items: _recurrenceTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _recurrenceType = value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _recurrenceInterval?.toString(),
              decoration: InputDecoration(
                labelText: 'Intervalo de Repetición',
                border: OutlineInputBorder(),
                helperText:
                    _getHelperText(_recurrenceType, _recurrenceInterval),
                prefixIcon: Icon(Icons.repeat),
                suffixText: _getSuffixText(_recurrenceType),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                setState(() {
                  _recurrenceInterval = int.tryParse(value);
                });
              },
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit(
                  _titleController.text,
                  double.parse(_amountController.text),
                  _selectedDate,
                  _selectedCategory,
                  _descriptionController.text.isEmpty
                      ? null
                      : _descriptionController.text,
                  _isRecurring,
                  _isRecurring ? _recurrenceType : null,
                  _isRecurring ? _recurrenceInterval : null,
                );
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
