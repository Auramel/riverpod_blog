import 'package:flutter/foundation.dart';

import 'package:go_router/go_router.dart';

abstract class BaseRouter {
  bool _isInitialized = false;
  GoRouter? _router;

  List<RouteBase> get routes;

  @protected
  GoRouter get router {
    final GoRouter? router = _router;

    if (router == null) {
      throw StateError('Router is not initialized');
    }

    return router;
  }

  new();

  @mustCallSuper
  void init(GoRouter router) {
    if (_isInitialized) {
      throw StateError('Router is already initialized');
    }

    _isInitialized = true;
    _router = router;
  }

  @mustCallSuper
  void dispose() {
    _router = null;
    _isInitialized = false;
  }
}
