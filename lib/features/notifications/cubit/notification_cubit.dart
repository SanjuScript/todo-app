import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/data/repository/notify_repo/notification_repo.dart';
import 'package:todo_app/features/domain/entities/task_model.dart';
import 'package:todo_app/features/helper/id_getter.dart';

class NotificationCubit extends Cubit<void> {
  final NotificationRepository notificationRepository;

  NotificationCubit(this.notificationRepository) : super(null);

  Future<void> init() async {
    await notificationRepository.init();
    await notificationRepository.requestPermission();
  }

  Future<void> scheduleTask(TaskModel task) async {
    final int notID = normalizeId(task.id);
    await notificationRepository.scheduleTaskReminders(
      taskId: notID,
      title: task.title,
      realTaskId: task.id,
      dueDate: task.dueDate ?? DateTime.now(),
    );
  }

  Future<void> cancelTask(String id) async {
    final int notID = normalizeId(id);
    await notificationRepository.cancelTaskReminders(notID);
  }

  Future<void> checkAchievements(int completedTasks) async {
    await notificationRepository.showAchievementNotification(completedTasks);
  }
}
