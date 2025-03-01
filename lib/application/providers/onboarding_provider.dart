import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final hasSeenOnboardingProvider =
    StateNotifierProvider<OnboardingNotifier, AsyncValue<bool>>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<AsyncValue<bool>> {
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  OnboardingNotifier() : super(const AsyncValue.loading()) {
    _loadOnboardingState();
  }

  Future<void> _loadOnboardingState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool(_hasSeenOnboardingKey) ?? false;

      if (mounted) {
        state = AsyncValue.data(hasSeenOnboarding);
      }
    } catch (e) {
      if (mounted) {
        state = AsyncValue.data(false);
      }
    }
  }

  Future<void> markOnboardingAsSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hasSeenOnboardingKey, true);

      if (mounted) {
        state = const AsyncValue.data(true);
      }
    } catch (e) {
      print(e);
    }
  }
}
