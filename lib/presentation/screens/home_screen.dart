import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/domain/entities/task_model.dart';
import 'package:todo_app/features/helper/color_helper.dart';
import 'package:todo_app/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/presentation/widgets/todo_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<ScaffoldState>();
    final sz = MediaQuery.sizeOf(context);
    return Scaffold(
      key: _key,
      drawer: Drawer(),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: false,
                snap: true,
                expandedHeight: sz.height * .06,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<TodoBloc>().add(DeletAllTasksEvent());
                    },
                  ),
                ],
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    _key.currentState?.openDrawer();
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  title: const Text(
                    "My Tasks",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (state is TodoLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is TodoLoaded && state.tasks.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "No tasks yet",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              else if (state is TodoLoaded)
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final task = state.tasks[index];
                    final bgColor =
                        ColorHelper.colors[index % ColorHelper.colors.length];

                    return TodoTile(task: task, bgColor: bgColor);
                  }, childCount: state.tasks.length),
                )
              else
                const SliverFillRemaining(
                  child: Center(child: Text("Something went wrong!")),
                ),
            ],
          );
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
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Task"),
      ),
    );
  }
}
