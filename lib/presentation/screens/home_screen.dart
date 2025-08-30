import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/presentation/screens/home_screen_changes/cubit/visibility_cubit.dart';
import 'package:todo_app/presentation/screens/todo_calender.dart';
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
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _addListner();
  }

  void _addListner() {
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        context.read<BottomBarCubit>().hide();
      } else {
        context.read<BottomBarCubit>().show();
      }
    });
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
      extendBody: true,
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

              isScrollable: true,
              tabAlignment: TabAlignment.center,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 4, color: Colors.transparent),
                insets: EdgeInsets.symmetric(horizontal: 16),
              ),
              indicatorWeight: 0,

              labelStyle: Theme.of(context).textTheme.labelMedium,
              unselectedLabelStyle: Theme.of(context).textTheme.headlineSmall,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "Calendar"),
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
                  TodoCalendar(),
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

      bottomNavigationBar: BlocBuilder<BottomBarCubit, bool>(
        builder: (context, isVisible) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isVisible ? 1.0 : 0.0,
            child: isVisible
                ? Container(
                    height: sz.height * .12,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black],
                        stops: const [0.0, 1.5],
                      ),
                    ),
                    child: Center(
                      child: TextButton(
                        style: Theme.of(context).elevatedButtonTheme.style,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => const AddTaskBottomSheet(),
                          );
                        },
                        child: Text(
                          'Add new todo +',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(),
                        ),
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}
