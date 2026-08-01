class SymptomModel {
  final int? symptomId;
  final int userId;
  final DateTime date;
  final int? painLevel; // 0-5
  final String? mood;
  final bool acne;
  final bool hairFall;
  final bool cramps;
  final String? notes;

  SymptomModel({
    this.symptomId,
    required this.userId,
    required this.date,
    this.painLevel,
    this.mood,
    this.acne = false,
    this.hairFall = false,
    this.cramps = false,
    this.notes,
  });

  factory SymptomModel.fromJson(Map<String, dynamic> json) {
    return SymptomModel(
      symptomId: json['symptom_id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      painLevel: json['pain_level'],
      mood: json['mood'],
      acne: json['acne'] ?? false,
      hairFall: json['hair_fall'] ?? false,
      cramps: json['cramps'] ?? false,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'date':
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'pain_level': painLevel,
      'mood': mood,
      'acne': acne,
      'hair_fall': hairFall,
      'cramps': cramps,
      'notes': notes,
    };
  }
}
