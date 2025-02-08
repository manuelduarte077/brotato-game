import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pay_reminder/i18n/translations.g.dart';

import '../../../application/providers/notification_providers.dart';
import '../../../infrastructure/services/notification_service.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationHistoryProvider);
    final texts = context.texts.app.notifications;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            texts.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelStyle: const TextStyle(fontSize: 12),
            automaticIndicatorColorAdjustment: true,
            splashFactory: NoSplash.splashFactory,
            tabs: [
              Tab(
                text: texts.unread,
                icon: const Icon(Icons.notifications_none),
              ),
              Tab(
                text: texts.recent,
                icon: const Icon(Icons.notifications_active),
              ),
              Tab(
                text: texts.read,
                icon: const Icon(Icons.notifications_none),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _showNotificationSettings(context, ref),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _NotificationList(
              notifications: notifications.where((n) => !n.isRead).toList(),
              emptyMessage: texts.noUnreadNotifications,
            ),
            _NotificationList(
              notifications: notifications
                  .where((n) => n.timestamp.isAfter(
                      DateTime.now().subtract(const Duration(days: 7))))
                  .toList(),
              emptyMessage: texts.noRecentNotifications,
            ),
            _NotificationList(
              notifications: notifications.where((n) => n.isRead).toList(),
              emptyMessage: texts.noReadNotifications,
              showClearButton: true,
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => _NotificationSettings(),
    );
  }
}

class _NotificationSettings extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    final notificationService = NotificationService();
    final texts = context.texts.app.notifications;
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texts.notificationSettings,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              texts.enableNotifications,
              style: const TextStyle(fontSize: 16),
            ),
            subtitle: Text(
              texts.receivePaymentReminders,
              style: const TextStyle(fontSize: 12),
            ),
            value: settings.localNotificationsEnabled,
            onChanged: (value) async {
              if (value) {
                final hasPermission =
                    await notificationService.requestPermissions();

                if (!hasPermission) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        texts.pleaseEnableNotificationsInSettings,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                  return;
                }
              }
              ref
                  .read(notificationSettingsProvider.notifier)
                  .toggleLocalNotifications(value);
            },
          ),
          const Divider(),
          Text(texts.notifyMeBeforeDueDate),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [1, 2, 5]
                .map((days) => _ReminderDayChip(
                      days: days,
                      isSelected: settings.reminderDays.contains(days),
                      onSelected: (selected) {
                        ref
                            .read(notificationSettingsProvider.notifier)
                            .toggleReminderDay(days);
                      },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _NotificationList extends ConsumerWidget {
  final List<NotificationRecord> notifications;
  final String emptyMessage;
  final bool showClearButton;

  const _NotificationList({
    required this.notifications,
    required this.emptyMessage,
    this.showClearButton = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final texts = context.texts.app.notifications;

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_none, size: 48),
            const SizedBox(height: 16),
            Text(emptyMessage),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (showClearButton && notifications.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.delete_sweep),
              label: Text(texts.clearReadNotifications),
              onPressed: () {
                ref
                    .read(notificationHistoryProvider.notifier)
                    .clearReadNotifications();
              },
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _NotificationTile(notification: notification);
            },
          ),
        ),
      ],
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  final NotificationRecord notification;
  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(
        notification.isRead
            ? Icons.notifications_none
            : Icons.notifications_active,
        color:
            notification.isRead ? null : Theme.of(context).colorScheme.primary,
      ),
      title: Text(notification.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification.body),
          Text(
            _formatTimestamp(notification.timestamp, context),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      onTap: () {
        if (!notification.isRead) {
          ref
              .read(notificationHistoryProvider.notifier)
              .markAsRead(notification.id);
        }
        _showNotificationDetails(context, notification);
      },
    );
  }

  String _formatTimestamp(DateTime timestamp, BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    final texts = context.texts.app.notifications;

    if (difference.inDays > 0) {
      return texts.daysAgo(count: difference.inDays);
    } else if (difference.inHours > 0) {
      return texts.hoursAgo(count: difference.inHours);
    } else if (difference.inMinutes > 0) {
      return texts.minutesAgo(count: difference.inMinutes);
    } else {
      return texts.justNow;
    }
  }

  void _showNotificationDetails(
      BuildContext context, NotificationRecord notification) {
    final texts = context.texts.app.notifications;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(notification.body),
            const SizedBox(height: 8),
            Text(
              texts.received(timestamp: notification.timestamp.toString()),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(texts.close),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderDayChip extends StatelessWidget {
  final int days;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;

  const _ReminderDayChip({
    required this.days,
    this.isSelected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts.app.notifications;

    return FilterChip(
      avatar: Icon(
        Icons.notifications,
        color: isSelected ? Theme.of(context).colorScheme.onPrimary : null,
      ),
      label: Text(texts.daysBefore(count: days)),
      selected: isSelected,
      onSelected: onSelected,
    );
  }
}
