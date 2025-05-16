import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/reminder.dart';
import '../../widgets/show_reminder_form.dart';

class ShowReminderScreen extends ConsumerWidget {
  final Reminder reminder;

  const ShowReminderScreen({
    super.key,
    required this.reminder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShowReminderForm(
      reminder: reminder,
    );
  }
}
