import 'package:river_blog/core/base/base_commands.dart';
import 'package:river_blog/modules/app/services/operation_runner.dart';
import 'package:river_blog/modules/auth/states/login_form_state.dart';
import 'package:river_blog/modules/auth/validators/login_validator.dart';
import 'package:river_blog/shared/providers.dart';

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
    final String login = state.login;
    final String password = state.password;

    final LoginValidator validator = LoginValidator(
      login: login,
      password: password,
    );

    state = state.copyWith(
      loginError: validator.validateLogin(),
      passwordError: validator.validatePassword(),
    );

    if (validator.hasErrors) {
      return;
    }

    await ref.read(operationRunnerProvider)
      .run((Function(String) describe) async {
        state = state.copyWithoutErrors();

        describe('Отправляю запрос на сервер');
        await Future<void>.delayed(const Duration(seconds: 1));

        describe('Обрабатываю полученные данные');

        if (
          login == 'admin'
          && password == '1234'
        ) {
          await ref.read(userFacadeProvider)
            .login(
              login: login,
              password: password
            );
        }
      });
  }
}
