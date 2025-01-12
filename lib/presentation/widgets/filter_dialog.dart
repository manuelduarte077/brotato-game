import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/filter_providers.dart';

class FilterDialog extends ConsumerWidget {
  const FilterDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterStateProvider);
    final platform = Theme.of(context).platform;

    // Retornar diálogo específico según plataforma
    return platform == TargetPlatform.iOS
        ? _buildCupertinoDialog(context, ref, filterState)
        : _buildMaterialDialog(context, ref, filterState);
  }

  Widget _buildMaterialDialog(
      BuildContext context, WidgetRef ref, FilterState filterState) {
    return AlertDialog.adaptive(
      title: const Text('Filter Reminders',
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text('Date Range'),
                subtitle: Text(
                  filterState.startDate != null && filterState.endDate != null
                      ? '${filterState.startDate!.toString().split(' ')[0]} to ${filterState.endDate!.toString().split(' ')[0]}'
                      : 'No date range selected',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
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
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<ReminderSortType>(
                  decoration: InputDecoration(
                    labelText: 'Sort By',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.sort),
                  ),
                  value: filterState.sortType,
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
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.swap_vert),
                title: const Text('Ascending Order'),
                subtitle: Text(
                  filterState.sortAscending ? 'Oldest first' : 'Newest first',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                value: filterState.sortAscending,
                onChanged: (value) {
                  ref.read(filterStateProvider.notifier).state =
                      filterState.copyWith(sortAscending: value);
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            ref.read(filterStateProvider.notifier).state = FilterState();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Reset'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.check),
          label: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildCupertinoDialog(
      BuildContext context, WidgetRef ref, FilterState filterState) {
    return CupertinoAlertDialog(
      title: const Text('Filter Reminders'),
      content: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            _buildCupertinoSection(
              icon: CupertinoIcons.calendar,
              title: 'Date Range',
              subtitle: filterState.startDate != null &&
                      filterState.endDate != null
                  ? '${filterState.startDate!.toString().split(' ')[0]} to ${filterState.endDate!.toString().split(' ')[0]}'
                  : 'Select dates',
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
            const SizedBox(height: 16),
            _buildCupertinoSection(
              icon: CupertinoIcons.sort_down,
              title: 'Sort By',
              subtitle: filterState.sortType.name,
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    actions: ReminderSortType.values
                        .map(
                          (type) => CupertinoActionSheetAction(
                            onPressed: () {
                              ref.read(filterStateProvider.notifier).state =
                                  filterState.copyWith(sortType: type);
                              Navigator.pop(context);
                            },
                            child: Text(type.name),
                          ),
                        )
                        .toList(),
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () => Navigator.pop(context),
                      isDestructiveAction: true,
                      child: const Text('Cancel'),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(CupertinoIcons.arrow_up_arrow_down,
                        color: CupertinoColors.systemGrey),
                    const SizedBox(width: 8),
                    const Text('Ascending Order'),
                  ],
                ),
                CupertinoSwitch(
                  value: filterState.sortAscending,
                  onChanged: (value) {
                    ref.read(filterStateProvider.notifier).state =
                        filterState.copyWith(sortAscending: value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            ref.read(filterStateProvider.notifier).state = FilterState();
            Navigator.pop(context);
          },
          isDestructiveAction: true,
          child: const Text('Reset'),
        ),
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildCupertinoSection({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Row(
        children: [
          Icon(icon, color: CupertinoColors.systemGrey),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(
                subtitle,
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
