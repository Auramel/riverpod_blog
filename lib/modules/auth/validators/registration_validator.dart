import 'package:river_blog/core/base/validator.dart';

class RegistrationValidator extends Validator {
  final String login;
  final String password;
  final String fullName;
  final DateTime? birthDate;

  new({
    required this.login,
    required this.password,
    required this.fullName,
    required this.birthDate,
  });

  String? validateLogin() {
    if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(login.trim())) {
      addError();
      return 'Некорректный email';
    }

    return null;
  }

  String? validatePassword() {
    if (password.length < 4) {
      addError();
      return 'Минимум 4 символа';
    }

    return null;
  }

  String? validateFullName() {
    if (fullName.trim().isEmpty) {
      addError();
      return 'ФИО не может быть пустым';
    }

    return null;
  }

  String? validateBirthDate() {
    if (birthDate == null) {
      addError();
      return 'Укажи дату рождения';
    }

    if (birthDate!.isAfter(DateTime.now())) {
      addError();
      return 'Дата ещё не наступила';
    }

    return null;
  }
}
