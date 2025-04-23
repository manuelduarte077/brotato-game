import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay_reminder/i18n/translations.g.dart';

import '../application/providers/theme_provider.dart';
import '../presentation/routes/app_routes.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider.select(
      (future) => future.when(
        data: (value) => value,
        loading: () => false,
        error: (_, __) => false,
      ),
    ));

    final nameApp = context.texts.app.title;

    return MaterialApp(
      title: nameApp,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      onUnknownRoute: AppRoutes.onUnknownRoute,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color(0xff1a2e2f),
          onPrimary: Colors.white,
          secondary: Color(0xff1f4546),
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xff1a2e2f),
          error: Color(0xffd32f2f),
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: Color(0xfff5f5f5),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xfff5f5f5),
          foregroundColor: Color(0xff1a2e2f),
        ),
        fontFamily: GoogleFonts.montserratAlternates().fontFamily,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.indigo.shade200,
          secondary: Colors.indigoAccent.shade200,
        ),
        fontFamily: GoogleFonts.montserratAlternates().fontFamily,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
