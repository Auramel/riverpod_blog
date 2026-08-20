import 'package:shared_preferences/shared_preferences.dart';

abstract class _Keys {
  static const String login = 'login';
  static const String password = 'password';
}

class DeviceStorageFacade {
  final SharedPreferences _prefs;

  DeviceStorageFacade(this._prefs);

  String? getLogin() =>  _prefs.getString(_Keys.login);
  Future<void> setLogin(String? value) async {
    await _setValue(
      key: _Keys.login,
      value: value,
    );
  }

  String? getPassword() => _prefs.getString(_Keys.password);
  Future<void> setPassword(String? value) async {
    await _setValue(
      key: _Keys.password,
      value: value,
    );
  }

  Future<void> _setValue({
    required String key,
    required Object? value,
  }) async {
    if (value == null) {
      await _prefs.remove(key);
      return;
    }

    if (value is int) {
      await _prefs.setInt(key, value);
      return;
    }

    if (value is double) {
      await _prefs.setDouble(key, value);
      return;
    }

    if (value is String) {
      await _prefs.setString(key, value);
      return;
    }

    if (value is bool) {
      await _prefs.setBool(key, value);
      return;
    }

    if (value is List<String>) {
      await _prefs.setStringList(key, value);
      return;
    }

    throw UnsupportedError('Unsupported device storage value type: ${value.runtimeType}');
  }
}
