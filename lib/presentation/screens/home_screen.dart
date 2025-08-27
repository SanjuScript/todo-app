import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/presentation/widgets/delete_confirm_dialogue.dart';
import 'package:todo_app/presentation/widgets/draggable_sheet.dart';
import 'package:todo_app/presentation/widgets/custom_drawer.dart';
import 'package:todo_app/presentation/widgets/todo/todo_task_list.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onDrawerItemTap(String item) {
    switch (item) {
      case "tasks":
        _tabController.animateTo(0);
        break;
      case "upcoming":
        _tabController.animateTo(1);
        break;
      case "completed":
        _tabController.animateTo(2);
        break;
      default:
        break;
    }
    scaffoldKey.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);

    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawer(onItemTap: _onDrawerItemTap),

      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: true,
            expandedHeight: sz.height * .12,

            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
            ),
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
                      onCancel: () => Navigator.pop(context),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: const FlexibleSpaceBar(
              expandedTitleScale: 1,

              title: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  "My Tasks",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              collapseMode: CollapseMode.parallax,
            ),
            bottom: TabBar(
              controller: _tabController,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 4, color: Colors.transparent),
                insets: EdgeInsets.symmetric(horizontal: 16),
              ),
              indicatorWeight: 0,

              labelStyle: Theme.of(context).textTheme.labelMedium,
              unselectedLabelStyle: Theme.of(context).textTheme.headlineSmall,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "All"),
                Tab(text: "Upcoming"),
                Tab(text: "Completed"),
              ],
            ),
          ),
        ],

        body: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is TodoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TodoLoaded) {
              return TabBarView(
                controller: _tabController,
                children: [
                  TaskList(tasks: state.alltasks),
                  TaskList(tasks: state.upcomingTasks),
                  TaskList(
                    tasks: state.completedTasks,
                    showCompletedDate: true,
                  ),
                ],
              );
            } else if (state is TodoLoaded && state.alltasks.isEmpty) {
              return Center(
                child: Text(
                  "No tasks yet",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              );
            } else {
              return Center(
                child: Text(
                  "Something went wrong!",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              );
            }
          },
        ),
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
                      colorScheme: const ColorScheme.dark(
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
