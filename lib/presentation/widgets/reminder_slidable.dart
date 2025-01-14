import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../application/providers/reminder_providers.dart';
import '../../domain/models/reminder.dart';
import '../features/reminders/edit_reminder_screen.dart';
import 'reminder_card.dart';

class ReminderSlidable extends ConsumerWidget {
  final Reminder reminder;

  const ReminderSlidable({
    super.key,
    required this.reminder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: Key(reminder.id.toString()),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _showEditSheet(context),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: CupertinoIcons.pencil,
            autoClose: true,
            borderRadius: BorderRadius.circular(8),
            label: 'Editar',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _handleDelete(context, ref),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: CupertinoIcons.delete,
            autoClose: true,
            label: 'Eliminar',
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
      child: ReminderCard(reminder: reminder),
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      scrollControlDisabledMaxHeightRatio: 0.9,
      builder: (context) => EditReminderScreen(reminder: reminder),
    );
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final confirm = Theme.of(context).platform == TargetPlatform.iOS
        ? await _showIOSDeleteDialog(context)
        : await _showMaterialDeleteDialog(context);

    if (confirm == true) {
      ref.read(reminderControllerProvider).deleteReminder(reminder.id!);
    }
  }

  Future<bool?> _showIOSDeleteDialog(BuildContext context) {
    return showCupertinoModalPopup<bool>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Eliminar recordatorio',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        message: const Text(
          '¿Estás seguro que deseas eliminar este recordatorio?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(true),
            isDestructiveAction: true,
            child: const Text(
              'Eliminar',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Cancelar',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showMaterialDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Confirmar',
          style: TextStyle(fontSize: 16),
        ),
        content: const Text(
          '¿Estás seguro que deseas eliminar este recordatorio?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancelar',
              style: TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Eliminar',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
