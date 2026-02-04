import 'package:flutter/material.dart';
import 'package:wanderly/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: AppColors.light.background,
    brightness: Brightness.light, 
    useMaterial3: true
  );

  static ThemeData dark = ThemeData(
    scaffoldBackgroundColor: AppColors.dark.background,
    brightness: Brightness.dark, 
    useMaterial3: true
  );
}