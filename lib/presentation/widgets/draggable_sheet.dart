import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/domain/entities/task_model.dart';
import 'package:todo_app/features/notifications/cubit/notification_cubit.dart';
import 'package:todo_app/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/presentation/widgets/premuim_textfield.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet>
    with SingleTickerProviderStateMixin {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final titleFocus = FocusNode();
  DateTime? selectedDate;

  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(titleFocus);
    });

    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _buttonScale = CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    titleFocus.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag indicator
                  Center(
                    child: Container(
                      height: 5,
                      width: 50,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  // Title field
                  PremiumTextField(
                    controller: titleController,
                    focusNode: titleFocus,
                    label: "Task title",
                  ),
                  const SizedBox(height: 20),

                  // Description
                  PremiumTextField(
                    controller: descController,
                    label: "Description",
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),

                  // Date Picker
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                    ),
                    icon: const Icon(Icons.date_range),
                    label: const Text("Select Due Date"),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                  ),

                  if (selectedDate != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      "Selected date: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),

                  // Save button with scaling animation
                  ScaleTransition(
                    scale: _buttonScale,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 6,
                      ),
                      onPressed: () async {
                        _buttonAnimationController.forward().then(
                          (_) => _buttonAnimationController.reverse(),
                        );

                        final taskId = DateTime.now().toIso8601String();
                        log("🆕 Creating new task with id=$taskId");
                        final title = titleController.text.trim();
                        final desc = descController.text.trim();
                        if (title.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Title cannot be empty"),
                            ),
                          );
                          return;
                        }

                        final task = TaskModel(
                          id: taskId,
                          title: title,
                          description: desc.isEmpty ? "No description" : desc,
                          createdAt: DateTime.now(),
                          dueDate: selectedDate,
                        );
                        context.read<TodoBloc>().add(TodoAddTaskEvent(task));
                        if (task.dueDate != null) {
                          context.read<NotificationCubit>().scheduleTask(task);
                        }
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Save Task",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
