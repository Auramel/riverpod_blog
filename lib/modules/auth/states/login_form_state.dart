class LoginFormState {
  final String login;
  final String password;

  bool get canSubmit => login.trim().isNotEmpty && password.isNotEmpty;

  factory LoginFormState.empty() {
    return const LoginFormState(
      login: '',
      password: '',
    );
  }

  const LoginFormState({
    required this.login,
    required this.password,
  });

  LoginFormState copyWith({
    String? login,
    String? password,
  }) {
    return LoginFormState(
      login: login ?? this.login,
      password: password ?? this.password,
    );
  }
}
