import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/repositories/drift_reminder_repository.dart';
import '../../infrastructure/repositories/hybrid_reminder_repository.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../database_provider.dart';

final driftRepositoryProvider = Provider<DriftReminderRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return DriftReminderRepository(database);
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final driftRepo = ref.watch(driftRepositoryProvider);
  return HybridReminderRepository(driftRepo);
});
