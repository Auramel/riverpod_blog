import 'package:river_blog/core/base/base_commands.dart';
import 'package:river_blog/facades/user_facade.dart';
import 'package:river_blog/facades/users_facade.dart';
import 'package:river_blog/modules/auth/states/registration_form_state.dart';
import 'package:river_blog/modules/auth/validators/registration_validator.dart';
import 'package:river_blog/modules/users/exceptions/user_exceptions.dart';
import 'package:river_blog/modules/users/providers.dart';
import 'package:river_blog/shared/providers.dart';

class RegistrationCommands extends BaseCommands<RegistrationFormState> {
  @override
  RegistrationFormState build() {
    return RegistrationFormState.empty();
  }

  void onLoginChanged(String value) {
    state = state.copyWith(login: value);
  }

  void onPasswordChanged(String value) {
    state = state.copyWith(password: value);
  }

  void onFullNameChanged(String value) {
    state = state.copyWith(fullName: value);
  }

  void onBirthDateChanged(DateTime value) {
    state = state.copyWith(birthDate: value);
  }

  Future<void> onSubmit() async {
    final RegistrationValidator validator = RegistrationValidator(
      login: state.login,
      password: state.password,
      fullName: state.fullName,
      birthDate: state.birthDate,
    );

    state = state.copyWithoutErrors().copyWith(
      loginError: validator.validateLogin(),
      passwordError: validator.validatePassword(),
      fullNameError: validator.validateFullName(),
      birthDateError: validator.validateBirthDate(),
    );

    if (validator.hasErrors) {
      return;
    }

    final String login = state.login.trim();
    final String password = state.password;
    final UsersFacade usersFacade = ref.read(usersFacadeProvider);
    final UserFacade userFacade = ref.read(userFacadeProvider);

    state = state.copyWithoutErrors();

    try {
      await usersFacade.register(
        login: login,
        password: password,
        fullName: state.fullName.trim(),
        birthDate: state.birthDate!,
      );
    } on UserAlreadyExistsException {
      if (!ref.mounted) {
        return;
      }

      state = state.copyWith(loginError: 'Такой email уже занят');

      return;
    }

    if (!ref.mounted) {
      return;
    }

    await userFacade.login(
      login: login,
      password: password,
    );
  }
}
