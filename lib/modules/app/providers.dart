import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:river_blog/core/base/base_router.dart';
import 'package:river_blog/core/configs/routes.dart';
import 'package:river_blog/facades/user_facade.dart';
import 'package:river_blog/modules/app/commands/app_commands.dart';
import 'package:river_blog/modules/app/routers/app_router.dart';
import 'package:river_blog/modules/app/services/bottom_sheets.dart';
import 'package:river_blog/modules/app/states/app_state.dart';
import 'package:river_blog/shared/providers.dart';

final NotifierProvider<AppCommands, AppState> appCommandsProvider = NotifierProvider<AppCommands, AppState>(AppCommands.new);
final Provider<BottomSheets> bottomSheetsProvider = Provider<BottomSheets>((Ref ref) => BottomSheets());
final Provider<List<BaseRouter>> routerModulesProvider = Provider<List<BaseRouter>>(
  (Ref ref) => throw UnimplementedError('routerModulesProvider must be overridden'),
);

final Provider<GoRouter> routerProvider = Provider<GoRouter>((Ref ref) {
  final UserFacade userFacade = ref.watch(userFacadeProvider);
  final AppRouter appRouter = ref.watch(_appRouterProvider);

  final GoRouter router = GoRouter(
    initialLocation: userFacade.isLoggedIn
      ? Routes.home
      : Routes.login,
    routes: appRouter.routes,
  );

  appRouter.init(router);

  ref.onDispose(() {
    appRouter.dispose();
    router.dispose();
  });

  return router;
});

final Provider<AppRouter> _appRouterProvider = Provider<AppRouter>((Ref ref) => AppRouter(
  ref.watch(routerModulesProvider),
));
