import 'package:drift/drift.dart';
import '../../domain/models/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../drift/database.dart';

class DriftReminderRepository implements ReminderRepository {
  final AppDatabase _db;

  DriftReminderRepository(this._db);

  Reminder _mapToModel(ReminderData data) {
    return Reminder(
      id: data.id,
      title: data.title,
      description: data.description,
      amount: data.amount,
      dueDate: data.dueDate,
      category: data.category,
      isRecurring: data.isRecurring,
      recurrenceType: data.recurrenceType,
      recurrenceInterval: data.recurrenceInterval,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  RemindersCompanion _mapToCompanion(Reminder reminder) {
    return RemindersCompanion(
      id: reminder.id == null ? const Value.absent() : Value(reminder.id!),
      title: Value(reminder.title),
      description: Value(reminder.description),
      amount: Value(reminder.amount),
      dueDate: Value(reminder.dueDate),
      category: Value(reminder.category),
      isRecurring: Value(reminder.isRecurring),
      recurrenceType: Value(reminder.recurrenceType),
      recurrenceInterval: Value(reminder.recurrenceInterval),
    );
  }

  @override
  Future<List<Reminder>> getAllReminders() async {
    final results = await _db.getAllReminders();
    return results.map(_mapToModel).toList();
  }

  @override
  Future<Reminder?> getReminder(int id) async {
    final result = await (_db.select(_db.reminders)
          ..where((r) => r.id.equals(id)))
        .getSingleOrNull();
    return result != null ? _mapToModel(result) : null;
  }

  @override
  Future<void> createReminder(Reminder reminder) async {
    await _db.into(_db.reminders).insert(_mapToCompanion(reminder));
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    await _db.updateReminder(_mapToCompanion(reminder));
  }

  @override
  Future<void> deleteReminder(int id) async {
    await _db.deleteReminder(id);
  }

  @override
  Stream<List<Reminder>> watchReminders() {
    return (_db.select(_db.reminders)
          ..orderBy([
            (r) => OrderingTerm(expression: r.dueDate),
          ]))
        .watch()
        .map((rows) => rows.map(_mapToModel).toList());
  }

  @override
  Future<void> deleteAllReminders() async {
    await (_db.delete(_db.reminders)).go();
  }

  @override
  Future<void> createOrUpdateReminder(Reminder reminder) async {
    final companion = _mapToCompanion(reminder);
    await _db.into(_db.reminders).insertOnConflictUpdate(companion);
  }
}
