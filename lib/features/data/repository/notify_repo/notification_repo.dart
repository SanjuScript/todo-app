abstract class NotificationRepository {
  Future<void> init();
  Future<void> requestPermission();
  Future<void> scheduleTaskReminders({
    required int taskId,
    required String title,
    required DateTime dueDate,
    required String realTaskId,
  });
  Future<void> cancelTaskReminders(int taskId);
  Future<void> showAchievementNotification(int completedTasks);
}
