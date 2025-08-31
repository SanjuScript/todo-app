import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/domain/entities/task_model.dart';
import 'package:todo_app/features/helper/color_helper.dart';
import 'package:todo_app/features/helper/enums.dart';
import 'package:todo_app/presentation/screens/home_screen_changes/cubit/highlight_cubit.dart';
import 'package:todo_app/presentation/widgets/todo/todo_tile.dart';

class TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  final bool showCompletedDate;
  final TaskListType listType;
  const TaskList({
    super.key,
    required this.tasks,
    this.showCompletedDate = false,
    required this.listType,
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
          return const SizedBox(height: 60);
        }

        final task = tasks[index];
        final bgColor = ColorHelper.colors[index % ColorHelper.colors.length];

        return BlocBuilder<HighlightCubit, String?>(
          builder: (context, highlightedId) {
            final isHighlighted =
                listType == TaskListType.completed && highlightedId == task.id;

            return TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              tween: Tween<double>(begin: isHighlighted ? 1.05 : 1.0, end: 1.0),
              onEnd: () {
                if (isHighlighted) {
                  context.read<HighlightCubit>().clear();
                }
              },
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: TodoTile(
                task: task,
                bgColor: bgColor,
                showCompletedDate: showCompletedDate,
              ),
            );
          },
        );
      },
    );
  }
}
