class FoodModel {
  final int? foodId;
  final int userId;
  final DateTime date;
  final String mealType; // Breakfast, Lunch, Dinner, Snack
  final String? description;

  FoodModel({
    this.foodId,
    required this.userId,
    required this.date,
    required this.mealType,
    this.description,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      foodId: json['food_id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      mealType: json['meal_type'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'date':
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'meal_type': mealType,
      'description': description,
    };
  }
}
