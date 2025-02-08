import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pay_reminder/i18n/translations.g.dart';
import '../../../application/providers/filter_providers.dart';
import '../../widgets/filter_dialog.dart';
import 'create_reminder_screen.dart';
import '../../widgets/reminder_slidable.dart';

class ReminderListScreen extends ConsumerWidget {
  const ReminderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredReminders = ref.watch(filteredRemindersProvider);
    final filterState = ref.watch(filterStateProvider);
    final texts = context.texts.app.home;

    return CustomScrollView(
      slivers: [
        SliverAppBar.medium(
          pinned: true,
          title: Text(
            texts.reminders,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          floating: true,
          actions: [
            IconButton(
              icon: const Icon(
                CupertinoIcons.add_circled_solid,
                size: 32,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  scrollControlDisabledMaxHeightRatio: 0.9,
                  builder: (context) {
                    return const CreateReminderScreen();
                  },
                );
              },
            ),
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: EdgeInsets.all(8),
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
                  hintText: texts.search,
                  onChanged: (query) {
                    ref.read(filterStateProvider.notifier).state =
                        filterState.copyWith(searchQuery: query);
                  },
                  trailing: [
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        showAdaptiveDialog(
                          context: context,
                          builder: (context) => FilterDialog(),
                        );
                      },
                    ),
                  ],
                ),
              ),

              /// Reminders list
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredReminders.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final reminder = filteredReminders[index];

                  return ReminderSlidable(reminder: reminder);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
