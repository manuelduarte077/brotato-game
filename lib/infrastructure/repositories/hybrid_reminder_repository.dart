import '../../domain/models/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';

class HybridReminderRepository implements ReminderRepository {
  final ReminderRepository _localRepository;
  final ReminderRepository _remoteRepository;

  HybridReminderRepository(this._localRepository, this._remoteRepository);

  @override
  Future<void> createReminder(Reminder reminder) async {
    await _localRepository.createReminder(reminder);
    await _remoteRepository.createReminder(reminder);
  }

  @override
  Future<void> deleteReminder(int id) async {
    await _localRepository.deleteReminder(id);
    await _remoteRepository.deleteReminder(id);
  }

  @override
  Future<List<Reminder>> getAllReminders() async {
    try {
      // Prefer remote data, fallback to local if remote fails
      return await _remoteRepository.getAllReminders();
    } catch (e) {
      return await _localRepository.getAllReminders();
    }
  }

  @override
  Future<Reminder?> getReminder(int id) async {
    try {
      // Prefer remote data, fallback to local if remote fails
      return await _remoteRepository.getReminder(id);
    } catch (e) {
      return await _localRepository.getReminder(id);
    }
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    await _localRepository.updateReminder(reminder);
    await _remoteRepository.updateReminder(reminder);
  }

  @override
  Stream<List<Reminder>> watchReminders() {
    // Use local database for watching changes since it's more reliable for real-time updates
    return _localRepository.watchReminders();
  }
}
