import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/helper/color_helper.dart';
import 'package:todo_app/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/presentation/widgets/delete_confirm_dialogue.dart';
import 'package:todo_app/presentation/widgets/draggable_sheet.dart';
import 'package:todo_app/presentation/widgets/custom_drawer.dart';
import 'package:todo_app/presentation/widgets/todo_tile.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawer(onItemTap: (item) {}),
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
                      showDialog(
                        context: context,
                        builder: (_) => DeleteConfirmationDialog(
                          onConfirm: () {
                            Navigator.pop(context);
                            context.read<TodoBloc>().add(DeletAllTasksEvent());
                          },
                          onCancel: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ],
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
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
                    child: Text("No tasks yet", style: TextStyle(fontSize: 18)),
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

      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: sz.width * .30,
          child: FloatingActionButton.extended(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.dark(
                        surface: Colors.black87,
                        onSurface: Colors.white,
                      ),
                    ),
                    child: const AddTaskBottomSheet(),
                  );
                },
              );
            },
            label: Text(
              'Add +',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
      ),
    );
  }
}
