import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database_provider.dart';
import 'language_provider.dart';
import 'theme_provider.dart';

final resetAppProvider = Provider((ref) => ResetAppService(ref));

class ResetAppService {
  final Ref _ref;

  ResetAppService(this._ref);

  Future<void> resetAllData() async {
    try {
      final db = _ref.read(databaseProvider);
      await (db.delete(db.reminders)).go();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _ref.invalidate(languageProvider);
      _ref.invalidate(themeProvider);
    } catch (e) {
      throw Exception('Error al reiniciar la aplicación: $e');
    }
  }
}
