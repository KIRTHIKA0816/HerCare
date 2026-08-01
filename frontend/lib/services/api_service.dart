import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/period_model.dart';
import '../models/symptom_model.dart';
import '../models/pcod_model.dart';
import '../models/reminder_model.dart';
import '../models/food_model.dart';
import '../models/water_model.dart';

class ApiService {
  // Change to your deployed backend URL.
  // Use 10.0.2.2 for Android emulator, your machine's LAN IP for a physical device.
  static const String baseUrl = 'http://127.0.0.1:5000/api';

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
      };

  // ---------------- AUTH / USER ----------------
  static Future<UserModel?> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 200) return UserModel.fromJson(jsonDecode(res.body));
    return null;
  }

  static Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
    int? age,
    double? height,
    double? weight,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'age': age,
        'height': height,
        'weight': weight,
      }),
    );
    if (res.statusCode == 201) return UserModel.fromJson(jsonDecode(res.body));
    return null;
  }

  static Future<UserModel?> updateProfile(int userId, Map<String, dynamic> fields) async {
    final res = await http.put(
      Uri.parse('$baseUrl/users/$userId'),
      headers: _headers,
      body: jsonEncode(fields),
    );
    if (res.statusCode == 200) return UserModel.fromJson(jsonDecode(res.body));
    return null;
  }

  // ---------------- PERIODS ----------------
  static Future<List<PeriodModel>> getPeriods(int userId) async {
    final res = await http.get(Uri.parse('$baseUrl/periods/$userId'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => PeriodModel.fromJson(e)).toList();
    }
    return [];
  }

  static Future<bool> addPeriod(PeriodModel period) async {
    final res = await http.post(
      Uri.parse('$baseUrl/periods'),
      headers: _headers,
      body: jsonEncode(period.toJson()),
    );
    return res.statusCode == 201;
  }

  static Future<Map<String, dynamic>?> predictNextPeriod(int userId) async {
    final res = await http.get(Uri.parse('$baseUrl/periods/predict/$userId'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    return null;
  }

  // ---------------- SYMPTOMS ----------------
  static Future<List<SymptomModel>> getSymptoms(int userId) async {
    final res = await http.get(Uri.parse('$baseUrl/symptoms/$userId'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => SymptomModel.fromJson(e)).toList();
    }
    return [];
  }

  static Future<bool> addSymptom(SymptomModel symptom) async {
    final res = await http.post(
      Uri.parse('$baseUrl/symptoms'),
      headers: _headers,
      body: jsonEncode(symptom.toJson()),
    );
    return res.statusCode == 201;
  }

  // ---------------- PCOD ----------------
  static Future<List<PcodModel>> getPcodEntries(int userId) async {
    final res = await http.get(Uri.parse('$baseUrl/pcod/$userId'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => PcodModel.fromJson(e)).toList();
    }
    return [];
  }

  static Future<bool> addPcodEntry(PcodModel entry) async {
    final res = await http.post(
      Uri.parse('$baseUrl/pcod'),
      headers: _headers,
      body: jsonEncode(entry.toJson()),
    );
    return res.statusCode == 201;
  }

  static Future<Map<String, dynamic>?> getPcodSummary(int userId) async {
    final res = await http.get(Uri.parse('$baseUrl/pcod/summary/$userId'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    return null;
  }

  // ---------------- REMINDERS ----------------
  static Future<List<ReminderModel>> getReminders(int userId) async {
    final res = await http.get(Uri.parse('$baseUrl/reminders/$userId'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => ReminderModel.fromJson(e)).toList();
    }
    return [];
  }

  static Future<bool> addReminder(ReminderModel reminder) async {
    final res = await http.post(
      Uri.parse('$baseUrl/reminders'),
      headers: _headers,
      body: jsonEncode(reminder.toJson()),
    );
    return res.statusCode == 201;
  }

  static Future<bool> updateReminderStatus(int reminderId, String status) async {
    final res = await http.put(
      Uri.parse('$baseUrl/reminders/$reminderId'),
      headers: _headers,
      body: jsonEncode({'status': status}),
    );
    return res.statusCode == 200;
  }

  static Future<bool> deleteReminder(int reminderId) async {
    final res = await http.delete(Uri.parse('$baseUrl/reminders/$reminderId'));
    return res.statusCode == 200;
  }

  // ---------------- FOOD / NUTRITION ----------------
  static Future<List<FoodModel>> getFoodEntries(int userId) async {
    final res = await http.get(Uri.parse('$baseUrl/food/$userId'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => FoodModel.fromJson(e)).toList();
    }
    return [];
  }

  static Future<bool> addFoodEntry(FoodModel entry) async {
    final res = await http.post(
      Uri.parse('$baseUrl/food'),
      headers: _headers,
      body: jsonEncode(entry.toJson()),
    );
    return res.statusCode == 201;
  }

  // ---------------- WATER INTAKE ----------------
  static Future<WaterLogModel?> getTodayWater(int userId) async {
    final res = await http.get(Uri.parse('$baseUrl/water/$userId/today'));
    if (res.statusCode == 200) return WaterLogModel.fromJson(jsonDecode(res.body));
    return null;
  }

  static Future<WaterLogModel?> addWater(int userId, int amount) async {
    final res = await http.post(
      Uri.parse('$baseUrl/water/$userId/add'),
      headers: _headers,
      body: jsonEncode({'amount': amount}),
    );
    if (res.statusCode == 200) return WaterLogModel.fromJson(jsonDecode(res.body));
    return null;
  }

  static Future<WaterLogModel?> updateWaterGoal(int userId, int goal) async {
    final res = await http.put(
      Uri.parse('$baseUrl/water/$userId/goal'),
      headers: _headers,
      body: jsonEncode({'goal': goal}),
    );
    if (res.statusCode == 200) return WaterLogModel.fromJson(jsonDecode(res.body));
    return null;
  }

  static Future<List<WaterLogModel>> getWaterHistory(int userId) async {
    final res = await http.get(Uri.parse('$baseUrl/water/$userId/history'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => WaterLogModel.fromJson(e)).toList();
    }
    return [];
  }
}
