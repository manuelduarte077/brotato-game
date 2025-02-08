import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pay_reminder/i18n/translations.g.dart';
import 'app/app.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'infrastructure/services/notification_service.dart';
import 'infrastructure/services/home_widget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize timezone database
  tz.initializeTimeZones();

  // Initialize notifications
  await NotificationService().init();

  // Initialize home widget
  final homeWidgetService = HomeWidgetService();
  await homeWidgetService.initialize();

  // Firebase Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
    ProviderScope(
      child: TranslationProvider(
        child: MyApp(),
      ),
    ),
  );
}
