import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/helper/enums.dart';
import 'package:todo_app/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/presentation/screens/home_screen_changes/cubit/highlight_cubit.dart';
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
  late ScrollController _scrollController;
  bool _isBottomBarVisible = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _addListner();
  }

  void _scrollListener() {
    if (_tabController.index != 1) return;

    final direction = _scrollController.position.userScrollDirection;
    final offset = _scrollController.offset;
    if (direction == ScrollDirection.reverse) {
      context.read<BottomBarCubit>().hide();
    } else if (direction == ScrollDirection.forward) {
      context.read<BottomBarCubit>().show();
    }

    if (offset <= 20) {
      context.read<BottomBarCubit>().show();
    }
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
    _scrollController.dispose();
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

  void focusOnCompletedTask(String taskId) {
    _tabController.animateTo(3);
    context.read<HighlightCubit>().highlight(taskId);
  }

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_tabController.index == 1) {
          Navigator.of(context).maybePop();
        } else {
          _tabController.animateTo(1);
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: CustomDrawer(onItemTap: _onDrawerItemTap),
        extendBody: true,
        body: NestedScrollView(
          controller: _scrollController,
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
                    TodoCalendar(onTap: focusOnCompletedTask),
                    TaskList(tasks: state.alltasks, listType: TaskListType.all),
                    TaskList(
                      tasks: state.upcomingTasks,
                      listType: TaskListType.upcoming,
                    ),
                    TaskList(
                      tasks: state.completedTasks,
                      showCompletedDate: true,
                      listType: TaskListType.completed,
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
            final offset = (isVisible && _tabController.index == 1)
                ? Offset.zero
                : const Offset(0, 1);

            return AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              offset: offset,
              child: Container(
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
              ),
            );
          },
        ),
      ),
    );
  }
}
