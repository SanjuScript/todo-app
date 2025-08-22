import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/domain/entities/task_model.dart';
import 'package:todo_app/presentation/bloc/todo_bloc.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Tasks")),
      body: BlocBuilder<TodoBloc, TodoState>(
        
        builder: (context, state) {
          if (state is TodoLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description! ?? ''),
                );
              },
            );
          } else {
            return Center(child: Text("No tasks yet"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TodoBloc>().add(
            TodoAddTaskEvent(
              TaskModel(
                id: "hisudbfosdinf",
                title: "New Task",
                description: "This is a test",
                createdAt: DateTime.now(),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
