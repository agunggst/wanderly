import 'package:flutter/material.dart';

class AppColors {
  final Color background;
  final Color primary;
  final Color secondary;
  final Color textPrimary;
  final Color textSecondary;
  final Color backgroundWhite;
  final Color error;
  final Color placeholderColor;

  const AppColors({
    required this.background,
    required this.primary,
    required this.secondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.backgroundWhite,
    required this.error,
    required this.placeholderColor,
  });

  static AppColors of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? dark : light;
  }

  static const light = AppColors(
    background: Color(0xFFdbf7ff),
    backgroundWhite: Color(0xFFf3fdff),
    primary: Color(0xFF808ee4),
    secondary: Color(0xFF2f4BB9),
    textPrimary: Colors.black,
    textSecondary: Colors.white,
    error: Colors.redAccent,
    placeholderColor: Colors.black45,
  );

  static const dark = AppColors(
    background: Color(0xFF102a43),
    backgroundWhite: Color(0xFFf3fdff),
    primary: Color(0xFF808ee4),
    secondary: Color(0xFF2f4BB9),
    textPrimary: Colors.white,
    textSecondary: Colors.white,
    error: Colors.redAccent,
    placeholderColor: Colors.black45,
  );
}