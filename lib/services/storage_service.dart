import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

class StorageService {
  static const String _habitsKey = 'habits';

  Future<List<Habit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsJson = prefs.getString(_habitsKey);

    if (habitsJson != null) {
      final List<dynamic> decoded = jsonDecode(habitsJson);
      return decoded.map((h) => Habit.fromJson(h)).toList();
    }

    return [];
  }

  Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(habits.map((h) => h.toJson()).toList());
    await prefs.setString(_habitsKey, encoded);
  }
}
