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
  final List<TaskModel> tasks;
  const TodoLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

//Todo error
final class TodoError extends TodoState {
  final String errorMsg;
  const TodoError(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}
