import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import 'motivation_service.dart';
import 'reminder_messages.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _quietHoursEnabledKey = 'quiet_hours_enabled';
  static const String _quietHoursStartKey = 'quiet_hours_start_minutes';
  static const String _quietHoursEndKey = 'quiet_hours_end_minutes';
  static const String _dailyQuoteEnabledKey = 'daily_quote_enabled';
  static const int _dailyQuoteNotificationId = 999998;
  static const int dailyQuoteHour = 8;
  static const int dailyQuoteMinute = 0;

  static Future<void> initialize() async {
    tz_data.initializeTimeZones();

    // Set local timezone
    final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const windowsSettings = WindowsInitializationSettings(
      appName: 'Moto',
      appUserModelId: 'Com.Rachoucorp.Moto',
      guid: 'd49b0314-ee7a-4626-bf79-97cdb8a991bb',
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      windows: windowsSettings,
    );

    await _notifications.initialize(settings: settings);
  }

  static Future<bool> requestPermission() async {
    final notifStatus = await Permission.notification.request();
    return notifStatus.isGranted;
  }

  /// Requests the Android 12+ exact-alarm permission. Returns true if exact
  /// scheduling is available (already granted, not required on this
  /// platform/API level, or successfully granted).
  static Future<bool> requestExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (status.isGranted || status.isLimited) return true;
    final result = await Permission.scheduleExactAlarm.request();
    return result.isGranted;
  }

  static Future<void> setQuietHours({
    required bool enabled,
    required int startMinutes,
    required int endMinutes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_quietHoursEnabledKey, enabled);
    await prefs.setInt(_quietHoursStartKey, startMinutes);
    await prefs.setInt(_quietHoursEndKey, endMinutes);
  }

  static Future<(bool enabled, int startMinutes, int endMinutes)>
      getQuietHours() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      prefs.getBool(_quietHoursEnabledKey) ?? false,
      prefs.getInt(_quietHoursStartKey) ?? 22 * 60,
      prefs.getInt(_quietHoursEndKey) ?? 7 * 60,
    );
  }

  /// Free for everyone (unlike per-habit reminders, which are Pro-gated),
  /// defaults to on.
  static Future<bool> isDailyQuoteEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_dailyQuoteEnabledKey) ?? true;
  }

  static Future<void> setDailyQuoteEnabled(bool enabled, String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dailyQuoteEnabledKey, enabled);
    if (enabled) {
      await scheduleDailyQuoteNotification(locale);
    } else {
      await _notifications.cancel(id: _dailyQuoteNotificationId);
    }
  }

  /// Schedules tomorrow's (or today's, if not yet past) quote notification
  /// at a fixed daily time, pre-computed from the deterministic quote
  /// calendar. Not a recurring OS-level alarm — the content is fixed at
  /// schedule time, so this should be called again on every app launch
  /// (and after any relevant setting change) to keep the upcoming quote
  /// fresh. If the app isn't opened for several days, the same quote will
  /// keep repeating each morning until the app is reopened.
  static Future<void> scheduleDailyQuoteNotification(String locale) async {
    await _notifications.cancel(id: _dailyQuoteNotificationId);

    if (!await isDailyQuoteEnabled()) return;

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      dailyQuoteHour,
      dailyQuoteMinute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final quote = MotivationService.getQuoteForDate(scheduledDate, locale);
    final exactAvailable = await requestExactAlarmPermission();

    await _notifications.zonedSchedule(
      id: _dailyQuoteNotificationId,
      title: '元 Moto',
      body: quote,
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_quote',
          'Daily Quote',
          channelDescription: 'A daily motivational quote',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          color: const Color(0xFF7DD3A8),
          colorized: true,
          styleInformation: BigTextStyleInformation(
            quote,
            contentTitle: '元 Moto',
          ),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
      ),
      androidScheduleMode: exactAvailable
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// Shifts a scheduled time to the end of quiet hours if it falls inside
  /// the configured quiet window. Handles windows that wrap past midnight.
  static tz.TZDateTime _applyQuietHours(
    tz.TZDateTime scheduledDate,
    bool enabled,
    int startMinutes,
    int endMinutes,
  ) {
    if (!enabled) return scheduledDate;
    final minutesOfDay = scheduledDate.hour * 60 + scheduledDate.minute;

    bool inQuietWindow;
    if (startMinutes <= endMinutes) {
      inQuietWindow = minutesOfDay >= startMinutes && minutesOfDay < endMinutes;
    } else {
      // Wraps past midnight (e.g. 22:00 -> 07:00)
      inQuietWindow = minutesOfDay >= startMinutes || minutesOfDay < endMinutes;
    }
    if (!inQuietWindow) return scheduledDate;

    var shifted = tz.TZDateTime(
      tz.local,
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      endMinutes ~/ 60,
      endMinutes % 60,
    );
    if (startMinutes > endMinutes && minutesOfDay >= startMinutes) {
      // Quiet window started tonight and ends tomorrow morning
      shifted = shifted.add(const Duration(days: 1));
    }
    return shifted;
  }

  static Future<void> scheduleHabitReminder({
    required Habit habit,
    required int hour,
    required int minute,
    String locale = 'en',
  }) async {
    await cancelHabitReminder(habit.id);

    // Don't schedule if already validated today
    if (habit.isValidatedToday) {
      return;
    }

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Skip rest days: roll forward to the next day this habit is scheduled on
    while (!habit.isScheduledDay(scheduledDate)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final (quietEnabled, quietStart, quietEnd) = await getQuietHours();
    scheduledDate =
        _applyQuietHours(scheduledDate, quietEnabled, quietStart, quietEnd);

    final message =
        ReminderMessages.getContextualMessage(habit: habit, locale: locale);
    final exactAvailable = await requestExactAlarmPermission();

    await _notifications.zonedSchedule(
      id: habit.id.hashCode,
      title: 'Moto 元',
      body: message,
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_reminders',
          'Habit Reminders',
          channelDescription: 'Daily reminders for your habits',
          importance: Importance.high,
          priority: Priority.high,
          color: const Color(0xFF7DD3A8),
          colorized: true,
          category: AndroidNotificationCategory.reminder,
          autoCancel: false,
          styleInformation: BigTextStyleInformation(
            message,
            contentTitle: 'Moto 元',
            summaryText: habit.name,
          ),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: exactAvailable
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// Reschedule all habit reminders (call on app start and after validation)
  static Future<void> rescheduleAllReminders(List<Habit> habits, String locale) async {
    for (final habit in habits) {
      if (habit.reminderEnabled && habit.reminderHour != null && habit.reminderMinute != null) {
        await scheduleHabitReminder(
          habit: habit,
          hour: habit.reminderHour!,
          minute: habit.reminderMinute!,
          locale: locale,
        );
      }
    }
  }

  static Future<void> cancelHabitReminder(String habitId) async {
    await _notifications.cancel(id: habitId.hashCode);
  }

  static Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }

  /// Fires an immediate test notification so users can verify their
  /// permissions/settings are working correctly.
  static Future<void> sendTestNotification(String message) async {
    await _notifications.show(
      id: 999999,
      title: 'Moto 元',
      body: message,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_reminders',
          'Habit Reminders',
          channelDescription: 'Daily reminders for your habits',
          importance: Importance.high,
          priority: Priority.high,
          color: const Color(0xFF7DD3A8),
          colorized: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}
