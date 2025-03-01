import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<bool> {
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  OnboardingNotifier() : super(false) {
    _loadOnboardingState();
  }

  Future<void> _loadOnboardingState() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  Future<void> markOnboardingAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, true);
    state = true;
  }
}
