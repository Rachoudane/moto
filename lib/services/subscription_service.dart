import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService {
  static const String _isProKey = 'is_pro';
  static const int freeHabitLimit = 3;
  static const int freeHistoryDays = 7;

  static Future<bool> isPro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isProKey) ?? false;
  }

  static Future<void> setPro(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isProKey, value);
  }

  // For testing purposes - remove in production
  static Future<void> togglePro() async {
    final current = await isPro();
    await setPro(!current);
  }
}
