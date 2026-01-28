import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:wanderly/style/app_colors.dart';

enum FontFamily { 
  urbanist, 
  // tambahkan font di sini
}

class FontScale {
  const FontScale();

  static double get h1 => 20.sp;
  static double get body => 16.sp;
  static double get caption => 14.sp;
}

class AppFonts {
  static TextStyle base({
    FontFamily family = FontFamily.urbanist,
    required double size,
    FontWeight weight = FontWeight.normal,
    double height = 1.4,
    Color? color,
  }) {
    switch (family) {
      // tambahkan font di sini
      case FontFamily.urbanist:
        return GoogleFonts.urbanist(
          fontSize: size,
          fontWeight: weight,
          height: height,
          color: color,
        );
    }
  }
}

class AppTextStyles {
  static TextStyle heading(
    BuildContext context, {
    FontFamily font = FontFamily.urbanist,
  }) {
    final c = AppColors.of(context);
    return AppFonts.base(
      family: font,
      size: FontScale.h1,
      height: 1.5,
      color: c.textPrimary,
    );
  }

  static TextStyle body(
    BuildContext context, {
    FontFamily font = FontFamily.urbanist,
  }) {
    final c = AppColors.of(context);
    return AppFonts.base(
      family: font,
      size: FontScale.body,
      color: c.textPrimary,
    );
  }

  static TextStyle caption(
    BuildContext context, {
    FontFamily font = FontFamily.urbanist,
  }) {
    final c = AppColors.of(context);
    return AppFonts.base(
      family: font,
      size: FontScale.caption,
      color: c.textSecondary,
    );
  }
}
