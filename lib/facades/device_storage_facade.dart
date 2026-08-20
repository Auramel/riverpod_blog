import 'package:shared_preferences/shared_preferences.dart';

abstract class _Keys {
  static const String login = 'login';
  static const String password = 'password';
}

class DeviceStorageFacade {
  final SharedPreferences prefs;

  DeviceStorageFacade(this.prefs);

  String? getLogin() =>  prefs.getString(_Keys.login);
  Future<void> setLogin(String? value) async {
    if (value == null) {
      await prefs.remove(_Keys.login);
      return;
    }

    await prefs.setString(_Keys.login, value);
  }

  String? getPassword() => prefs.getString(_Keys.password);
  Future<void> setPassword(String? value) async {
    if (value == null) {
      await prefs.remove(_Keys.password);
      return;
    }

    await prefs.setString(_Keys.password, value);
  }
}
