import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:todo_app/features/data/mapper/task_mapper.dart';
import 'package:todo_app/features/data/model/hive_task.dart';
import 'package:todo_app/features/data/repository/task_repo.dart';

import '../../domain/entities/task_model.dart';

class TaskRepository implements TaskRepo {
  //TaskBox
  final Box<HiveTask> taskBox = Hive.box('tasksBox');

  //Add Tasks
  @override
  Future<void> addTask(TaskModel task) async {
    final hiveTask = TaskMapper.toHive(task);
    log(
      "Looking for taskId=${hiveTask.id} in Hive: "
      "all=${taskBox.values.map((t) => t.id).toList()}",
    );

    await taskBox.add(hiveTask);
  }

  //Get All Tasks
  @override
  Future<List<TaskModel>> getTasks() async {
    return taskBox.values.map(TaskMapper.fromHive).toList();
  }

  // Update Task
  @override
  Future<void> updateTask(int index, TaskModel updatedTask) async {
    final hiveTask = TaskMapper.toHive(updatedTask);
    await taskBox.putAt(index, hiveTask);
  }

  //watch tasks
  @override
  Stream<List<TaskModel>> watchTasks() {
    return taskBox.watch().map((_) => getTasksSync());
  }

  //get tasks without future
  @override
  List<TaskModel> getTasksSync() {
    return taskBox.values.map(TaskMapper.fromHive).toList();
  }

@override
  Future<void> markTaskCompletedById(String taskId) async {
    final index = taskBox.values.toList().indexWhere(
      (task) => task.id.toString() == taskId,
    );

    if (index != -1) {
      final hiveTask = taskBox.getAt(index);
      if (hiveTask != null) {
        final updatedTask = TaskMapper.fromHive(hiveTask);
        final tasks = updatedTask.copyWith(isCompleted: true);
        final ftasks = TaskMapper.toHive(tasks);
        await taskBox.putAt(index, ftasks);
      }
    } else {
      log(
        "❌ Task with id=$taskId not found in Hive. Available: "
        "${taskBox.values.map((t) => t.id).toList()}",
      );
    }
  }

  @override
  Future<void> markTaskCompletedByIdBackground(String taskId) async {
    final index = taskBox.values.toList().indexWhere(
      (task) => task.id == taskId,
    );
    if (index != -1) {
      final hiveTask = taskBox.getAt(index);
      if (hiveTask != null) {
        final updatedTask = TaskMapper.toHive(
          TaskMapper.fromHive(
            hiveTask,
          ).copyWith(isCompleted: true, completedAt: DateTime.now()),
        );
        await taskBox.putAt(index, updatedTask);

        await taskBox.putAt(index, updatedTask);
        log(name:"Title",updatedTask.title);
        log(name:"id",taskId);
      }
    }
  }

  //Delete Task
  @override
  Future<void> deleteTask(int index) async {
    await taskBox.deleteAt(index);
  }

  //Delete All Tasks
  @override
  Future<void> deleteAllTasks() async {
    await taskBox.clear();
  }
}
