import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';
  static const List<String> supportedLanguages = ['en', 'fr', 'ja'];

  /// Get the language to use:
  /// 1. If user has explicitly chosen → use that
  /// 2. Otherwise → use device language
  /// 3. If device language not supported → fallback to 'en'
  static Future<String> getSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if user has explicitly chosen a language
    if (prefs.containsKey(_languageKey)) {
      return prefs.getString(_languageKey)!;
    }

    // No user choice - use device language
    return _getDeviceLanguage();
  }

  /// Check if user has explicitly chosen a language
  static Future<bool> hasUserChosenLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_languageKey);
  }

  /// Get device language, fallback to 'en' if not supported
  static String _getDeviceLanguage() {
    // Get device locale
    final deviceLocale = PlatformDispatcher.instance.locale;
    final deviceLanguage = deviceLocale.languageCode;

    // Check if supported
    if (supportedLanguages.contains(deviceLanguage)) {
      return deviceLanguage;
    }

    // Fallback to English
    return 'en';
  }

  /// Save user's explicit language choice
  static Future<void> setSelectedLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  /// Clear user's language choice (will revert to device language)
  static Future<void> clearLanguageChoice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_languageKey);
  }
}
