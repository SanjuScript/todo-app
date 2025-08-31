import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/data/repository/task_repository.dart';
import 'package:todo_app/features/domain/entities/task_model.dart';
import 'package:todo_app/features/helper/extensions/date_formating.dart';
import 'package:todo_app/features/notifications/cubit/notification_cubit.dart';
import 'package:todo_app/presentation/bloc/todo_bloc.dart';

class TodoTile extends StatelessWidget {
  final TaskModel task;
  final Color bgColor;
  final bool showCompletedDate;
  final bool buttonFuctionable;

  const TodoTile({
    super.key,
    required this.task,
    required this.bgColor,
    required this.showCompletedDate,
    this.buttonFuctionable = true,
  });

  bool get isOverdue {
    return task.dueDate != null &&
        !task.isCompleted &&
        task.dueDate!.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color effectiveBg = isOverdue
        ? Color.lerp(bgColor, Colors.red.shade100, 0.35)!
        : bgColor;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: bgColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        task.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          decoration: task.isCompleted && !showCompletedDate
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      if (task.description != null &&
                          task.description!.trim().isNotEmpty)
                        Text(
                          task.description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 6),
                      Text(
                        task.dueDate != null
                            ? "Due: ${task.dueDate!.toFormattedString()}"
                            : "Created: ${task.createdAt.toFormattedString()}",
                        style: theme.textTheme.labelSmall?.copyWith(),
                      ),
                      if (showCompletedDate && task.completedAt != null)
                        Text(
                          "Completed on: ${task.completedAt!.toFormattedString()}",
                          style: theme.textTheme.labelSmall?.copyWith(),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: InkWell(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    key: ValueKey(task.isCompleted),
                    onTap: () async {
                      if (!buttonFuctionable) {
                        return;
                      }
                      context.read<TodoBloc>().add(
                        TodoMarkCompletedEvent(task.id),
                      );
                      if (!task.isCompleted) {
                        context.read<NotificationCubit>().cancelTask(task.id);
                      }

                      final state = context.read<TodoBloc>().state;
                      if (state is TodoLoaded) {
                        final completedCount = state.alltasks
                            .where((t) => t.isCompleted)
                            .length;

                        await context
                            .read<NotificationCubit>()
                            .checkAchievements(completedCount);
                      }
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, anim) => ScaleTransition(
                        scale: CurvedAnimation(
                          parent: anim,
                          curve: Curves.easeOutBack,
                        ),
                        child: RotationTransition(
                          turns: Tween<double>(
                            begin: 0.75,
                            end: 1,
                          ).animate(anim),
                          child: child,
                        ),
                      ),
                      child: Container(
                        key: ValueKey(task.isCompleted),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: task.isCompleted
                              ? LinearGradient(
                                  colors: [
                                    Color.lerp(
                                      bgColor,
                                      Colors.red.shade100,
                                      0.35,
                                    )!,
                                    bgColor,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    Color.lerp(
                                      bgColor,
                                      Colors.red.shade100,
                                      0.35,
                                    )!,
                                    bgColor,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          task.isCompleted
                              ? Icons.check_rounded
                              : Icons.circle_outlined,
                          size: 26,
                          color: task.isCompleted
                              ? Colors.white
                              : theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isOverdue)
          Positioned(
            top: 16,
            right: 25,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timelapse_rounded, color: effectiveBg, size: 16),
                const SizedBox(width: 4),
                Text(
                  "Overdue",
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
