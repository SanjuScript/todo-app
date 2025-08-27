import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/features/data/repository/task_repository.dart';
import 'package:todo_app/features/domain/entities/task_model.dart';
import 'package:todo_app/features/helper/todo_task_splitter.dart';
part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TaskRepository taskRepository;
  TodoBloc(this.taskRepository) : super(TodoInitial()) {
    //Load tasks
    on<TodoLoadTasksEvent>((event, emit) async {
      emit(TodoLoading());
      try {
        final tasks = await taskRepository.getTasks();
        emit(mapTasksToState(tasks));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    });

    // Add task
    on<TodoAddTaskEvent>((event, emit) async {
      if (state is TodoLoaded) {
        final currentTasks = List<TaskModel>.from(
          (state as TodoLoaded).alltasks,
        );
        currentTasks.add(event.taskModel);
        emit(mapTasksToState(currentTasks));

        try {
          await taskRepository.addTask(event.taskModel);
        } catch (e) {
          emit(TodoError(e.toString()));
        }
      }
    });

    // Update task
    on<TodoUpdateTaskEvent>((event, emit) async {
      try {
        await taskRepository.updateTask(event.index, event.task);
        final tasks = await taskRepository.getTasks();
        emit(mapTasksToState(tasks));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    });

    //Mark as completed
    on<TodoMarkCompletedEvent>((event, emit) async {
      try {
        final tasks = await taskRepository.getTasks();
        final taskIndex = tasks.indexWhere((t) => t.id == event.id);
        if (taskIndex == -1) return;
        final task = tasks[taskIndex];
        final updateTask = task.copyWith(
          isCompleted: !task.isCompleted,
          completedAt: task.isCompleted ? null : DateTime.now(),
        );

        await taskRepository.updateTask(taskIndex, updateTask);

        final updatedTasks = await taskRepository.getTasks();
        emit(mapTasksToState(updatedTasks));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    });

    // Delete task
    on<DeleteTaskEvent>((event, emit) async {
      try {
        await taskRepository.deleteTask(event.index);
        final tasks = await taskRepository.getTasks();
        emit(mapTasksToState(tasks));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    });

    //Delete tasks
    on<DeletAllTasksEvent>((event, emit) async {
      emit(TodoLoading());
      try {
        await taskRepository.deleteAllTasks();
        emit(mapTasksToState([]));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    });
  }
}
