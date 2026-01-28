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

  // Headings
  static double get h1 => 24.sp; // Page title
  static double get h2 => 20.sp; // Section title
  static double get h3 => 18.sp; // Card title

  // Body
  static double get body => 16.sp; // Default text
  static double get bodySmall => 14.sp;

  // Supporting
  static double get overline => 10.sp;
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
      weight: FontWeight.bold,
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

  static TextStyle bodyBold(
    BuildContext context, {
    FontFamily font = FontFamily.urbanist,
  }) {
    final c = AppColors.of(context);
    return AppFonts.base(
      family: font,
      size: FontScale.body,
      color: c.textPrimary,
      weight: FontWeight.bold,
    );
  }

  static TextStyle caption(
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

  static TextStyle errorText(
    BuildContext context, {
    FontFamily font = FontFamily.urbanist,
  }) {
    final c = AppColors.of(context);
    return AppFonts.base(
      family: font,
      size: FontScale.bodySmall,
      color: c.error,
      weight: FontWeight.bold
    );
  }

  static TextStyle textHint(
    BuildContext context, {
    FontFamily font = FontFamily.urbanist,
  }) {
    final c = AppColors.of(context);
    return AppFonts.base(
      family: font,
      size: FontScale.body,
      color: c.placeholderColor,
    );
  }

  static TextStyle textButton(
    BuildContext context, {
    FontFamily font = FontFamily.urbanist,
  }) {
    final c = AppColors.of(context);
    return AppFonts.base(
      family: font,
      size: FontScale.body,
      color: c.textSecondary,
      weight: FontWeight.bold
    );
  }
}
