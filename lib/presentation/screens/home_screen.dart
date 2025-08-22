import 'package:flutter/material.dart';
import 'package:todo_app/features/data/repository/task_repository.dart';
import 'package:todo_app/features/domain/entities/task_model.dart';
import 'package:todo_app/presentation/screens/task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(controller: controller),
          ElevatedButton(
            onPressed: () {
              final task = TaskRepository();
              // TaskModel taskModel = TaskModel(
              //   id: "iuisfb",
              //   title: controller.text.trim(),
              //   description: "Hi enthellada kutta",
              //   createdAt: DateTime.now(),
              // );
              // task.addTask(taskModel);
              task.getTasks().then((onValue) {
                print(onValue.toList());
              });
            },
            child: Text("Add"),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskScreen()),
          );
        },
        child: Icon(Icons.golf_course),
      ),
    );
  }
}
