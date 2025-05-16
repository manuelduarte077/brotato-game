import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, AsyncValue<bool>>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<AsyncValue<bool>> {
  ThemeNotifier() : super(const AsyncValue.loading()) {
    _loadTheme();
  }

  static const _themeKey = 'is_dark_mode';

  Future<void> _loadTheme() async {
    state = const AsyncValue.loading();

    try {
      final prefs = await SharedPreferences.getInstance();
      final isDarkMode = prefs.getBool(_themeKey) ?? false;
      state = AsyncValue.data(isDarkMode);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleTheme() async {
    final currentMode = state.value ?? false;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, !currentMode);
      state = AsyncValue.data(!currentMode);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
