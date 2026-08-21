import 'package:flutter/widgets.dart';

import 'package:go_router/go_router.dart';

import 'package:river_blog/core/base/base_router.dart';
import 'package:river_blog/core/configs/routes.dart';
import 'package:river_blog/modules/users/screens/users_screen.dart';

class UsersRouter extends BaseRouter {
  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: Routes.users,
      builder: (BuildContext context, GoRouterState state) {
        return const UsersScreen();
      },
    ),
  ];
}
