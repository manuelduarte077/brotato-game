import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pay_reminder/i18n/translations.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<String> {
  static const String _defaultLanguage = 'en';
  static const String _storageKey = 'language';

  LanguageNotifier() : super(_defaultLanguage) {
    _initializeLanguage();
  }

  Future<void> _initializeLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_storageKey);

      if (savedLanguage != null) {
        await LocaleSettings.setLocale(AppLocale.values.byName(savedLanguage));
        state = savedLanguage;
      }
    } catch (e) {}
  }

  Future<void> updateLanguage(String language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, language);

      await LocaleSettings.setLocale(AppLocale.values.byName(language));

      state = language;
    } catch (e) {
      state = _defaultLanguage;
    }
  }
}
