import 'package:river_blog/core/base/base_commands.dart';
import 'package:river_blog/facades/user_facade.dart';
import 'package:river_blog/facades/users_facade.dart';
import 'package:river_blog/models/user.dart';
import 'package:river_blog/modules/auth/states/login_form_state.dart';
import 'package:river_blog/modules/auth/validators/login_validator.dart';
import 'package:river_blog/modules/users/exceptions/user_exceptions.dart';
import 'package:river_blog/modules/users/providers.dart';
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

    state = state.copyWithoutErrors().copyWith(
      loginError: validator.validateLogin(),
      passwordError: validator.validatePassword(),
    );

    if (validator.hasErrors) {
      return;
    }

    final UsersFacade usersFacade = ref.read(usersFacadeProvider);
    final UserFacade userFacade = ref.read(userFacadeProvider);

    state = state.copyWithoutErrors();

    try {
      final User? user = await usersFacade.authenticate(
        login: login,
        password: password,
      );

      if (!ref.mounted) {
        return;
      }

      if (user == null) {
        state = state.copyWith(passwordError: 'Неверный логин или пароль');
        return;
      }

      await userFacade.login(
        login: login,
        password: password,
      );
    } on UserBannedException {
      if (ref.mounted) {
        state = state.copyWith(loginError: 'Пользователь заблокирован');
      }
    }
  }
}
