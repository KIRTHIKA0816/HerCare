class UserModel {
  final int? userId;
  final String name;
  final String email;
  final int? age;
  final double? height;
  final double? weight;
  final String? createdDate;

  UserModel({
    this.userId,
    required this.name,
    required this.email,
    this.age,
    this.height,
    this.weight,
    this.createdDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      createdDate: json['created_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'age': age,
      'height': height,
      'weight': weight,
    };
  }
}
