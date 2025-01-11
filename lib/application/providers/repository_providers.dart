import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../infrastructure/repositories/drift_reminder_repository.dart';
import '../../infrastructure/repositories/firebase_reminder_repository.dart';
import '../../infrastructure/repositories/hybrid_reminder_repository.dart';
import '../database_provider.dart';

final driftRepositoryProvider = Provider<ReminderRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return DriftReminderRepository(database);
});

final firebaseRepositoryProvider = Provider<ReminderRepository>((ref) {
  return FirebaseReminderRepository();
});

final hybridRepositoryProvider = Provider<ReminderRepository>((ref) {
  final localRepo = ref.watch(driftRepositoryProvider);
  final remoteRepo = ref.watch(firebaseRepositoryProvider);
  return HybridReminderRepository(localRepo, remoteRepo);
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ref.watch(hybridRepositoryProvider);
});
