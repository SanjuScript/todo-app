import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/domain/entities/task_model.dart';
import 'package:todo_app/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/presentation/widgets/premuim_textfield.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final titleFocus = FocusNode();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(titleFocus);
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descController.dispose();
    titleFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return InkWell(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 40,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  PremiumTextField(
                    controller: titleController,
                    focusNode: titleFocus,
                    label: "Task title",
                  ),
                  const SizedBox(height: 16),
                  PremiumTextField(
                    controller: descController,
                    label: "Description",
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    icon: const Icon(Icons.date_range),
                    label: const Text("Pick Date"),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              
                              textTheme: Theme.of(context).textTheme.copyWith(

                                bodyLarge: TextStyle(
                                  color: Colors.black,
                                ), // typed date text
                                bodyMedium: TextStyle(
                                  color: Colors.black,
                                ), // fallback
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                  ),
                  if (selectedDate != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      "Selected date: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
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
                      context.read<TodoBloc>().add(
                        TodoAddTaskEvent(
                          TaskModel(
                            id: DateTime.now().toIso8601String(),
                            title: title,
                            description: desc.isEmpty ? "No description" : desc,
                            createdAt: DateTime.now(),
                            dueDate: selectedDate,
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("Save Task"),
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
