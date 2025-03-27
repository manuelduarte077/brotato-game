import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pay_reminder/application/providers/firebase_providers.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../infrastructure/repositories/drift_reminder_repository.dart';
import '../../infrastructure/repositories/firebase_reminder_repository.dart';
import '../../infrastructure/repositories/hybrid_reminder_repository.dart';
import '../database_provider.dart';
import '../providers/auth_providers.dart';

final driftRepositoryProvider = Provider<ReminderRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return DriftReminderRepository(database);
});

final firebaseRepositoryProvider = Provider<FirebaseReminderRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final authState = ref.watch(authStateProvider);

  return FirebaseReminderRepository(
    firestore: firestore,
    userId: authState.user?.uid,
  );
});

final hybridRepositoryProvider = Provider<ReminderRepository>((ref) {
  final localRepo =
      ref.watch(driftRepositoryProvider) as DriftReminderRepository;
  final remoteRepo = ref.watch(firebaseRepositoryProvider);

  return HybridReminderRepository(localRepo, remoteRepo);
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final authState = ref.watch(authStateProvider);
  final driftRepo =
      ref.watch(driftRepositoryProvider) as DriftReminderRepository;

  if (authState.user != null) {
    final firebaseRepo = ref.watch(firebaseRepositoryProvider);

    return HybridReminderRepository(driftRepo, firebaseRepo);
  }

  return driftRepo;
});
