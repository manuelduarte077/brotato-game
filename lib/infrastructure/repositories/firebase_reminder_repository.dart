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
      'description': reminder.description ?? '',
      'amount': reminder.amount,
      'dueDate': Timestamp.fromDate(reminder.dueDate),
      'category': reminder.category,
      'isRecurring': reminder.isRecurring,
      'recurrenceType': reminder.recurrenceType ?? '',
      'recurrenceInterval': reminder.recurrenceInterval ?? 0,
      'createdAt': Timestamp.fromDate(reminder.createdAt),
      'updatedAt': Timestamp.fromDate(reminder.updatedAt),
      'isSynced': reminder.isSynced,
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

  void _validateUser() {
    if (userId == null) {
      throw Exception('No authenticated user found');
    }
  }

  bool _isOwner(Map<String, dynamic> data) {
    return data['userId'] == userId;
  }

  @override
  Future<void> createReminder(Reminder reminder) async {
    if (userId == null) {
      print('No userId available, skipping remote creation');
      return;
    }

    try {
      final reminderWithUser = reminder.copyWith(
        userId: userId,
        id: reminder.id ?? DateTime.now().millisecondsSinceEpoch,
        isSynced: true,
      );

      final reminderData = _reminderToMap(reminderWithUser);
      await _reminders.doc(reminderWithUser.id.toString()).set(reminderData);
      print(
          'Successfully created reminder in Firebase with ID: ${reminderWithUser.id}');
    } catch (e) {
      print('Error creating reminder in Firebase: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteReminder(int id) async {
    _validateUser();

    final doc = await _reminders.doc(id.toString()).get();
    if (!doc.exists) return;

    final data = doc.data() as Map<String, dynamic>;
    if (!_isOwner(data)) {
      throw Exception('Unauthorized to delete this reminder');
    }

    await _reminders.doc(id.toString()).delete();
  }

  @override
  Future<List<Reminder>> getAllReminders() async {
    if (userId == null) return [];

    try {
      final querySnapshot =
          await _reminders.where('userId', isEqualTo: userId).get();

      final reminders = querySnapshot.docs.map(_mapToReminder).toList();

      reminders.sort((a, b) => a.dueDate.compareTo(b.dueDate));

      print('Retrieved ${reminders.length} reminders for user $userId');
      return reminders;
    } catch (e) {
      print('Error getting reminders: $e');
      return [];
    }
  }

  @override
  Future<Reminder?> getReminder(int id) async {
    _validateUser();

    final docSnapshot = await _reminders.doc(id.toString()).get();
    if (!docSnapshot.exists) return null;

    final data = docSnapshot.data() as Map<String, dynamic>;
    if (!_isOwner(data)) {
      throw Exception('Unauthorized access to reminder');
    }

    return _mapToReminder(docSnapshot);
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    _validateUser();

    if (reminder.id == null) {
      throw Exception('Cannot update reminder without id');
    }

    final doc = await _reminders.doc(reminder.id.toString()).get();
    if (!doc.exists) {
      throw Exception('Reminder not found');
    }

    final data = doc.data() as Map<String, dynamic>;
    if (!_isOwner(data)) {
      throw Exception('Unauthorized to update this reminder');
    }

    await _reminders
        .doc(reminder.id.toString())
        .update(_reminderToMap(reminder));
  }

  @override
  Stream<List<Reminder>> watchReminders() {
    if (userId == null) return Stream.value([]);

    return _reminders
        .where('userId', isEqualTo: userId)
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
