import 'package:todo_app/features/data/model/hive_task.dart';
import 'package:todo_app/features/domain/entities/task_model.dart';

class TaskMapper {
  static TaskModel fromHive(HiveTask hiveTask) {
    return TaskModel(
      id: hiveTask.id,
      title: hiveTask.title,
      description: hiveTask.description,
      isCompleted: hiveTask.isCompleted,
      createdAt: hiveTask.createdAt,
      dueDate: hiveTask.dueDate,
      completedAt: hiveTask.completedAt,
    );
  }

  static HiveTask toHive(TaskModel task) {
    return HiveTask(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      dueDate: task.dueDate,
      completedAt: task.completedAt,
    );
  }
}
