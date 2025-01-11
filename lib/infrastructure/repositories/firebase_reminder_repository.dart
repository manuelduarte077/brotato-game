import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';

class FirebaseReminderRepository implements ReminderRepository {
  final _reminders = FirebaseFirestore.instance.collection('reminders');

  Map<String, dynamic> _reminderToMap(Reminder reminder) {
    return {
      'title': reminder.title,
      'description': reminder.description,
      'amount': reminder.amount,
      'dueDate': reminder.dueDate.toIso8601String(),
      'category': reminder.category,
      'isRecurring': reminder.isRecurring,
      'recurrenceType': reminder.recurrenceType,
      'recurrenceInterval': reminder.recurrenceInterval,
      'createdAt': reminder.createdAt.toIso8601String(),
      'updatedAt': reminder.updatedAt.toIso8601String(),
    };
  }

  Reminder _mapToReminder(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reminder(
      id: int.tryParse(doc.id),
      title: data['title'] as String,
      description: data['description'] as String?,
      amount: (data['amount'] as num).toDouble(),
      dueDate: DateTime.parse(data['dueDate'] as String),
      category: data['category'] as String,
      isRecurring: data['isRecurring'] as bool,
      recurrenceType: data['recurrenceType'] as String?,
      recurrenceInterval: data['recurrenceInterval'] as int?,
      createdAt: DateTime.parse(data['createdAt'] as String),
      updatedAt: DateTime.parse(data['updatedAt'] as String),
    );
  }

  @override
  Future<void> createReminder(Reminder reminder) async {
    final docRef = reminder.id != null
        ? _reminders.doc(reminder.id.toString())
        : _reminders.doc();

    await docRef.set(_reminderToMap(reminder));
  }

  @override
  Future<void> deleteReminder(int id) async {
    await _reminders.doc(id.toString()).delete();
  }

  @override
  Future<List<Reminder>> getAllReminders() async {
    final querySnapshot = await _reminders.orderBy('dueDate').get();

    return querySnapshot.docs.map(_mapToReminder).toList();
  }

  @override
  Future<Reminder?> getReminder(int id) async {
    final docSnapshot = await _reminders.doc(id.toString()).get();
    if (!docSnapshot.exists) return null;
    return _mapToReminder(docSnapshot);
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    if (reminder.id == null)
      throw Exception('Cannot update reminder without id');

    await _reminders
        .doc(reminder.id.toString())
        .update(_reminderToMap(reminder));
  }

  @override
  Stream<List<Reminder>> watchReminders() {
    return _reminders
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_mapToReminder).toList());
  }
}
