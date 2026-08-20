import 'package:river_blog/core/base/base_router.dart';

class AppRouter extends BaseRouter {
  final List<BaseRouter> routers;

  new(this.routers);

  @override
  void init() {
    super.init();

    for (final BaseRouter router in routers) {
      router.init();
    }
  }

  @override
  void dispose() {
    for (final BaseRouter router in routers.reversed) {
      router.dispose();
    }

    super.dispose();
  }
}
