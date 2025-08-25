import 'package:flutter/material.dart';

extension ColorExtension on String {
  Color toColor() {
    String hex = startsWith('#') ? substring(1) : this;
    return Color(int.parse(hex, radix: 16) + 0xFF000000);
  }
}