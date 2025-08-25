import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/domain/entities/task_model.dart';
import 'package:todo_app/presentation/bloc/todo_bloc.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.teal.shade300,
      Colors.deepPurple.shade300,
      Colors.orange.shade300,
      Colors.pink.shade300,
      Colors.indigo.shade300,
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: const Text(
          "My Tasks",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            if (state.tasks.isEmpty) {
              return const Center(
                child: Text(
                  "No tasks yet 🎉",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                final bgColor = colors[index % colors.length];

                return Card(
                  color: bgColor,
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      task.description ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.check_circle_outline,
                          color: Colors.white),
                      onPressed: () {
                        // mark task complete
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Something went wrong!"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: () {
          context.read<TodoBloc>().add(
                TodoAddTaskEvent(
                  TaskModel(
                    id: DateTime.now().toIso8601String(),
                    title: "New Task",
                    description: "This is a test",
                    createdAt: DateTime.now(),
                  ),
                ),
              );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
      ),
    );
  }
}
