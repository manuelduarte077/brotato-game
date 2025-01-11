import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../application/providers/reminder_providers.dart';
import '../../domain/models/reminder.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final reminders = ref.watch(remindersStreamProvider);

    return reminders.when(
      data: (reminderList) {
        final events = _createEventsMap(reminderList);

        return Column(
          children: [
            TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                // Mostrar reminders del día seleccionado
                final dayReminders = events[DateTime(selectedDay.year,
                        selectedDay.month, selectedDay.day)] ??
                    [];
                if (dayReminders.isNotEmpty) {
                  _showRemindersDialog(context, dayReminders);
                }
              },
              eventLoader: (day) {
                return events[DateTime(day.year, day.month, day.day)] ?? [];
              },
              calendarStyle: const CalendarStyle(
                markersMaxCount: 3,
                markerDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: _RemindersList(reminders: reminderList),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  void _showRemindersDialog(BuildContext context, List<Reminder> reminders) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reminders for ${DateFormat('MMM d, yyyy').format(_selectedDay!)}',
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              return ListTile(
                title: Text(reminder.title),
                subtitle: Text(
                  'Amount: \$${reminder.amount.toStringAsFixed(2)}\n'
                  '${reminder.description ?? ""}',
                ),
                leading: const Icon(Icons.event_note),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<Reminder>> _createEventsMap(List<Reminder> reminders) {
    final events = <DateTime, List<Reminder>>{};

    for (final reminder in reminders) {
      final date = DateTime(
        reminder.dueDate.year,
        reminder.dueDate.month,
        reminder.dueDate.day,
      );

      if (events.containsKey(date)) {
        events[date]!.add(reminder);
      } else {
        events[date] = [reminder];
      }
    }

    return events;
  }
}

class _RemindersList extends StatelessWidget {
  final List<Reminder> reminders;

  const _RemindersList({required this.reminders});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final upcomingReminders = reminders
        .where((reminder) => reminder.dueDate.isAfter(today))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return ListView.builder(
      itemCount: upcomingReminders.length,
      itemBuilder: (context, index) {
        final reminder = upcomingReminders[index];
        return ListTile(
          title: Text(reminder.title),
          subtitle: Text(
            'Due: ${DateFormat('MMM d, yyyy').format(reminder.dueDate)}\n'
            'Amount: \$${reminder.amount.toStringAsFixed(2)}',
          ),
          leading: const Icon(Icons.event),
        );
      },
    );
  }
}
