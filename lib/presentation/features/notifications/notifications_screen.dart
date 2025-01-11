import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Local Notifications'),
            subtitle: const Text('Receive reminders on your device'),
            value: true,
            onChanged: (value) {
              // Update notification settings
            },
          ),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive reminders across devices'),
            value: true, // Connect to a provider
            onChanged: (value) {
              // Update notification settings
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('Recent Notifications'),
            subtitle: Text('History of your notifications'),
          ),
          // Add list of recent notifications
        ],
      ),
    );
  }
}
