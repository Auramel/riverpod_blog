import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:river_blog/core/configs/routes.dart';
import 'package:river_blog/facades/user_facade.dart';
import 'package:river_blog/modules/app/commands/app_commands.dart';
import 'package:river_blog/modules/app/routers/app_router.dart';
import 'package:river_blog/modules/app/routers/auth_router.dart';
import 'package:river_blog/modules/app/states/app_state.dart';
import 'package:river_blog/modules/auth/screens/login_screen.dart';
import 'package:river_blog/modules/home/screens/home_screen.dart';
import 'package:river_blog/shared/providers.dart';

final NotifierProvider<AppCommands, AppState> appCommandsProvider = NotifierProvider<AppCommands, AppState>(AppCommands.new);
final Provider<GoRouter> routerProvider = Provider<GoRouter>((Ref ref) {
  final UserFacade userFacade = ref.watch(userFacadeProvider);

  final GoRouter router = GoRouter(
    initialLocation: userFacade.isLoggedIn
      ? Routes.home
      : Routes.login,
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: Routes.home,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
    ],
  );

  ref.onDispose(router.dispose);

  return router;
});

final Provider<AppRouter> appRouterProvider = Provider<AppRouter>((Ref ref) {
  final appRouter = AppRouter([
    AuthRouter(
      eventBus: ref.watch(eventBusProvider),
      router: ref.watch(routerProvider),
    ),
  ]);

  appRouter.init();

  ref.onDispose(appRouter.dispose);

  return appRouter;
});
