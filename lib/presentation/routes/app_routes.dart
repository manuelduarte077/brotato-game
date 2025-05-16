import 'package:flutter/material.dart';
import '../features/home_screen.dart';
import '../features/calendar/calendar_screen.dart';
import '../features/reminders/create_reminder_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/auth/auth_gate.dart';

class AppRoutes {
  static const String home = '/';
  static const String createReminder = '/create-reminder';
  static const String calendar = '/calendar';
  static const String profile = '/profile';

  static Map<String, Widget Function(BuildContext)> get routes => {
        home: (context) => AuthGate(child: const HomeScreen()),
        createReminder: (context) => const CreateReminderScreen(),
        calendar: (context) => const CalendarScreen(),
        profile: (context) => const ProfileScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    try {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          final widget = switch (settings.name) {
            createReminder => const CreateReminderScreen(),
            calendar => const CalendarScreen(),
            profile => const ProfileScreen(),
            home => const HomeScreen(),
            _ => throw const RouteException('Route not found'),
          };

          return settings.name == home ? AuthGate(child: widget) : widget;
        },
      );
    } catch (e) {
      return _errorRoute(e.toString());
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return _errorRoute('Route not found: ${settings.name}');
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);

  @override
  String toString() => message;
}
