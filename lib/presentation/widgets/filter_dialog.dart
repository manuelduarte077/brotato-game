import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/filter_providers.dart';

class FilterDialog extends ConsumerWidget {
  const FilterDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterStateProvider);

    return AlertDialog(
      title: const Text('Filter Reminders'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date Range Selection
            ListTile(
              title: const Text('Date Range'),
              subtitle: Text(
                filterState.startDate != null && filterState.endDate != null
                    ? '${filterState.startDate!.toString().split(' ')[0]} to ${filterState.endDate!.toString().split(' ')[0]}'
                    : 'No date range selected',
              ),
              onTap: () async {
                final DateTimeRange? dateRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  initialDateRange: filterState.startDate != null &&
                          filterState.endDate != null
                      ? DateTimeRange(
                          start: filterState.startDate!,
                          end: filterState.endDate!,
                        )
                      : null,
                );

                if (dateRange != null) {
                  ref.read(filterStateProvider.notifier).state =
                      filterState.copyWith(
                    startDate: dateRange.start,
                    endDate: dateRange.end,
                  );
                }
              },
            ),

            // Sort Type Selection
            DropdownButtonFormField<ReminderSortType>(
              value: filterState.sortType,
              decoration: const InputDecoration(labelText: 'Sort By'),
              items: ReminderSortType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(filterStateProvider.notifier).state =
                      filterState.copyWith(sortType: value);
                }
              },
            ),

            // Sort Direction
            SwitchListTile(
              title: const Text('Ascending Order'),
              value: filterState.sortAscending,
              onChanged: (value) {
                ref.read(filterStateProvider.notifier).state =
                    filterState.copyWith(sortAscending: value);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(filterStateProvider.notifier).state = FilterState();
            Navigator.pop(context);
          },
          child: const Text('Reset'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
