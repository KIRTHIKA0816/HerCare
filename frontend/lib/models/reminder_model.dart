class ReminderModel {
  final int? reminderId;
  final int userId;
  final String reminderType; // Period, Water, Exercise, Medicine
  final DateTime reminderDate;
  final String status; // Pending, Completed, Cancelled

  ReminderModel({
    this.reminderId,
    required this.userId,
    required this.reminderType,
    required this.reminderDate,
    this.status = 'Pending',
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      reminderId: json['reminder_id'],
      userId: json['user_id'],
      reminderType: json['reminder_type'],
      reminderDate: DateTime.parse(json['reminder_date']),
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'reminder_type': reminderType,
      'reminder_date':
          '${reminderDate.year.toString().padLeft(4, '0')}-${reminderDate.month.toString().padLeft(2, '0')}-${reminderDate.day.toString().padLeft(2, '0')}',
      'status': status,
    };
  }
}
