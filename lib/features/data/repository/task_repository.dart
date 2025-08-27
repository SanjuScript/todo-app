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

  //Delete All Tasks
  @override
  Future<void> deleteAllTasks() async {
    await taskBox.clear();
  }
}
