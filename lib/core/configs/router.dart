import 'package:go_router/go_router.dart';
import 'package:river_blog/core/configs/routes.dart';
import 'package:river_blog/modules/auth/screens/login_screen.dart';
import 'package:river_blog/modules/home/screens/home_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: Routes.login,
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
