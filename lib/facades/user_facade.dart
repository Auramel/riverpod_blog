import 'package:river_blog/facades/device_storage_facade.dart';

class UserFacade {
  final DeviceStorageFacade storage;

  const UserFacade(this.storage);

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
  }

  Future<void> logout() async {
    await storage.setLogin(null);
    await storage.setPassword(null);
  }
}
