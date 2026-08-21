import 'package:go_router/go_router.dart';

import 'package:river_blog/core/base/base_router.dart';

class AppRouter extends BaseRouter {
  final List<BaseRouter> _routers;

  AppRouter(List<BaseRouter> routers):
    _routers = List<BaseRouter>.unmodifiable(routers);

  @override
  List<RouteBase> get routes => _routers
    .expand((BaseRouter router) => router.routes)
    .toList();

  @override
  void init(GoRouter router) {
    super.init(router);

    for (final BaseRouter childRouter in _routers) {
      childRouter.init(router);
    }
  }

  @override
  void dispose() {
    for (final BaseRouter childRouter in _routers.reversed) {
      childRouter.dispose();
    }

    super.dispose();
  }
}
