import 'package:flutter/material.dart';
import 'package:wanderly/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wanderly/core/theme/theme_provider.dart';
import 'package:wanderly/features/auth/provider/auth_provider.dart';
import 'package:wanderly/features/auth/view/screens/login_screen.dart';

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
                ref.read(themeModeProvider.notifier).toggle();
              },
            ),
          ),
        ),
        SizedBox(
          height: height,
          child: Center(
            child: IconButton(
              icon: const Icon(
                Icons.logout,
                size: 30,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              onPressed: () async {
                // Show confirmation dialog
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  try {
                    // Logout from Firebase
                    await ref.read(authProvider.notifier).logout();
                    
                    // Navigate to login
                    if (context.mounted) {
                      context.go(LoginScreen.routeName);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logout failed: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
