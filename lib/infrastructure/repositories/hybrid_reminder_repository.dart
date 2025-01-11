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
      // Obtener recordatorios locales y remotos
      final localReminders = await _localRepository.getAllReminders();
      final remoteReminders = await _remoteRepository.getAllReminders();

      print(
          'Syncing: Local(${localReminders.length}) Remote(${remoteReminders.length})');

      // Crear mapas para búsqueda eficiente
      final localMap = {for (var r in localReminders) r.id: r};
      final remoteMap = {for (var r in remoteReminders) r.id: r};

      // Sincronizar locales a remoto
      for (final localReminder in localReminders) {
        if (localReminder.id == null) continue;

        final remoteVersion = remoteMap[localReminder.id];
        if (remoteVersion == null) {
          // No existe en remoto, crear
          await _remoteRepository.createReminder(localReminder);
        } else if (localReminder.updatedAt.isAfter(remoteVersion.updatedAt)) {
          // Local más reciente, actualizar remoto
          await _remoteRepository.updateReminder(localReminder);
        }
      }

      // Sincronizar remotos a local
      for (final remoteReminder in remoteReminders) {
        if (remoteReminder.id == null) continue;

        final localVersion = localMap[remoteReminder.id];
        if (localVersion == null) {
          // No existe en local, crear
          await _localRepository.createReminder(remoteReminder);
        } else if (remoteReminder.updatedAt.isAfter(localVersion.updatedAt)) {
          // Remoto más reciente, actualizar local
          await _localRepository.updateReminder(remoteReminder);
        }
      }

      print('Sync completed successfully');
    } catch (e) {
      print('Error in syncFromRemote: $e');
      rethrow;
    }
  }

  @override
  Future<void> createReminder(Reminder reminder) async {
    // Crear en local primero
    await _localRepository.createReminder(reminder);

    // Intentar respaldar en remoto
    try {
      await _remoteRepository.createReminder(reminder);
    } catch (e) {
      print('Error backing up to remote: $e');
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
