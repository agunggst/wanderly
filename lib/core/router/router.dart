import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderly/features/auth/provider/auth_provider.dart';
import 'package:wanderly/features/trip/view/screens/home_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:wanderly/features/auth/view/screens/login_screen.dart';
import 'package:wanderly/features/auth/view/screens/register_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: LoginScreen.routeName,
    redirect: (context, state) {
      final token = auth.value;

      final isLoginPage = state.matchedLocation == LoginScreen.routeName;
      final isRegisterPage = state.matchedLocation == RegisterScreen.routeName;

      if (auth.isLoading) return null;

      // Kalau belum login dan bukan di login/register → paksa ke login
      if (token == null && !isLoginPage && !isRegisterPage) {
        return LoginScreen.routeName;
      }

      // Kalau sudah login dan masih di login → ke home
      if (token != null && isLoginPage) {
        return HomeScreen.routeName;
      }

      return null;
    },
    routes: [
      GoRoute(path: HomeScreen.routeName, builder: (_, _) => const HomeScreen()),
      GoRoute(path: LoginScreen.routeName, builder: (_, _) => const LoginScreen()),
      GoRoute(path: RegisterScreen.routeName, builder: (_, _) => const RegisterScreen()),
    ]
  );
},);