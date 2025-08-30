import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app/features/data/repository/notify_repo/notification_repo.dart';
import 'package:todo_app/features/data/repository/task_repository.dart';
import 'package:todo_app/features/helper/id_getter.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final TaskRepository taskRepository = TaskRepository();
  int _safeId(int id) => id & 0x7FFFFFFF;
  bool _initialized = false;

  @override
  Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) async {
        if (response.actionId == 'MARK_DONE') {
          final taskId = response.payload;
          log(taskId.toString());
          if (taskId != null) {
            await taskRepository.markTaskCompletedById(taskId);
          }
          flutterLocalNotificationsPlugin.cancel(response.id ?? 0);
        } else if (response.actionId == 'DISMISS') {
          flutterLocalNotificationsPlugin.cancel(response.id ?? 0);
        }
      },
    );
    _initialized = true;
  }

  @override
  Future<void> requestPermission() async {
    // 🔹 Android 13+ needs runtime permission
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.requestExactAlarmsPermission();
  }

  @override
  Future<void> scheduleTaskReminders({
    required int taskId,
    required String title,
    required DateTime dueDate,
    required String realTaskId,
  }) async {
    // Notify before (30 mins)
    await _scheduleNotification(
      id: taskId * 10,
      title: 'Task Reminder',
      body: '$title is due soon!',
      dateTime: dueDate.subtract(const Duration(minutes: 30)),
      testMode: true,
      taskIdPayload: realTaskId,
    );

    // At due time
    await _scheduleNotification(
      id: taskId * 10 + 1,
      title: 'Task Due',
      body: 'It’s time to do: $title',
      dateTime: dueDate,
      taskIdPayload: realTaskId,
    );

    // After due (1 hr later)
    await _scheduleNotification(
      id: taskId * 10 + 2,
      title: 'Task Overdue',
      body: '$title is overdue!',

      dateTime: dueDate.add(const Duration(hours: 1)),
      taskIdPayload: realTaskId,
    );
  }

  @override
  Future<void> cancelTaskReminders(int taskId) async {
    await flutterLocalNotificationsPlugin.cancel(_safeId(taskId * 10));
    await flutterLocalNotificationsPlugin.cancel(_safeId(taskId * 10 + 1));
    await flutterLocalNotificationsPlugin.cancel(_safeId(taskId * 10 + 2));
  }

  @override
  Future<void> showAchievementNotification(int completedTasks) async {
    if (completedTasks == 3 || completedTasks == 50 || completedTasks == 100) {
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        '🎉 Achievement!',
        'You completed $completedTasks tasks!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'achievement_channel',
            'Achievements',
            channelDescription: 'Milestones and rewards',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }
  }

  tz.TZDateTime _nextInstanceInSeconds(int seconds) {
    final now = tz.TZDateTime.now(tz.local);
    return now.add(Duration(seconds: seconds));
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    bool testMode = false,
    String? taskIdPayload,
  }) async {
    log("Scheduling notif $id for $dateTime");
    final tz.TZDateTime scheduledDate = testMode
        ? _nextInstanceInSeconds(10)
        : tz.TZDateTime.from(dateTime, tz.local);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      _safeId(id),
      title,
      body,
      scheduledDate,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      payload: taskIdPayload,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Reminders',
          channelDescription: 'Reminders for tasks',
          importance: Importance.high,
          priority: Priority.high,

          actions: [
            AndroidNotificationAction(
              'MARK_DONE',
              'Mark Completed',
              showsUserInterface: true,
            ),
            AndroidNotificationAction(
              'DISMISS',
              'Dismiss',
              showsUserInterface: false,
            ),
          ],
        ),
      ),
    );
  }
}
