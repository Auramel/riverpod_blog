import 'package:event_bus/event_bus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/facades/device_storage_facade.dart';
import 'package:river_blog/facades/user_facade.dart';

final Provider<EventBus> eventBusProvider = Provider<EventBus>((Ref ref) {
  final EventBus eventBus = EventBus();

  ref.onDispose(eventBus.destroy);

  return eventBus;
});

final Provider<DeviceStorageFacade> deviceStorageFacadeProvider = Provider<DeviceStorageFacade>(
  (Ref ref) => throw UnimplementedError(),
);

final Provider<UserFacade> userFacadeProvider = Provider<UserFacade>((Ref ref) => UserFacade(
  storage: ref.watch(deviceStorageFacadeProvider),
  eventBus: ref.watch(eventBusProvider),
));
