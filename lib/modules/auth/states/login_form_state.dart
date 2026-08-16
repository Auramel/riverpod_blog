import 'package:river_blog/core/base/form_state.dart';

class LoginFormState extends FormState {
  final String login;
  final String? loginError;

  final String password;
  final String? passwordError;

  factory LoginFormState.empty() {
    return const LoginFormState(
      login: '',
      password: '',
      loginError: null,
      passwordError: null,
    );
  }

  const new({
    required this.login,
    required this.loginError,
    required this.password,
    required this.passwordError,
  });

  @override
  LoginFormState copyWith({
    String? login,
    String? password,
    String? loginError,
    String? passwordError,
  }) {
    return LoginFormState(
      login: login ?? this.login,
      password: password ?? this.password,
      loginError: loginError ?? this.loginError,
      passwordError: passwordError ?? this.passwordError,
    );
  }

  @override
  LoginFormState copyWithoutErrors() {
    return LoginFormState(
      login: login,
      password: password,
      loginError: null,
      passwordError: null,
    );
  }
}
