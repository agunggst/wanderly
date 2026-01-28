import 'package:flutter/material.dart';

class AppColors {
  final Color background;
  final Color primary;
  final Color secondary;
  final Color textPrimary;
  final Color textSecondary;

  const AppColors({
    required this.background,
    required this.primary,
    required this.secondary,
    required this.textPrimary,
    required this.textSecondary
  });

  static AppColors of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? dark : light;
  }

  static const light = AppColors(
    background: Color(0xFFdbf7ff),
    primary: Color(0xFF808ee4),
    secondary: Color(0xFF2f4BB9),
    textPrimary: Colors.black,
    textSecondary: Colors.white,
  );

  static const dark = AppColors(
    background: Color(0xFF102a43),
    primary: Color(0xFF808ee4),
    secondary: Color(0xFF2f4BB9),
    textPrimary: Colors.white,
    textSecondary: Colors.white
  );
}