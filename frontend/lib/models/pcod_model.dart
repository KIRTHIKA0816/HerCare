class PcodModel {
  final int? pcodId;
  final int userId;
  final DateTime date;
  final double? weightChange;
  final double? sleepHours;
  final int? stressLevel; // 1-5
  final bool exerciseDone;
  final int? waterIntake; // glasses

  PcodModel({
    this.pcodId,
    required this.userId,
    required this.date,
    this.weightChange,
    this.sleepHours,
    this.stressLevel,
    this.exerciseDone = false,
    this.waterIntake,
  });

  factory PcodModel.fromJson(Map<String, dynamic> json) {
    return PcodModel(
      pcodId: json['pcod_id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      weightChange: (json['weight_change'] as num?)?.toDouble(),
      sleepHours: (json['sleep_hours'] as num?)?.toDouble(),
      stressLevel: json['stress_level'],
      exerciseDone: json['exercise_done'] ?? false,
      waterIntake: json['water_intake'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'date':
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'weight_change': weightChange,
      'sleep_hours': sleepHours,
      'stress_level': stressLevel,
      'exercise_done': exerciseDone,
      'water_intake': waterIntake,
    };
  }
}
