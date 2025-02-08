import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pay_reminder/i18n/translations.g.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../application/providers/reminder_providers.dart';
import '../../../domain/models/reminder.dart';
import '../reminders/show_reminder_screen.dart';

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
    final texts = context.texts.app.calendar;

    return Material(
      child: CustomScrollView(
        slivers: [
          ///
          SliverAppBar(
            pinned: true,
            title: Text(
              texts.calendar,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            floating: true,
          ),

          ///
          SliverList(
            delegate: SliverChildListDelegate(
              [
                reminders.when(
                  data: (reminderList) {
                    final events = _createEventsMap(reminderList);

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TableCalendar(
                            firstDay: DateTime.now()
                                .subtract(const Duration(days: 365)),
                            lastDay:
                                DateTime.now().add(const Duration(days: 365)),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });

                              final dayReminders = events[DateTime(
                                      selectedDay.year,
                                      selectedDay.month,
                                      selectedDay.day)] ??
                                  [];
                              if (dayReminders.isNotEmpty) {
                                _showRemindersDialog(context, dayReminders);
                              }
                            },
                            eventLoader: (day) {
                              return events[
                                      DateTime(day.year, day.month, day.day)] ??
                                  [];
                            },
                            calendarStyle: CalendarStyle(
                              markerSize: 8,
                              markersMaxCount: 4,
                              markerDecoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              weekendTextStyle:
                                  const TextStyle(color: Colors.red),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle:
                                  Theme.of(context).textTheme.titleLarge!,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Text(
                                texts.upcomingReminders,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                        _RemindersList(reminders: reminderList),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRemindersDialog(BuildContext context, List<Reminder> reminders) {
    final texts = context.texts.app.calendar;

    showAdaptiveDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${texts.remindersFor} ${DateFormat('MMM d, yyyy').format(_selectedDay!)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: reminders.length,
                separatorBuilder: (_, __) => const Divider(
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) {
                  final reminder = reminders[index];

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      reminder.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${texts.amount}: \$${reminder.amount.toStringAsFixed(2)}\n'
                      '${reminder.description ?? ""}',
                    ),
                    leading: Icon(
                      Icons.event_note,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(texts.close),
              ),
            ],
          ),
        ),
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
    final texts = context.texts.app.calendar;

    final today = DateTime.now();
    final upcomingReminders = reminders
        .where((reminder) => reminder.dueDate.isAfter(today))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: upcomingReminders.length,
      separatorBuilder: (_, __) => const Divider(color: Colors.grey),
      itemBuilder: (context, index) {
        final reminder = upcomingReminders[index];

        return Card(
          child: ListTile(
            onTap: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                scrollControlDisabledMaxHeightRatio: 0.9,
                builder: (builder) {
                  return ShowReminderScreen(reminder: reminder);
                },
              );
            },
            title: Text(
              reminder.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${texts.due}: ${DateFormat('MMM d, yyyy').format(reminder.dueDate)}\n'
              '${texts.amount}: \$${reminder.amount.toStringAsFixed(2)}',
            ),
            leading: Icon(
              Icons.event,
            ),
          ),
        );
      },
    );
  }
}
