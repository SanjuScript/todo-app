import 'package:flutter/material.dart';
import 'package:todo_app/features/animation/fade_page_animation.dart';
import 'package:todo_app/features/helper/extensions/color_ext.dart';
import 'package:todo_app/features/helper/font_helper.dart';

class CustomAppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      elevation: 5,
      shadowColor: "0D0D0D".toColor(),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.deepPurple),
    ),
    textTheme: TextTheme(
      displayLarge: PerfectTypogaphy.bold.copyWith(
        fontSize: 32,
        color: Colors.white,
      ),
      displayMedium: PerfectTypogaphy.bold.copyWith(
        fontSize: 28,
        color: Colors.white,
      ),
      bodyLarge: PerfectTypogaphy.regular.copyWith(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: PerfectTypogaphy.regular.copyWith(
        fontSize: 14,
        color: Colors.white,
      ),
      bodySmall: PerfectTypogaphy.regular.copyWith(
        fontSize: 12,
        color: Colors.grey,
      ),
      labelLarge: PerfectTypogaphy.bold.copyWith(
        fontSize: 16,
        color: Colors.white,
      ),
      titleLarge: PerfectTypogaphy.bold.copyWith(
        fontSize: 24,
        color: "0D0D0D".toColor(),
      ),
      titleMedium: PerfectTypogaphy.bold.copyWith(
        fontSize: 20,
        color: "0D0D0D".toColor(),
      ),
      titleSmall: PerfectTypogaphy.bold.copyWith(
        fontSize: 18,
        color: "0D0D0D".toColor(),
      ),
      headlineLarge: PerfectTypogaphy.regular.copyWith(
        fontSize: 22,
        color: Colors.white,
      ),
      headlineMedium: PerfectTypogaphy.regular.copyWith(
        fontSize: 20,
        color: Colors.white,
      ),
      headlineSmall: PerfectTypogaphy.regular.copyWith(
        fontSize: 18,
        color: Colors.white,
      ),
      labelMedium: PerfectTypogaphy.bold.copyWith(
        fontSize: 16,
        color: Colors.white,
      ),
      labelSmall: PerfectTypogaphy.bold.copyWith(
        fontSize: 14,
        color: Colors.black,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
       side: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
      ),
      elevation: 6,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        textStyle: PerfectTypogaphy.bold.copyWith(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.teal.shade50,
        foregroundColor: Colors.deepPurple, // Text color
        textStyle: PerfectTypogaphy.bold.copyWith(fontSize: 14),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.deepPurple,
        side: const BorderSide(color: Colors.deepPurple),
        textStyle: PerfectTypogaphy.bold.copyWith(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.deepPurple,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: "#eff3fc".toColor(),
      selectedItemColor: "0D0D0D".toColor(),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: false,
      showSelectedLabels: true,
      selectedLabelStyle: PerfectTypogaphy.regular.copyWith(
        letterSpacing: 0.5,
        color: "0D0D0D".toColor(),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      headerBackgroundColor: Colors.deepPurple,
      headerForegroundColor: Colors.white,

      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade400;
        }
        return Colors.black87;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.deepPurple;
        }
        if (states.contains(WidgetState.hovered)) {
          return Colors.deepPurple.withOpacity(0.1);
        }
        return Colors.transparent;
      }),
      yearOverlayColor: WidgetStateProperty.all(Colors.black),
      rangePickerBackgroundColor: Colors.black,

      todayForegroundColor: WidgetStateProperty.all(Colors.deepPurple),
      todayBorder: BorderSide(color: Colors.deepPurple, width: 1.5),
      yearForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.deepPurple;
        }
        return Colors.black87;
      }),
      yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.deepPurple.withOpacity(0.15);
        }
        return Colors.transparent;
      }),

      weekdayStyle: PerfectTypogaphy.bold.copyWith(color: Colors.black87),

      inputDecorationTheme: InputDecorationTheme(
        helperStyle: TextStyle(color: Colors.black87),

        filled: true,
        fillColor: Colors.grey.shade100,
        hintStyle: TextStyle(color: Colors.grey.shade800),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      confirmButtonStyle: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.deepPurple),
      ),
    ),

    drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: PerfectTypogaphy.bold.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomPageTransition(),
        TargetPlatform.iOS: CustomPageTransition(),
      },
    ),
  );

  static final darkTheme = ThemeData(
    drawerTheme: DrawerThemeData(backgroundColor: "0D0D0D".toColor()),
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: "0D0D0D".toColor(),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      shadowColor: Colors.black54,
      backgroundColor: Color(0xFF111111),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: PerfectTypogaphy.bold.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),

    textTheme: TextTheme(
      displayLarge: PerfectTypogaphy.bold.copyWith(
        fontSize: 32,
        color: Colors.white,
      ),
      displayMedium: PerfectTypogaphy.bold.copyWith(
        fontSize: 28,
        color: Colors.white70,
      ),
      bodyLarge: PerfectTypogaphy.regular.copyWith(
        fontSize: 16,
        color: Colors.white70,
      ),
      bodyMedium: PerfectTypogaphy.regular.copyWith(
        fontSize: 14,
        color: Colors.white60,
      ),
      bodySmall: PerfectTypogaphy.regular.copyWith(
        fontSize: 12,
        color: Colors.grey,
      ),
      labelLarge: PerfectTypogaphy.bold.copyWith(
        fontSize: 16,
        color: Colors.black,
      ),
      titleLarge: PerfectTypogaphy.bold.copyWith(
        fontSize: 24,
        color: Colors.white,
      ),
      titleMedium: PerfectTypogaphy.bold.copyWith(
        fontSize: 20,
        color: Colors.white70,
      ),
      titleSmall: PerfectTypogaphy.bold.copyWith(
        fontSize: 18,
        color: Colors.white70,
      ),
      headlineLarge: PerfectTypogaphy.regular.copyWith(
        fontSize: 22,
        color: Colors.white,
      ),
      headlineMedium: PerfectTypogaphy.regular.copyWith(
        fontSize: 20,
        color: Colors.white70,
      ),
      headlineSmall: PerfectTypogaphy.regular.copyWith(
        fontSize: 18,
        color: Colors.white70,
      ),
      labelMedium: PerfectTypogaphy.bold.copyWith(
        fontSize: 16,
        color: Colors.white70,
      ),
      labelSmall: PerfectTypogaphy.bold.copyWith(
        fontSize: 14,
        color: Colors.white70,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
      ),
      elevation: 8,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent.shade200,
        foregroundColor: Colors.white,
        textStyle: PerfectTypogaphy.bold.copyWith(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent.shade200,
        foregroundColor: Colors.white,
        textStyle: PerfectTypogaphy.bold.copyWith(fontSize: 14),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white70),
    iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom()),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.deepPurpleAccent, width: 1.5),
        textStyle: PerfectTypogaphy.bold.copyWith(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.deepPurpleAccent,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      selectedItemColor: Colors.deepPurpleAccent,
      unselectedItemColor: Colors.white38,
      showUnselectedLabels: false,
      showSelectedLabels: true,
      selectedLabelStyle: PerfectTypogaphy.regular.copyWith(
        letterSpacing: 0.5,
        color: Colors.deepPurpleAccent,
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      headerBackgroundColor: Colors.deepPurple,
      headerForegroundColor: Colors.white,

      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade600;
        }
        return Colors.white70;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.deepPurple;
        }
        if (states.contains(WidgetState.hovered)) {
          return Colors.deepPurple.withOpacity(0.2);
        }
        return Colors.transparent;
      }),
      yearOverlayColor: WidgetStateProperty.all(Colors.white),
      rangePickerBackgroundColor: Colors.white,

      todayForegroundColor: WidgetStateProperty.all(Colors.deepPurple),
      todayBorder: BorderSide(color: Colors.deepPurple, width: 1.5),
      yearForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.deepPurple;
        }
        return Colors.white70;
      }),
      yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.deepPurple.withOpacity(0.25);
        }
        return Colors.transparent;
      }),

      weekdayStyle: PerfectTypogaphy.bold.copyWith(color: Colors.white70),

      inputDecorationTheme: InputDecorationTheme(
        helperStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey.shade900,
        hintStyle: TextStyle(color: Colors.grey.shade300),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      confirmButtonStyle: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      cancelButtonStyle: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Colors.deepPurpleAccent.shade100,
        ),
        foregroundColor: WidgetStateProperty.all(Colors.white70),
      ),
    ),

    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomPageTransition(),
        TargetPlatform.iOS: CustomPageTransition(),
      },
    ),
  );
}
