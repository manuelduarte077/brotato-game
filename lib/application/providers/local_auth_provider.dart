import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/services/local_auth_service.dart';

final localAuthServiceProvider = Provider((ref) => LocalAuthService());

final biometricEnabledProvider =
    StateNotifierProvider<BiometricEnabledNotifier, AsyncValue<bool>>((ref) {
  return BiometricEnabledNotifier(ref.watch(localAuthServiceProvider));
});

class BiometricEnabledNotifier extends StateNotifier<AsyncValue<bool>> {
  final LocalAuthService _authService;

  BiometricEnabledNotifier(this._authService)
      : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    state = AsyncValue.data(await _authService.isBiometricEnabled());
  }

  Future<void> toggleBiometric(bool enabled) async {
    await _authService.setBiometricEnabled(enabled);
    state = AsyncValue.data(enabled);
  }
}
