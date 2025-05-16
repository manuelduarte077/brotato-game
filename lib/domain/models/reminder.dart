class Reminder {
  final int? id;
  final String? userId;
  final String title;
  final String? description;
  final double amount;
  final DateTime dueDate;
  final String category;
  final bool isRecurring;
  final String? recurrenceType;
  final int? recurrenceInterval;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  Reminder({
    this.id,
    this.userId,
    required this.title,
    this.description,
    required this.amount,
    required this.dueDate,
    required this.category,
    this.isRecurring = false,
    this.recurrenceType,
    this.recurrenceInterval,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isSynced = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Reminder copyWith({
    int? id,
    String? userId,
    String? title,
    String? description,
    double? amount,
    DateTime? dueDate,
    String? category,
    bool? isRecurring,
    String? recurrenceType,
    int? recurrenceInterval,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return Reminder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
