import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderly/core/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:wanderly/style/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  static const routeName = "/";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: const Center(child: Text("Hello")),
    );
  }
}
