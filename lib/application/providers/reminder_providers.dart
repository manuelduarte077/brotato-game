import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/services/home_widget_service.dart';
import 'firebase_providers.dart';
import 'package:flutter/foundation.dart';

import '../../domain/repositories/reminder_repository.dart';
import '../../infrastructure/repositories/drift_reminder_repository.dart';
import '../../infrastructure/repositories/firebase_reminder_repository.dart';
import '../../infrastructure/repositories/hybrid_reminder_repository.dart';
import '../database_provider.dart';
import '../providers/auth_providers.dart';
import '../../domain/models/reminder.dart';
import '../../infrastructure/services/notification_service.dart';
import 'home_widget_provider.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final authState = ref.watch(authStateProvider);
  final database = ref.watch(databaseProvider);
  final driftRepo = DriftReminderRepository(database);

  if (authState.user != null) {
    final firebaseRepo = FirebaseReminderRepository(
      firestore: ref.watch(firebaseFirestoreProvider),
      userId: authState.user?.uid,
    );

    return HybridReminderRepository(driftRepo, firebaseRepo);
  }

  return driftRepo;
});

final remindersStreamProvider = StreamProvider<List<Reminder>>((ref) {
  final repository = ref.watch(reminderRepositoryProvider);

  return repository.watchReminders();
});

final reminderControllerProvider = Provider((ref) {
  final repository = ref.watch(reminderRepositoryProvider);

  return ReminderController(repository, ref);
});

class ReminderController {
  final ReminderRepository _repository;
  final NotificationService _notificationService;
  final HomeWidgetService _homeWidgetService;

  ReminderController(this._repository, Ref ref)
      : _notificationService = NotificationService(),
        _homeWidgetService = ref.read(homeWidgetServiceProvider);

  Future<void> _updateHomeWidget() async {
    final reminders = await _repository.getReminders();
    await _homeWidgetService.updateUpcomingReminders(reminders);
  }

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
    try {
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

      await _repository.createReminder(reminder);
      await _notificationService.scheduleReminderNotification(reminder);
      await _updateHomeWidget();
    } catch (e) {
      debugPrint('Error creating reminder: $e');
      throw Exception('Error creating reminder: $e');
    }
  }

  Future<void> updateReminder(Reminder reminder) async {
    try {
      await _repository.updateReminder(reminder);
      if (reminder.id != null) {
        await _notificationService.cancelReminderNotifications(reminder.id!);
      }
      await _notificationService.scheduleReminderNotification(reminder);
      await _updateHomeWidget();
    } catch (e) {
      debugPrint('Error updating reminder: $e');
      throw Exception('Error updating reminder: $e');
    }
  }

  Future<void> deleteReminder(int id) async {
    try {
      await _repository.deleteReminder(id);
      await _notificationService.cancelReminderNotifications(id);
      await _updateHomeWidget();
    } catch (e) {
      debugPrint('Error deleting reminder: $e');
      throw Exception('Error deleting reminder: $e');
    }
  }
}
