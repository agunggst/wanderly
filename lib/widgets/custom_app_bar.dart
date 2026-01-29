import 'package:flutter/material.dart';
import 'package:wanderly/style/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderly/core/theme_provider.dart';

class CustomAppBar extends ConsumerWidget
    implements PreferredSizeWidget {

  final double height;

  const CustomAppBar({
    super.key,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final c = AppColors.of(context);

    return AppBar(
      backgroundColor: c.background,
      toolbarHeight: height,
      elevation: 0,

      // LOGO KIRI — DI-CENTER BERDASARKAN TOOLBAR HEIGHT
      titleSpacing: 16,
      title: SizedBox(
        height: height,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Image.asset(
            'assets/wanderly_logo.png',
            height: height * 0.7,
            fit: BoxFit.contain,
          ),
        ),
      ),

      // ICON KANAN — CENTER SESUAI TOOLBAR
      actions: [
        SizedBox(
          height: height,
          child: Center(
            child: IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                size: 30,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              onPressed: () {
                ref.read(themeModeProvider.notifier).state =
                    isDark ? ThemeMode.light : ThemeMode.dark;
              },
            ),
          ),
        ),
      ],
    );
  }
}
