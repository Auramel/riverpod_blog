import 'package:event_bus/event_bus.dart';

import 'package:river_blog/facades/device_storage_facade.dart';
import 'package:river_blog/modules/app/events/auth_events.dart';

class UserFacade {
  final DeviceStorageFacade storage;
  final EventBus eventBus;

  const UserFacade({
    required this.storage,
    required this.eventBus,
  });

  bool get isLoggedIn => (
    (storage.getLogin()?.isNotEmpty ?? false)
    && (storage.getPassword()?.isNotEmpty ?? false)
  );
  
  Future<void> login({
    required String login,
    required String password,
  }) async {
    await storage.setLogin(login);
    await storage.setPassword(password);

    eventBus.fire(const UserLoggedInEvent());
  }

  Future<void> logout() async {
    await storage.setLogin(null);
    await storage.setPassword(null);

    eventBus.fire(const UserLoggedOutEvent());
  }
}
