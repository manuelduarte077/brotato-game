import '../../domain/models/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import 'drift_reminder_repository.dart';
import 'firebase_reminder_repository.dart';

class HybridReminderRepository implements ReminderRepository {
  final DriftReminderRepository _localRepository;
  final FirebaseReminderRepository _remoteRepository;

  HybridReminderRepository(this._localRepository, this._remoteRepository);

  @override
  Future<List<Reminder>> getAllReminders() async {
    return _localRepository.getAllReminders();
  }

  Future<void> syncFromRemote() async {
    try {
      final localReminders = await _localRepository.getAllReminders();
      final remoteReminders = await _remoteRepository.getAllReminders();

      print(
          'Syncing - Local: ${localReminders.length}, Remote: ${remoteReminders.length}');

      // 1. Sincronizar locales no sincronizados a remoto
      for (final localReminder in localReminders.where((r) => !r.isSynced)) {
        try {
          await _remoteRepository.createReminder(localReminder);
          await _localRepository
              .updateReminder(localReminder.copyWith(isSynced: true));
        } catch (e) {
          print('Error syncing local reminder: $e');
        }
      }

      // 2. Sincronizar remotos a local
      for (final remoteReminder in remoteReminders) {
        try {
          localReminders.firstWhere((local) => local.id == remoteReminder.id,
              orElse: () => remoteReminder);

          await _localRepository
              .createOrUpdateReminder(remoteReminder.copyWith(isSynced: true));
        } catch (e) {
          print('Error syncing remote reminder: $e');
        }
      }
    } catch (e) {
      print('Error in syncFromRemote: $e');
      rethrow;
    }
  }

  @override
  Future<void> createReminder(Reminder reminder) async {
    try {
      // Crear en local primero
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final localReminder =
          reminder.copyWith(id: reminder.id ?? timestamp, isSynced: false);

      await _localRepository.createReminder(localReminder);
      print('Created reminder locally with ID: ${localReminder.id}');

      // Intentar respaldar en remoto
      try {
        await _remoteRepository.createReminder(localReminder);
        await _localRepository
            .updateReminder(localReminder.copyWith(isSynced: true));
        print('Backed up reminder to remote successfully');
      } catch (e) {
        print('Error backing up to remote: $e');
        // No relanzar el error para mantener el recordatorio local
      }
    } catch (e) {
      print('Error creating reminder: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    try {
      await _localRepository.updateReminder(reminder);
      await _remoteRepository.updateReminder(reminder);
    } catch (e) {
      print('Error updating reminder: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteReminder(int id) async {
    try {
      await _localRepository.deleteReminder(id);
      await _remoteRepository.deleteReminder(id);
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
      return await _remoteRepository.getReminder(id);
    } catch (e) {
      print('Error fetching remote reminder: $e');
      return await _localRepository.getReminder(id);
    }
  }

  @override
  Future<void> deleteAllReminders() async {
    await _localRepository.deleteAllReminders();
    await _remoteRepository.deleteAllReminders();
  }

  @override
  Future<void> createOrUpdateReminder(Reminder reminder) async {
    await _localRepository.createOrUpdateReminder(reminder);
    await _remoteRepository.createOrUpdateReminder(reminder);
  }
}
