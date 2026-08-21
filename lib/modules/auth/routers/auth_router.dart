import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:event_bus/event_bus.dart';
import 'package:go_router/go_router.dart';

import 'package:river_blog/core/base/base_router.dart';
import 'package:river_blog/core/configs/routes.dart';
import 'package:river_blog/modules/app/events/user_events.dart';
import 'package:river_blog/modules/auth/screens/login_screen.dart';

class AuthRouter extends BaseRouter {
  final EventBus eventBus;

  StreamSubscription<UserLoggedInEvent>? _subscription;

  AuthRouter({
    required this.eventBus,
  });

  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: Routes.login,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
  ];

  @override
  void init(GoRouter router) {
    super.init(router);

    _subscription = eventBus.on<UserLoggedInEvent>()
      .listen(_onUserLoggedIn);
  }

  @override
  void dispose() {
    _subscription?.cancel().ignore();
    _subscription = null;

    super.dispose();
  }

  void _onUserLoggedIn(UserLoggedInEvent event) {
    router.replace(Routes.home);
  }
}
