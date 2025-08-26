import 'package:flutter/material.dart';

class ThemeMapper {
  static ThemeMode mapIndexToTheme(int index) {
    switch (index) {
      case 0:
        return ThemeMode.light;
      case 1:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

   static int mapThemeToIndex(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light: return 0;
      case ThemeMode.dark: return 1;
      case ThemeMode.system: return 2;
    }
  }
}
