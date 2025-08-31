import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/features/domain/entities/task_model.dart';
import 'package:todo_app/features/helper/color_helper.dart';
import 'package:todo_app/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/presentation/widgets/todo/todo_tile.dart';

class TodoCalendar extends StatefulWidget {
  final ValueChanged<String>? onTap;
  const TodoCalendar({super.key, required this.onTap});

  @override
  State<TodoCalendar> createState() => _TodoCalendarState();
}

class _TodoCalendarState extends State<TodoCalendar>
    with AutomaticKeepAliveClientMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<TaskModel> _getTasksForDay(List<TaskModel> allTasks, DateTime day) {
    final dateOnly = DateUtils.dateOnly(day);
    return allTasks.where((task) {
      // completed tasks grouped by completedAt
      if (task.isCompleted && task.completedAt != null) {
        return DateUtils.isSameDay(
          dateOnly,
          DateUtils.dateOnly(task.completedAt!),
        );
      }
      // pending tasks grouped by dueDate
      if (!task.isCompleted && task.dueDate != null) {
        return DateUtils.isSameDay(dateOnly, DateUtils.dateOnly(task.dueDate!));
      }
      return false;
    }).toList();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TodoError) {
          return Center(child: Text("Error: ${state.errorMsg}"));
        }

        if (state is! TodoLoaded) {
          return const SizedBox.shrink();
        }

        final allTasks = state.alltasks;
        final tasksForDay = _getTasksForDay(
          allTasks,
          _selectedDay ?? DateTime.now(),
        );

        return Column(
          children: [
            Card(
              elevation: 6,
              color: isDark ? null : theme.scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TableCalendar<TaskModel>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.monday,

                  eventLoader: (day) => _getTasksForDay(allTasks, day),

                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isEmpty) return null;

                      final completedCount = events
                          .where((e) => e.isCompleted)
                          .length;
                      final pendingCount = events
                          .where((e) => !e.isCompleted)
                          .length;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (pendingCount > 0)
                            Row(
                              children: [
                                const Icon(
                                  Icons.event_note,
                                  size: 14,
                                  color: Colors.orange,
                                ),
                                Text(
                                  "$pendingCount",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          if (completedCount > 0) ...[
                            const SizedBox(width: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: Colors.green,
                                ),
                                Text(
                                  "$completedCount",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      );
                    },
                  ),

                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },

                  headerStyle: HeaderStyle(
                    titleTextStyle: theme.textTheme.titleLarge!.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    formatButtonVisible: false,
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: theme.colorScheme.primary,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.primary,
                    ),
                  ),

                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    weekendStyle: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),

                  calendarStyle: CalendarStyle(
                    markersMaxCount: 0,
                    todayDecoration: BoxDecoration(
                      color: isDark
                          ? theme.colorScheme.primary.withOpacity(.3)
                          : theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: isDark
                          ? theme.colorScheme.primary.withOpacity(.3)
                          : theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Task list below calendar
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: tasksForDay.isEmpty
                    ? Center(
                        key: const ValueKey("empty"),
                        child: Text(
                          "No tasks for this day",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      )
                    : ListView(
                        key: const ValueKey("list"),
                        padding: EdgeInsets.zero,
                        children: [
                          // --- Pending ---
                          if (tasksForDay
                              .where((t) => !t.isCompleted)
                              .isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.event_note),
                                  SizedBox(width: 5),
                                  Text(
                                    "Pending",
                                    style: theme.textTheme.titleLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...tasksForDay
                                .where((t) => !t.isCompleted)
                                .toList()
                                .asMap()
                                .entries
                                .map((entry) {
                                  final idx = entry.key;
                                  final task = entry.value;
                                  final bgColor = ColorHelper
                                      .colors[idx % ColorHelper.colors.length];
                                  return TodoTile(
                                    task: task,
                                    bgColor: bgColor,
                                    showCompletedDate: false,
                                  );
                                }),
                          ],

                          // --- Completed ---
                          if (tasksForDay
                              .where((t) => t.isCompleted)
                              .isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle),
                                  SizedBox(width: 5),
                                  Text(
                                    "Completed",
                                    style: theme.textTheme.titleLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...tasksForDay
                                .where((t) => t.isCompleted)
                                .toList()
                                .asMap()
                                .entries
                                .map((entry) {
                                  final idx = entry.key;
                                  final task = entry.value;
                                  final bgColor = ColorHelper
                                      .colors[idx % ColorHelper.colors.length];
                                  return InkWell(
                                    overlayColor: WidgetStateProperty.all(
                                      Colors.transparent,
                                    ),
                                    onTap: () => widget.onTap?.call(task.id),
                                    child: TodoTile(
                                      task: task,
                                      bgColor: bgColor,
                                      showCompletedDate: true,
                                      buttonFuctionable: false,
                                    ),
                                  );
                                }),
                          ],
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
