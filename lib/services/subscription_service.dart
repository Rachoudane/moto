import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService {
  static const String _isProKey = 'is_pro';
  static const String _lastVerifiedAtKey = 'pro_last_verified_at';
  static const String _downgradeNoticeKey = 'pro_downgrade_notice_pending';
  static const String _promoCardDismissedAtKey = 'pro_promo_dismissed_at';
  static const int freeHabitLimit = 3;
  static const int freeHistoryDays = 7;
  static const Duration promoCardCooldown = Duration(days: 14);

  static Future<bool> isPro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isProKey) ?? false;
  }

  static Future<void> setPro(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isProKey, value);
  }

  /// Timestamp of the last time the store confirmed an active Pro
  /// entitlement (via purchase or restore). Used as the basis for the
  /// grace period before a best-effort client-side downgrade.
  static Future<DateTime?> getLastVerifiedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final iso = prefs.getString(_lastVerifiedAtKey);
    return iso != null ? DateTime.tryParse(iso) : null;
  }

  static Future<void> recordVerified() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastVerifiedAtKey, DateTime.now().toIso8601String());
  }

  /// Marks that a respectful one-time downgrade notice should be shown on
  /// the next home screen load. All habit data is always preserved.
  static Future<void> flagDowngradeNotice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_downgradeNoticeKey, true);
  }

  static Future<bool> shouldShowDowngradeNotice() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_downgradeNoticeKey) ?? false;
  }

  static Future<void> dismissDowngradeNotice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_downgradeNoticeKey, false);
  }

  /// Whether the dismissible in-feed Pro promo card should currently show
  /// (never for Pro users; respects a cooldown after the user dismisses it).
  static Future<bool> shouldShowPromoCard() async {
    if (await isPro()) return false;
    final prefs = await SharedPreferences.getInstance();
    final iso = prefs.getString(_promoCardDismissedAtKey);
    if (iso == null) return true;
    final dismissedAt = DateTime.tryParse(iso);
    if (dismissedAt == null) return true;
    return DateTime.now().difference(dismissedAt) > promoCardCooldown;
  }

  static Future<void> dismissPromoCard() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_promoCardDismissedAtKey, DateTime.now().toIso8601String());
  }
}
