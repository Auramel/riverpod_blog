import 'package:river_blog/core/base/validator.dart';

class LoginValidator extends Validator {
  final String login;
  final String password;

  new({
    required this.login,
    required this.password,
  });

  String? validateLogin() {
    if (login.isEmpty) {
      addError();
      return 'Логин не может быть пустым';
    }

    return null;
  }

  String? validatePassword() {
    if (password.isEmpty) {
      addError();
      return 'Пароль не может быть пустым';
    }

    return null;
  }
}
