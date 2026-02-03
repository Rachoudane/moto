import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:permission_handler/permission_handler.dart';
import '../models/habit.dart';
import 'reminder_messages.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz_data.initializeTimeZones();

    // Set local timezone
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  static Future<bool> requestPermission() async {
    final notifStatus = await Permission.notification.request();
    return notifStatus.isGranted;
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

    await _notifications.zonedSchedule(
      habit.id.hashCode,
      'Moto 元',
      ReminderMessages.getContextualMessage(habit: habit, locale: locale),
      scheduledDate,
      NotificationDetails(
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
            ReminderMessages.getContextualMessage(habit: habit, locale: locale),
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
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
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
    await _notifications.cancel(habitId.hashCode);
  }

  static Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }
}
