import 'package:wanderly/screens/home_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:wanderly/screens/login_screen.dart';
import 'package:wanderly/screens/register_screen.dart';

final appRouter = GoRouter(
  initialLocation: HomeScreen.routeName,
  routes: [
    GoRoute(path: HomeScreen.routeName, builder: (_, _) => const HomeScreen()),
    GoRoute(path: LoginScreen.routeName, builder: (_, _) => const LoginScreen()),
    GoRoute(path: RegisterScreen.routeName, builder: (_, _) => const RegisterScreen()),
  ]
);