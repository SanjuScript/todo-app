import 'package:todo_app/features/domain/entities/task_model.dart';
import 'package:todo_app/presentation/bloc/todo_bloc.dart';

TodoLoaded mapTasksToState(List<TaskModel> tasks) {
  final upcoming = tasks
      .where(
        (t) =>
            t.dueDate != null &&
            t.dueDate!.isAfter(DateTime.now()) &&
            !t.isCompleted,
      )
      .toList();

  final completed = tasks.where((t) => t.isCompleted).toList();

  return TodoLoaded(tasks, upcoming, completed);
}
