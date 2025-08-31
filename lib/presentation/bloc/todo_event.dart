part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

//Load Event
class TodoLoadTasksEvent extends TodoEvent {}

//Add Task Event
class TodoAddTaskEvent extends TodoEvent {
  final TaskModel taskModel;
  const TodoAddTaskEvent(this.taskModel);

  @override
  List<Object> get props => [taskModel];
}

//Update Task Event
class TodoUpdateTaskEvent extends TodoEvent {
  final TaskModel task;
  final int index;

  const TodoUpdateTaskEvent(this.task, this.index);

  @override
  List<Object> get props => [task, index];
}

//Event for sync handling
class TodoTasksSyncedEvent extends TodoEvent {
  final List<TaskModel> tasks;
  const TodoTasksSyncedEvent(this.tasks);
}

//Mark as Completed
class TodoMarkCompletedEvent extends TodoEvent {
  final String id;
  const TodoMarkCompletedEvent(this.id);

  @override
  List<Object> get props => [id];
}

//Delete Task Event
class DeleteTaskEvent extends TodoEvent {
  final int index;
  const DeleteTaskEvent(this.index);

  @override
  List<Object> get props => [index];
}

//Delete All
class DeletAllTasksEvent extends TodoEvent {}
