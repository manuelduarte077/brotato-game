import '../models/reminder.dart';

abstract class ReminderRepository {
  Future<List<Reminder>> getAllReminders();
  Future<Reminder?> getReminder(int id);
  Future<void> createReminder(Reminder reminder);
  Future<void> updateReminder(Reminder reminder);
  Future<void> deleteReminder(int id);
  Future<void> deleteAllReminders();
  Future<void> createOrUpdateReminder(Reminder reminder);
  Future<List<Reminder>> getReminders();
  Stream<List<Reminder>> watchReminders();
}
