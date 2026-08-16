import 'package:river_blog/core/base/base_commands.dart';
import 'package:river_blog/modules/auth/states/login_form_state.dart';
import 'package:river_blog/modules/auth/validators/login_validator.dart';

class LoginCommands extends BaseCommands<LoginFormState> {
  @override
  LoginFormState build() {
    return LoginFormState.empty();
  }

  void onLoginChanged(String value) {
    state = state.copyWith(login: value);
  }

  void onPasswordChanged(String value) {
    state = state.copyWith(password: value);
  }

  Future<void> onSubmit() async {
    final login = state.login;
    final password = state.password;

    final LoginValidator validator = LoginValidator(
      login: login,
      password: password,
    );

    state = state.copyWith(
      loginError: validator.validateLogin(),
    );

    state = state.copyWith(
      passwordError: validator.validatePassword(),
    );

    if (validator.hasErrors) {
      return;
    }

    await loading((Function(String) describe) async {
      if (!ref.mounted) {
        return;
      }

      state = state.copyWithoutErrors();

      describe('Отправляю запрос на сервер');
      await Future<void>.delayed(const Duration(seconds: 3));

      if (!ref.mounted) {
        return;
      }

      describe('Обрабатываю полученные данные');

      if (login == 'admin' && password == '1234') {
        return;
      }
    });
  }
}
