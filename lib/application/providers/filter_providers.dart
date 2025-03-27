import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pay_reminder/application/providers/reminder_providers.dart';
import 'package:pay_reminder/domain/models/reminder.dart';

enum ReminderSortType {
  dueDate,
  amount,
  title,
}

class FilterState {
  final String? searchQuery;
  final Set<String> selectedCategories;
  final DateTime? startDate;
  final DateTime? endDate;
  final ReminderSortType sortType;
  final bool sortAscending;

  FilterState({
    this.searchQuery,
    Set<String>? selectedCategories,
    this.startDate,
    this.endDate,
    this.sortType = ReminderSortType.dueDate,
    this.sortAscending = true,
  }) : selectedCategories = selectedCategories ?? {};

  FilterState copyWith({
    String? searchQuery,
    Set<String>? selectedCategories,
    DateTime? startDate,
    DateTime? endDate,
    ReminderSortType? sortType,
    bool? sortAscending,
  }) {
    return FilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortType: sortType ?? this.sortType,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }
}

final filterStateProvider = StateProvider<FilterState>((ref) {
  return FilterState();
});

final filteredRemindersProvider = Provider<List<Reminder>>((ref) {
  final reminders = ref.watch(remindersStreamProvider).value ?? [];
  final filterState = ref.watch(filterStateProvider);

  return reminders.where((reminder) {
    if (filterState.searchQuery != null &&
        filterState.searchQuery!.isNotEmpty) {
      final query = filterState.searchQuery!.toLowerCase();

      if (!reminder.title.toLowerCase().contains(query) &&
          !(reminder.description?.toLowerCase().contains(query) ?? false)) {
        return false;
      }
    }

    // Apply category filter
    if (filterState.selectedCategories.isNotEmpty &&
        !filterState.selectedCategories.contains(reminder.category)) {
      return false;
    }

    // Apply date range filter
    if (filterState.startDate != null &&
        reminder.dueDate.isBefore(filterState.startDate!)) {
      return false;
    }
    if (filterState.endDate != null &&
        reminder.dueDate.isAfter(filterState.endDate!)) {
      return false;
    }

    return true;
  }).toList()
    ..sort((a, b) {
      int comparison;
      switch (filterState.sortType) {
        case ReminderSortType.dueDate:
          comparison = a.dueDate.compareTo(b.dueDate);
          break;
        case ReminderSortType.amount:
          comparison = a.amount.compareTo(b.amount);
          break;
        case ReminderSortType.title:
          comparison = a.title.compareTo(b.title);
          break;
      }

      return filterState.sortAscending ? comparison : -comparison;
    });
});
