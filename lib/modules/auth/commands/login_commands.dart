import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_blog/modules/auth/states/login_form_state.dart';

class LoginCommands extends Notifier<LoginFormState> {
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

  void onSubmit() {
    if (!state.canSubmit) {
      return;
    }

    // TODO: Execute the login use case.
  }
}
