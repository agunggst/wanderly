import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wanderly/core/router.dart';
import 'package:wanderly/core/theme_provider.dart';
import 'package:wanderly/style/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const ProviderScope(
    child: MyApp()
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Sizer(
      builder: (context, orientation, screentype) {
        return MaterialApp.router(
          routerConfig: appRouter,
          themeMode: themeMode,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.light.background,
            brightness: Brightness.light, 
            useMaterial3: true
          ),
          darkTheme: ThemeData(
            scaffoldBackgroundColor: AppColors.dark.background,
            brightness: Brightness.dark, 
            useMaterial3: true
          ),
        );
      }
    );
  }
}
