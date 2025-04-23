import '../../domain/models/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import 'drift_reminder_repository.dart';

class HybridReminderRepository implements ReminderRepository {
  final DriftReminderRepository _localRepository;

  HybridReminderRepository(this._localRepository);

  @override
  Future<List<Reminder>> getAllReminders() async {
    return _localRepository.getAllReminders();
  }

  @override
  Future<void> createReminder(Reminder reminder) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final localReminder = reminder.copyWith(id: reminder.id ?? timestamp);
      await _localRepository.createReminder(localReminder);
      print('Created reminder locally with ID: ${localReminder.id}');
    } catch (e) {
      print('Error creating reminder: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    try {
      await _localRepository.updateReminder(reminder);
    } catch (e) {
      print('Error updating reminder: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteReminder(int id) async {
    try {
      await _localRepository.deleteReminder(id);
    } catch (e) {
      print('Error deleting reminder: $e');
      rethrow;
    }
  }

  @override
  Stream<List<Reminder>> watchReminders() {
    return _localRepository.watchReminders();
  }

  @override
  Future<Reminder?> getReminder(int id) async {
    try {
      return await _localRepository.getReminder(id);
    } catch (e) {
      print('Error fetching reminder: $e');
      return null;
    }
  }

  @override
  Future<void> deleteAllReminders() async {
    await _localRepository.deleteAllReminders();
  }

  @override
  Future<void> createOrUpdateReminder(Reminder reminder) async {
    await _localRepository.createOrUpdateReminder(reminder);
  }

  @override
  Future<List<Reminder>> getReminders() async {
    return await _localRepository.getReminders();
  }
}
