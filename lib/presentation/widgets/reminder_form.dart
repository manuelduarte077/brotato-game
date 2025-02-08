import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_reminder/i18n/translations.g.dart';
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

  final List<String> _categories = [
    'Alimentos y Supermercado',
    'Transporte y Gasolina',
    'Servicios Básicos',
    'Renta/Hipoteca',
    'Salud y Medicamentos',
    'Educación',
    'Entretenimiento',
    'Seguros',
    'Préstamos y Deudas',
    'Ahorro e Inversiones',
    'Ropa y Calzado',
    'Telecomunicaciones',
    'Mascotas',
    'Mantenimiento del Hogar',
    'Impuestos',
    'Suscripciones',
    'Regalos',
    'Otros',
  ];

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

    final texts = context.texts.app.reminders;

    switch (type) {
      case 'Daily':
        return 'Se repetirá cada $interval ${texts.days}';
      case 'Weekly':
        return 'Se repetirá cada $interval ${texts.weeks}';
      case 'Monthly':
        return 'Se repetirá cada $interval ${texts.months}';
      case 'Yearly':
        return 'Se repetirá cada $interval ${texts.years}';
      default:
        return '';
    }
  }

  String _getSuffixText(String? type) {
    final texts = context.texts.app.reminders;

    switch (type) {
      case 'Daily':
        return texts.days;
      case 'Weekly':
        return texts.weeks;
      case 'Monthly':
        return texts.months;
      case 'Yearly':
        return texts.years;
      default:
        return '';
    }
  }

  void _showCategoryBottomSheet() {
    final searchController = TextEditingController();
    List<String> filteredCategories = List.from(_categories);
    final texts = context.texts.app.reminders;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: texts.searchCategory,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      filteredCategories = _categories
                          .where((category) => category
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredCategories[index]),
                      selected: _selectedCategory == filteredCategories[index],
                      onTap: () {
                        setState(() =>
                            _selectedCategory = filteredCategories[index]);
                        Navigator.pop(context);
                        this.setState(() {});
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRecurrenceTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _recurrenceTypes.length,
                itemBuilder: (context, index) {
                  final type = _recurrenceTypes[index];
                  return ListTile(
                    leading: Icon(
                      _getRecurrenceIcon(type),
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(type),
                    subtitle: Text(_getRecurrenceDescription(type)),
                    selected: _recurrenceType == type,
                    onTap: () {
                      setState(() => _recurrenceType = type);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getRecurrenceIcon(String type) {
    switch (type) {
      case 'Daily':
        return Icons.calendar_view_day;
      case 'Weekly':
        return Icons.calendar_view_week;
      case 'Monthly':
        return Icons.calendar_view_month;
      case 'Yearly':
        return Icons.calendar_today;
      default:
        return Icons.repeat;
    }
  }

  String _getRecurrenceDescription(String type) {
    switch (type) {
      case 'Daily':
        return 'El recordatorio se repetirá diariamente';
      case 'Weekly':
        return 'El recordatorio se repetirá semanalmente';
      case 'Monthly':
        return 'El recordatorio se repetirá mensualmente';
      case 'Yearly':
        return 'El recordatorio se repetirá anualmente';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts.app.reminders;

    ///
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            texts.createReminder,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: texts.title,
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return texts.titleRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: texts.description,
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            decoration: InputDecoration(
              labelText: texts.amount,
              border: OutlineInputBorder(),
              prefixText: '\$',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return texts.amountRequired;
              }
              if (double.tryParse(value) == null) {
                return texts.amountInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: texts.category,
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            controller: TextEditingController(text: _selectedCategory),
            onTap: _showCategoryBottomSheet,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(texts.dueDate),
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
            title: Text(texts.recurringPayment),
            value: _isRecurring,
            onChanged: (value) {
              setState(() => _isRecurring = value);
            },
          ),
          if (_isRecurring) ...[
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: texts.recurrenceType,
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.arrow_drop_down),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              controller: TextEditingController(text: _recurrenceType),
              onTap: _showRecurrenceTypeBottomSheet,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _recurrenceInterval?.toString(),
              decoration: InputDecoration(
                labelText: texts.recurrenceInterval,
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
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
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
            child: Text(
              texts.save,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
