import 'package:todo_app/features/domain/entities/task_model.dart';

abstract class TaskRepo {
  Future<void> addTask(TaskModel task);
  Future<List<TaskModel>> getTasks();
  Future<void> updateTask(int index, TaskModel updatedTask);
  Future<void> deleteTask(int index);
  Future<void> markTaskCompletedById(String taskId);
  Future<void> deleteAllTasks();
  Future<void> markTaskCompletedByIdBackground(String taskId);
  List<TaskModel> getTasksSync();
  Stream<List<TaskModel>> watchTasks();
}
