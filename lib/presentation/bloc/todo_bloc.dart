import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/features/data/repository/task_repository.dart';
import 'package:todo_app/features/domain/entities/task_model.dart';
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
        emit(TodoLoaded(tasks));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    });

    // Add task
    on<TodoAddTaskEvent>((event, emit) async {
      try {
        await taskRepository.addTask(event.taskModel);
        final tasks = await taskRepository.getTasks();
        emit(TodoLoaded(tasks));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    });

    // Update task
    on<TodoUpdateTaskEvent>((event, emit) async {
      try {
        await taskRepository.updateTask(event.index, event.task);
        final tasks = await taskRepository.getTasks();
        emit(TodoLoaded(tasks));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    });

    // Delete task
    on<DeleteTaskEvent>((event, emit) async {
      try {
        await taskRepository.deleteTask(event.index);
        final tasks = await taskRepository.getTasks();
        emit(TodoLoaded(tasks));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    });
  }
}
