import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/helper/theme_options.dart';
import 'package:todo_app/features/theme/bloc/theme_bloc.dart';

class ThemeSelector extends StatefulWidget {
  const ThemeSelector({super.key});

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  double dragPosition = 0;
  bool isDragging = false;

  final List<ThemeOption> items = const [
    ThemeOption("Light", ThemeMode.light),
    ThemeOption("Dark", ThemeMode.dark),
    ThemeOption("System", ThemeMode.system),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final selectedIndex = items.indexWhere(
          (e) => e.mode == state.themeMode,
        );

        if (!isDragging) {
          dragPosition = selectedIndex.toDouble();
        }

        return Container(
          margin: const EdgeInsets.all(10),
          height: 55,
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final segmentWidth = constraints.maxWidth / items.length;

              return GestureDetector(
                onHorizontalDragStart: (_) => setState(() => isDragging = true),
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    dragPosition += details.primaryDelta! / segmentWidth;
                    dragPosition = dragPosition.clamp(0, items.length - 1);
                  });
                },
                onHorizontalDragEnd: (_) {
                  setState(() => isDragging = false);
                  final index = dragPosition.round();
                  context.read<ThemeBloc>().add(
                    ChangeThemeEvent(items[index].mode),
                  );
                },
                onTapUp: (_) => setState(() => isDragging = false),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: Duration(milliseconds: isDragging ? 0 : 250),
                      curve: Curves.easeOutCubic,
                      alignment: Alignment(
                        -1 + (2 / (items.length - 1)) * dragPosition,
                        0,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutBack,
                        width: segmentWidth,
                        height: isDragging ? 60 : 45,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.deepPurple[700] : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Row(
                      children: List.generate(items.length, (index) {
                        final isSelected = index == selectedIndex;
                        final option = items[index];
                        return Expanded(
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize: isSelected ? 16 : 15,
                                color: isSelected
                                    ? (isDark
                                          ? Colors.white
                                          : Colors.deepPurple)
                                    : (isDark
                                          ? Colors.grey[400]
                                          : Colors.black87),
                              ),
                              child: Text(option.label),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
