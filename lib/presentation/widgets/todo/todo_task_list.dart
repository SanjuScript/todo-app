import 'package:flutter/material.dart';
import 'package:todo_app/features/domain/entities/task_model.dart';
import 'package:todo_app/features/helper/color_helper.dart';
import 'package:todo_app/presentation/widgets/todo/todo_tile.dart';

class TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  final bool showCompletedDate;

  const TaskList({
    super.key,
    required this.tasks,
    this.showCompletedDate = false,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          "No tasks yet",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 12),
      itemCount: tasks.length + 1,
      itemBuilder: (context, index) {
        if (index == tasks.length) {
          return SizedBox(height: 60);
        }
        final task = tasks[index];
        final bgColor = ColorHelper.colors[index % ColorHelper.colors.length];
        return TodoTile(
          task: task,
          bgColor: bgColor,
          showCompletedDate: showCompletedDate,
        );
      },
    );
  }
}
