import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:permission_handler/permission_handler.dart';
import '../models/habit.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz_data.initializeTimeZones();

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
    final status = await Permission.notification.request();
    return status.isGranted;
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
      _getReminderMessage(habit, locale),
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_reminders',
          'Habit Reminders',
          channelDescription: 'Daily reminders for your habits',
          importance: Importance.high,
          priority: Priority.high,
          color: const Color(0xFF7DD3A8),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
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

  static String _getReminderMessage(Habit habit, String locale) {
    final messages = _getLocalizedMessages(habit.name, locale);
    return messages[DateTime.now().millisecond % messages.length];
  }

  static List<String> _getLocalizedMessages(String habitName, String locale) {
    switch (locale) {
      case 'fr':
        return [
          "C'est l'heure de $habitName !",
          "N'oublie pas : $habitName",
          "Construis ta base : $habitName",
          "Une case de plus : $habitName",
          "$habitName t'attend !",
          "Ta fondation se construit jour après jour",
          "Chaque effort compte pour $habitName",
          "Le moment est venu : $habitName",
          "Continue sur ta lancée !",
          "Un petit pas aujourd'hui, un grand progrès demain",
        ];
      case 'ja':
        return [
          "$habitNameの時間です！",
          "忘れずに：$habitName",
          "基盤を築こう：$habitName",
          "もう一マス：$habitName",
          "$habitNameが待っています！",
          "毎日の積み重ねが大切",
          "$habitNameで自分を磨こう",
          "今がその時：$habitName",
          "継続は力なり",
          "小さな一歩が大きな進歩に",
        ];
      default: // English
        return [
          "Time to work on $habitName!",
          "Don't forget: $habitName",
          "Build your foundation: $habitName",
          "One more square: $habitName",
          "$habitName is waiting for you!",
          "Your foundation grows day by day",
          "Every effort counts for $habitName",
          "Now is the time: $habitName",
          "Keep the momentum going!",
          "A small step today, big progress tomorrow",
        ];
    }
  }

  static Future<void> cancelHabitReminder(String habitId) async {
    await _notifications.cancel(habitId.hashCode);
  }

  static Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }
}
