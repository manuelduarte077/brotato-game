import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/filter_providers.dart';
import '../widgets/reminder_card.dart';
import 'create_reminder_screen.dart';

class ReminderListScreen extends ConsumerWidget {
  const ReminderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredReminders = ref.watch(filteredRemindersProvider);
    final filterState = ref.watch(filterStateProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SearchBar(
              elevation: WidgetStateProperty.all(0),
              side: WidgetStateProperty.all(
                BorderSide(color: Colors.black),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              hintText: 'Search reminders...',
              onChanged: (query) {
                ref.read(filterStateProvider.notifier).state =
                    filterState.copyWith(searchQuery: query);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredReminders.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final reminder = filteredReminders[index];
                return ReminderCard(reminder: reminder);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateReminderScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
