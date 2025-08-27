part of 'todo_bloc.dart';

sealed class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

//Initial state
final class TodoInitial extends TodoState {}

//Loading state
final class TodoLoading extends TodoState {}

//Loaded state
final class TodoLoaded extends TodoState {
  final List<TaskModel> alltasks;
  final List<TaskModel> upcomingTasks;
  final List<TaskModel> completedTasks;

  const TodoLoaded(this.alltasks, this.upcomingTasks, this.completedTasks);

  @override
  List<Object> get props => [alltasks, upcomingTasks, completedTasks];
}

//Todo error
final class TodoError extends TodoState {
  final String errorMsg;
  const TodoError(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}
