import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';

class FirebaseReminderRepository implements ReminderRepository {
  final CollectionReference _reminders;
  final String? userId;

  FirebaseReminderRepository({
    required FirebaseFirestore firestore,
    this.userId,
  }) : _reminders = firestore.collection('reminders');

  Map<String, dynamic> _reminderToMap(Reminder reminder) {
    return {
      'userId': userId,
      'title': reminder.title,
      'description': reminder.description,
      'amount': reminder.amount,
      'dueDate': Timestamp.fromDate(reminder.dueDate),
      'category': reminder.category,
      'isRecurring': reminder.isRecurring,
      'recurrenceType': reminder.recurrenceType,
      'recurrenceInterval': reminder.recurrenceInterval,
      'createdAt': Timestamp.fromDate(reminder.createdAt),
      'updatedAt': Timestamp.fromDate(reminder.updatedAt),
    };
  }

  Reminder _mapToReminder(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reminder(
      id: int.tryParse(doc.id),
      title: data['title'] ?? '',
      description: data['description'],
      amount: (data['amount'] ?? 0.0).toDouble(),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      category: data['category'] ?? '',
      isRecurring: data['isRecurring'] ?? false,
      recurrenceType: data['recurrenceType'],
      recurrenceInterval: data['recurrenceInterval'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  @override
  Future<void> createReminder(Reminder reminder) async {
    if (userId == null) {
      // Si no hay usuario, solo registrar y continuar
      print('No authenticated user, skipping remote creation');
      return;
    }

    // Asignar un ID numérico al reminder si no tiene uno
    if (reminder.id == null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      reminder = reminder.copyWith(id: timestamp);
    }

    final reminderData = _reminderToMap(reminder);
    await _reminders.doc(reminder.id.toString()).set(reminderData);
  }

  @override
  Future<void> deleteReminder(int id) async {
    await _reminders.doc(id.toString()).delete();
    print('Deleted reminder with id: $id');
  }

  @override
  Future<List<Reminder>> getAllReminders() async {
    if (userId == null) return [];

    try {
      // Consulta simple sin ordenamiento inicialmente
      final querySnapshot =
          await _reminders.where('userId', isEqualTo: userId).get();

      final reminders = querySnapshot.docs.map(_mapToReminder).toList();
      // Ordenar en memoria
      reminders.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return reminders;
    } catch (e) {
      print('Error getting reminders: $e');
      return [];
    }
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

  @override
  Future<void> deleteAllReminders() async {
    await _reminders.get().then((snapshot) {
      snapshot.docs.forEach((doc) => doc.reference.delete());
    });
  }

  @override
  Future<void> createOrUpdateReminder(Reminder reminder) async {
    if (userId == null) return;

    if (reminder.id == null) {
      await createReminder(reminder);
    } else {
      await _reminders
          .doc(reminder.id.toString())
          .set(_reminderToMap(reminder), SetOptions(merge: true));
    }
  }
}
