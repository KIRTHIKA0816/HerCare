class WaterLogModel {
  final int? waterId;
  final int userId;
  final DateTime date;
  final int glasses;
  final int goal;

  WaterLogModel({
    this.waterId,
    required this.userId,
    required this.date,
    this.glasses = 0,
    this.goal = 8,
  });

  factory WaterLogModel.fromJson(Map<String, dynamic> json) {
    return WaterLogModel(
      waterId: json['water_id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      glasses: json['glasses'] ?? 0,
      goal: json['goal'] ?? 8,
    );
  }
}
