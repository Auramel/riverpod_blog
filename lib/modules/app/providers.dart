import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:river_blog/core/configs/routes.dart';
import 'package:river_blog/modules/app/commands/app_commands.dart';
import 'package:river_blog/modules/app/states/app_state.dart';
import 'package:river_blog/modules/app/states/auth_state.dart';
import 'package:river_blog/modules/auth/screens/login_screen.dart';
import 'package:river_blog/modules/home/screens/home_screen.dart';

final NotifierProvider<AppCommands, AppState> appCommandsProvider = NotifierProvider<AppCommands, AppState>(AppCommands.new);
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
    appCommandsProvider,
    (AppState? previous, AppState next) {
      router.refresh();
    },
  );

  ref.onDispose(router.dispose);

  return router;
});
