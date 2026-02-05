import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:wanderly/core/router/router.dart';
import 'package:wanderly/core/theme/app_theme.dart';
import 'package:wanderly/core/theme/theme_provider.dart';
import 'package:wanderly/features/trip/data/trip_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Hive.initFlutter();
  Hive.registerAdapter(TripAdapter());
  runApp(const ProviderScope(
    child: MyApp()
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    return Sizer(
      builder: (context, orientation, screentype) {
        return MaterialApp.router(
          routerConfig: router,
          themeMode: themeMode,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
        );
      }
    );
  }
}
