import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pay_reminder/i18n/translations.g.dart';
import 'app/app.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'infrastructure/services/notification_service.dart';
import 'infrastructure/services/home_widget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone database
  tz.initializeTimeZones();

  // Initialize notifications
  await NotificationService().init();

  // Initialize home widget
  final homeWidgetService = HomeWidgetService();
  await homeWidgetService.initialize();

  runApp(
    ProviderScope(
      child: TranslationProvider(
        child: MyApp(),
      ),
    ),
  );
}
