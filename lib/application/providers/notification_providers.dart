import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
        (ref) {
  return NotificationSettingsNotifier();
});

class NotificationSettings {
  final bool localNotificationsEnabled;
  final List<int> reminderDays;

  NotificationSettings({
    this.localNotificationsEnabled = true,
    this.reminderDays = const [5, 2, 1],
  });

  NotificationSettings copyWith({
    bool? localNotificationsEnabled,
    List<int>? reminderDays,
  }) {
    return NotificationSettings(
      localNotificationsEnabled:
          localNotificationsEnabled ?? this.localNotificationsEnabled,
      reminderDays: reminderDays ?? this.reminderDays,
    );
  }
}

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(NotificationSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationSettings(
      localNotificationsEnabled:
          prefs.getBool('localNotificationsEnabled') ?? true,
      reminderDays:
          prefs.getStringList('reminderDays')?.map(int.parse).toList() ??
              [5, 2, 1],
    );
  }

  Future<void> toggleLocalNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('localNotificationsEnabled', value);
    state = state.copyWith(localNotificationsEnabled: value);
  }

  Future<void> toggleReminderDay(int days) async {
    final prefs = await SharedPreferences.getInstance();
    final currentDays = List<int>.from(state.reminderDays);

    if (currentDays.contains(days)) {
      currentDays.remove(days);
    } else {
      currentDays.add(days);
    }

    await prefs.setStringList(
      'reminderDays',
      currentDays.map((d) => d.toString()).toList(),
    );

    state = state.copyWith(reminderDays: currentDays);
  }
}

class NotificationRecord {
  final int id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;

  NotificationRecord({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  NotificationRecord copyWith({bool? isRead}) {
    return NotificationRecord(
      id: id,
      title: title,
      body: body,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

final notificationHistoryProvider = StateNotifierProvider<
    NotificationHistoryNotifier, List<NotificationRecord>>((ref) {
  return NotificationHistoryNotifier();
});

class NotificationHistoryNotifier
    extends StateNotifier<List<NotificationRecord>> {
  NotificationHistoryNotifier() : super([]);

  void addNotification(NotificationRecord notification) {
    state = [notification, ...state];
  }

  void markAsRead(int id) {
    state = [
      for (final notification in state)
        if (notification.id == id)
          notification.copyWith(isRead: true)
        else
          notification,
    ];
  }

  void clearReadNotifications() {
    state = state.where((notification) => !notification.isRead).toList();
  }
}
