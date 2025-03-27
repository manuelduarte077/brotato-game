import 'package:quick_actions/quick_actions.dart';
import 'package:flutter/material.dart';

import '../../presentation/routes/app_routes.dart';

class QuickActionsService {
  static final QuickActionsService _instance = QuickActionsService._();
  factory QuickActionsService() => _instance;

  QuickActionsService._();

  final _quickActions = const QuickActions();

  Future<void> init(BuildContext context) async {
    try {
      await _quickActions.initialize((shortcutType) {
        _handleQuickAction(context, shortcutType);
      });

      await _quickActions.setShortcutItems([
        const ShortcutItem(
          type: 'new_reminder',
          localizedTitle: 'New Reminder',
          icon: 'launch_background',
        ),
        const ShortcutItem(
          type: 'view_calendar',
          localizedTitle: 'View Calendar',
          icon: 'launch_background',
        ),
      ]);
    } catch (e) {
      debugPrint('Error initializing quick actions: $e');
    }
  }

  void _handleQuickAction(BuildContext context, String shortcutType) {
    switch (shortcutType) {
      case 'new_reminder':
        Navigator.pushNamed(context, AppRoutes.createReminder);
        break;
      case 'view_calendar':
        Navigator.pushNamed(context, AppRoutes.calendar);
        break;
    }
  }
}
