import 'package:flutter/material.dart';
import 'package:todo_app/features/domain/entities/task_model.dart';

class TodoTile extends StatelessWidget {
  final TaskModel task;
  final Color bgColor;
  const TodoTile({super.key, required this.task, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.punch_clock_rounded),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    task.description ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    task.createdAt.toLocal().toString() ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(task.isCompleted ? Icons.done : Icons.pending_actions),
            ),
          ],
        ),
      ),
    );
  }
}
