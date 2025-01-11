class Reminder {
  final int? id;
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

  Reminder({
    this.id,
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
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Reminder copyWith({
    int? id,
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
  }) {
    return Reminder(
      id: id ?? this.id,
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
    );
  }
}
