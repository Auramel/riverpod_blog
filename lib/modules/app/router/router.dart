import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:river_blog/modules/app/providers.dart';
import 'package:river_blog/modules/app/router/routes.dart';
import 'package:river_blog/modules/app/states/app_state.dart';
import 'package:river_blog/modules/app/states/auth_state.dart';
import 'package:river_blog/modules/auth/screens/login_screen.dart';
import 'package:river_blog/modules/home/screens/home_screen.dart';

final Provider<GoRouter> routerProvider = Provider<GoRouter>((Ref ref) {
  final GoRouter router = GoRouter(
    initialLocation: Routes.login,
    redirect: (BuildContext context, GoRouterState state) {
      final AuthState authState = ref.read(appCommandsProvider).authState;
      final bool isLoggedIn = (authState.status == Status.loggedIn);
      final bool isLoginRoute = (state.matchedLocation == Routes.login);

      if (
        !isLoggedIn
        && !isLoginRoute
      ) {
        return Routes.login;
      }

      if (
        isLoggedIn
        && isLoginRoute
      ) {
        return Routes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
      ),
    ],
  );

  ref.listen<AppState>(
    appCommandsProvider.select((AppState state) => state),
    (AppState? previous, AppState next) {
      router.refresh();
    },
  );

  ref.onDispose(router.dispose);

  return router;
});
