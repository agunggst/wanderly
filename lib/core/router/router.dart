import 'package:wanderly/features/trip/view/home_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:wanderly/features/auth/view/login_screen.dart';
import 'package:wanderly/features/auth/view/register_screen.dart';

final appRouter = GoRouter(
  initialLocation: LoginScreen.routeName,
  routes: [
    GoRoute(path: HomeScreen.routeName, builder: (_, _) => const HomeScreen()),
    GoRoute(path: LoginScreen.routeName, builder: (_, _) => const LoginScreen()),
    GoRoute(path: RegisterScreen.routeName, builder: (_, _) => const RegisterScreen()),
  ]
);