import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:event_bus/event_bus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:river_blog/core/base/base_events.dart';
import 'package:river_blog/core/base/base_router.dart';
import 'package:river_blog/facades/device_storage_facade.dart';
import 'package:river_blog/facades/logger_facade.dart';
import 'package:river_blog/modules/app/providers.dart';
import 'package:river_blog/modules/app/screens/app_layout.dart';
import 'package:river_blog/modules/auth/providers.dart';
import 'package:river_blog/modules/home/providers.dart';
import 'package:river_blog/modules/users/providers.dart';
import 'package:river_blog/shared/providers.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final DeviceStorageFacade deviceStorageFacade = DeviceStorageFacade(prefs);
  final LoggerFacade loggerFacade = LoggerFacade();

  runApp(
    ProviderScope(
      overrides: [
        deviceStorageFacadeProvider.overrideWithValue(deviceStorageFacade),
        eventBusProvider.overrideWith((Ref ref) {
          final EventBus eventBus = EventBus();
          final StreamSubscription<BaseEvent> subscription = eventBus.on<BaseEvent>()
            .listen(loggerFacade.event);

          ref.onDispose(() {
            subscription.cancel().ignore();
            eventBus.destroy();
          });

          return eventBus;
        }),
        routerModulesProvider.overrideWith((Ref ref) => <BaseRouter>[
          ref.watch(authRouterProvider),
          ref.watch(homeRouterProvider),
          ref.watch(usersRouterProvider),
        ]),
      ],
      observers: [
        loggerFacade.riverpodObserver(),
      ],
      child: const AppLayout(),
    ),
  );
}
