class PeriodModel {
  final int? periodId;
  final int userId;
  final DateTime startDate;
  final DateTime? endDate;
  final int cycleLength;
  final String flowLevel; // Light, Medium, Heavy

  PeriodModel({
    this.periodId,
    required this.userId,
    required this.startDate,
    this.endDate,
    this.cycleLength = 28,
    this.flowLevel = 'Medium',
  });

  factory PeriodModel.fromJson(Map<String, dynamic> json) {
    return PeriodModel(
      periodId: json['period_id'],
      userId: json['user_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      cycleLength: json['cycle_length'] ?? 28,
      flowLevel: json['flow_level'] ?? 'Medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'start_date': _formatDate(startDate),
      'end_date': endDate != null ? _formatDate(endDate!) : null,
      'cycle_length': cycleLength,
      'flow_level': flowLevel,
    };
  }

  static String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
