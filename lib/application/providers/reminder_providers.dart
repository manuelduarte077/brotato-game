import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../infrastructure/repositories/drift_reminder_repository.dart';
import '../database_provider.dart';
import '../../domain/models/reminder.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return DriftReminderRepository(database);
});

final remindersStreamProvider = StreamProvider<List<Reminder>>((ref) {
  final repository = ref.watch(reminderRepositoryProvider);
  return repository.watchReminders();
});

final reminderControllerProvider = Provider((ref) {
  final repository = ref.watch(reminderRepositoryProvider);
  return ReminderController(repository);
});

class ReminderController {
  final ReminderRepository _repository;

  ReminderController(this._repository);

  Future<void> createReminder({
    required String title,
    required double amount,
    required DateTime dueDate,
    required String category,
    String? description,
    bool isRecurring = false,
    String? recurrenceType,
    int? recurrenceInterval,
  }) async {
    final reminder = Reminder(
      title: title,
      amount: amount,
      dueDate: dueDate,
      category: category,
      description: description,
      isRecurring: isRecurring,
      recurrenceType: recurrenceType,
      recurrenceInterval: recurrenceInterval,
    );

    try {
      await _repository.createReminder(reminder);
    } catch (e) {
      throw Exception('Error creating reminder: $e');
    }
  }

  Future<void> updateReminder(Reminder reminder) async {
    try {
      await _repository.updateReminder(reminder);
    } catch (e) {
      throw Exception('Error updating reminder: $e');
    }
  }

  Future<void> deleteReminder(int id) async {
    try {
      await _repository.deleteReminder(id);
    } catch (e) {
      throw Exception('Error deleting reminder: $e');
    }
  }
}
