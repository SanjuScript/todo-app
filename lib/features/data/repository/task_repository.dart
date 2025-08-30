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
    log("Looking for taskId=${hiveTask.id} in Hive: " 
    "all=${taskBox.values.map((t) => t.id).toList()}");

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

  //Delete Task
  @override
  Future<void> deleteTask(int index) async {
    await taskBox.deleteAt(index);
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
    log("❌ Task with id=$taskId not found in Hive. Available: "
        "${taskBox.values.map((t) => t.id).toList()}");
  }
  }

  //Delete All Tasks
  @override
  Future<void> deleteAllTasks() async {
    await taskBox.clear();
  }
}
