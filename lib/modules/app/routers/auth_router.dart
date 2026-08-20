import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:go_router/go_router.dart';

import 'package:river_blog/core/base/base_events.dart';
import 'package:river_blog/core/base/base_router.dart';
import 'package:river_blog/core/configs/routes.dart';
import 'package:river_blog/modules/app/events/auth_events.dart';

class AuthRouter extends BaseRouter {
  final EventBus eventBus;
  final GoRouter router;

  final List<StreamSubscription<BaseEvent>> _subscriptions = [];

  AuthRouter({
    required this.eventBus,
    required this.router,
  });

  @override
  void init() {
    super.init();

    _subscriptions.add(
      eventBus.on<UserLoggedInEvent>()
        .listen(_onUserLoggedIn),
    );

    _subscriptions.add(
      eventBus.on<UserLoggedOutEvent>()
        .listen(_onUserLoggedOut),
    );
  }

  @override
  void dispose() {
    for (final StreamSubscription<BaseEvent> subscription in _subscriptions) {
      subscription.cancel().ignore();
    }

    _subscriptions.clear();

    super.dispose();
  }

  void _onUserLoggedIn(UserLoggedInEvent event) {
    router.replace(Routes.home);
  }

  void _onUserLoggedOut(UserLoggedOutEvent event) {
    router.replace(Routes.login);
  }
}
