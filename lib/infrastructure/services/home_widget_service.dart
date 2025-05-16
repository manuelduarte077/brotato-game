import 'package:home_widget/home_widget.dart';
import '../../domain/models/reminder.dart';
import 'package:flutter/foundation.dart';

class HomeWidgetService {
  static const String appGroupId = 'group.payReminderApp';
  static const String androidWidgetName = 'NFWidget';
  static const String iOSWidgetName = 'NFWidget';

  Future<void> updateUpcomingReminders(List<Reminder> reminders) async {
    try {
      final upcomingReminders = reminders
          .where((r) => r.dueDate.isAfter(DateTime.now()))
          .toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

      final widgetReminders = upcomingReminders.take(3).toList();

      debugPrint('Updating widget with reminders: ${widgetReminders.length}');

      final titles = widgetReminders.map((r) => r.title).toList();
      final amounts = widgetReminders.map((r) => r.amount).toList();
      final dueDates = widgetReminders
          .map((r) =>
              "${r.dueDate.day.toString().padLeft(2, '0')}/${r.dueDate.month.toString().padLeft(2, '0')}")
          .toList();

      debugPrint(
          'Widget data to save: titles=$titles, amounts=$amounts, dueDates=$dueDates');

      await HomeWidget.saveWidgetData('titles', titles);
      await HomeWidget.saveWidgetData('amounts', amounts);
      await HomeWidget.saveWidgetData('dueDates', dueDates);

      await HomeWidget.updateWidget(
        iOSName: iOSWidgetName,
        androidName: androidWidgetName,
      );

      debugPrint('Widget update completed');
    } catch (e) {
      debugPrint('Error updating home widget: $e');
    }
  }

  Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId(appGroupId);
    } catch (e) {
      debugPrint('Error initializing home widget: $e');
    }
  }
}
