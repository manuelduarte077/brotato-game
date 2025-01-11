import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers/auth_providers.dart';
import '../application/providers/theme_provider.dart';
import '../presentation/features/home_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authInitializationProvider);

    final isDarkMode = ref.watch(themeProvider.select(
      (future) => future.when(
        data: (value) => value,
        loading: () => false,
        error: (_, __) => false,
      ),
    ));

    return MaterialApp(
      title: 'Reminder App',
      home: const HomeScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.indigo,
          secondary: Colors.indigoAccent,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.indigo.shade200,
          secondary: Colors.indigoAccent.shade200,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
