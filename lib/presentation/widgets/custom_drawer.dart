import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/theme/bloc/theme_bloc.dart';
import 'package:todo_app/presentation/widgets/theme_selector_widget.dart';

class CustomDrawer extends StatelessWidget {
  final void Function(String) onItemTap;

  const CustomDrawer({super.key, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.deepPurple.shade800.withOpacity(0.6)
                    : Colors.deepPurple.shade200.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: isDark
                        ? Colors.deepPurple.shade700
                        : Colors.deepPurple.shade400,
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, Sanju 👋",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Stay productive today!",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _drawerItem(
                    context,
                    icon: Icons.list_alt,
                    text: "All Tasks",
                    onTap: () => onItemTap("tasks"),
                  ),
                  _drawerItem(
                    context,
                    icon: Icons.check_circle,
                    text: "Completed",
                    onTap: () => onItemTap("completed"),
                  ),
                  _drawerItem(
                    context,
                    icon: Icons.calendar_today,
                    text: "Upcoming",
                    onTap: () => onItemTap("upcoming"),
                  ),
                  _drawerItem(
                    context,
                    icon: Icons.settings,
                    text: "Settings",
                    onTap: () => onItemTap("settings"),
                  ),
                  _drawerItem(
                    context,
                    icon: Icons.info_outline,
                    text: "About",
                    onTap: () => onItemTap("about"),
                  ),
                  ThemeSelector(),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Todo App v1.0",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: isDark ? Colors.deepPurple[200] : Colors.deepPurple[700],
      ),
      title: Text(
        text,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onTap: onTap,
      hoverColor: isDark
          ? Colors.deepPurple.shade700.withOpacity(0.2)
          : Colors.deepPurple.shade100.withOpacity(0.3),
    );
  }
}
