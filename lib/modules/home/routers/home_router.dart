import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:event_bus/event_bus.dart';
import 'package:go_router/go_router.dart';

import 'package:river_blog/core/base/base_router.dart';
import 'package:river_blog/core/configs/routes.dart';
import 'package:river_blog/modules/app/events/user_events.dart';
import 'package:river_blog/modules/home/screens/home_screen.dart';

class HomeRouter extends BaseRouter {
  final EventBus eventBus;

  StreamSubscription<UserLoggedOutEvent>? _subscription;

  HomeRouter({
    required this.eventBus,
  });

  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: Routes.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
  ];

  @override
  void init(GoRouter router) {
    super.init(router);

    _subscription = eventBus.on<UserLoggedOutEvent>()
      .listen(_onUserLoggedOut);
  }

  @override
  void dispose() {
    _subscription?.cancel().ignore();
    _subscription = null;

    super.dispose();
  }

  void _onUserLoggedOut(UserLoggedOutEvent event) {
    router.replace(Routes.login);
  }
}
