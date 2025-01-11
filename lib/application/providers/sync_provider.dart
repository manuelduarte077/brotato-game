import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reminder_providers.dart';
import '../../infrastructure/repositories/hybrid_reminder_repository.dart';

enum SyncStatus {
  initial,
  syncing,
  success,
  error,
}

class SyncState {
  final SyncStatus status;
  final String? message;
  final DateTime? lastSyncTime;

  SyncState({
    required this.status,
    this.message,
    this.lastSyncTime,
  });

  factory SyncState.initial() => SyncState(status: SyncStatus.initial);
}

final syncNotifierProvider =
    StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(ref);
});

class SyncNotifier extends StateNotifier<SyncState> {
  final Ref _ref;

  SyncNotifier(this._ref) : super(SyncState.initial());

  Future<void> syncFromRemote() async {
    state = SyncState(
      status: SyncStatus.syncing,
      message: 'Sincronizando recordatorios...',
    );

    try {
      final repository = _ref.read(reminderRepositoryProvider);
      if (repository is HybridReminderRepository) {
        await repository.syncFromRemote();
        state = SyncState(
          status: SyncStatus.success,
          message: 'Sincronización completada',
          lastSyncTime: DateTime.now(),
        );
      }
    } catch (e) {
      state = SyncState(
        status: SyncStatus.error,
        message: 'Error en la sincronización: ${e.toString()}',
      );
    }
  }
}
