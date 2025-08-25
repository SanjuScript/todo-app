import 'package:flutter/material.dart';
import 'package:todo_app/features/animation/fade_page_animation.dart';
import 'package:todo_app/features/helper/extensions/color_ext.dart';
import 'package:todo_app/features/helper/font_helper.dart';

class CustomAppTheme {
  static final lightTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
        elevation: 5,
        shadowColor: Colors.black12,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.deepPurple),
      ),
      textTheme: TextTheme(
        displayLarge:
            PerfectTypogaphy.bold.copyWith(fontSize: 32, color: Colors.black87),
        displayMedium:
            PerfectTypogaphy.bold.copyWith(fontSize: 28, color: Colors.black87),
        bodyLarge: PerfectTypogaphy.regular
            .copyWith(fontSize: 16, color: Colors.black87),
        bodyMedium: PerfectTypogaphy.regular
            .copyWith(fontSize: 14, color: Colors.black87),
        bodySmall:
            PerfectTypogaphy.regular.copyWith(fontSize: 12, color: Colors.grey),
        labelLarge:
            PerfectTypogaphy.bold.copyWith(fontSize: 16, color: Colors.white),
        titleLarge:
            PerfectTypogaphy.bold.copyWith(fontSize: 24, color: Colors.black87),
        titleMedium:
            PerfectTypogaphy.bold.copyWith(fontSize: 20, color: Colors.black87),
        titleSmall:
            PerfectTypogaphy.bold.copyWith(fontSize: 18, color: Colors.black87),
        headlineLarge: PerfectTypogaphy.regular
            .copyWith(fontSize: 22, color: Colors.black87),
        headlineMedium: PerfectTypogaphy.regular
            .copyWith(fontSize: 20, color: Colors.black87),
        headlineSmall: PerfectTypogaphy.regular
            .copyWith(fontSize: 18, color: Colors.black87),
        labelMedium:
            PerfectTypogaphy.bold.copyWith(fontSize: 16, color: Colors.black87),
        labelSmall:
            PerfectTypogaphy.bold.copyWith(fontSize: 14, color: Colors.black87),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple, 
          foregroundColor: Colors.white, 
          textStyle: PerfectTypogaphy.bold.copyWith(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
         
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      buttonTheme: ButtonThemeData(
        
        buttonColor: Colors.deepPurple, 
        textTheme: ButtonTextTheme.primary, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: "#eff3fc".toColor(),
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          selectedLabelStyle: PerfectTypogaphy.regular.copyWith(
            letterSpacing: 0.5,
            color: Colors.black87,
          )),
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: CustomPageTransition(),
        TargetPlatform.iOS: CustomPageTransition(),
      }));

        static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212), // Deep dark base
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      shadowColor: Colors.black54,
      backgroundColor: Color(0xFF1E1E1E),
      iconTheme: IconThemeData(color: Colors.tealAccent),
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
        color: Colors.tealAccent,
      ),
      labelSmall: PerfectTypogaphy.bold.copyWith(
        fontSize: 14,
        color: Colors.tealAccent,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent.shade200,
        foregroundColor: Colors.white,
        textStyle: PerfectTypogaphy.bold.copyWith(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
        shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.teal.withOpacity(0.15),
        foregroundColor: Colors.tealAccent,
        textStyle: PerfectTypogaphy.bold.copyWith(fontSize: 14),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.tealAccent,
        side: const BorderSide(color: Colors.tealAccent, width: 1.5),
        textStyle: PerfectTypogaphy.bold.copyWith(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.deepPurpleAccent,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      selectedItemColor: Colors.tealAccent,
      unselectedItemColor: Colors.white38,
      showUnselectedLabels: false,
      showSelectedLabels: true,
      selectedLabelStyle: PerfectTypogaphy.regular.copyWith(
        letterSpacing: 0.5,
        color: Colors.tealAccent,
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: CustomPageTransition(),
      TargetPlatform.iOS: CustomPageTransition(),
    }),
  );

}
