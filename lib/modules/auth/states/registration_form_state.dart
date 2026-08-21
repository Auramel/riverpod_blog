import 'package:river_blog/core/base/form_state.dart';

class RegistrationFormState extends FormState {
  final String login;
  final String? loginError;

  final String password;
  final String? passwordError;

  final String fullName;
  final String? fullNameError;

  final DateTime? birthDate;
  final String? birthDateError;

  factory RegistrationFormState.empty() {
    return const RegistrationFormState(
      login: '',
      loginError: null,
      password: '',
      passwordError: null,
      fullName: '',
      fullNameError: null,
      birthDate: null,
      birthDateError: null,
    );
  }

  const new({
    required this.login,
    required this.loginError,
    required this.password,
    required this.passwordError,
    required this.fullName,
    required this.fullNameError,
    required this.birthDate,
    required this.birthDateError,
  });

  @override
  RegistrationFormState copyWith({
    String? login,
    String? loginError,
    String? password,
    String? passwordError,
    String? fullName,
    String? fullNameError,
    DateTime? birthDate,
    String? birthDateError,
  }) {
    return RegistrationFormState(
      login: login ?? this.login,
      loginError: loginError ?? this.loginError,
      password: password ?? this.password,
      passwordError: passwordError ?? this.passwordError,
      fullName: fullName ?? this.fullName,
      fullNameError: fullNameError ?? this.fullNameError,
      birthDate: birthDate ?? this.birthDate,
      birthDateError: birthDateError ?? this.birthDateError,
    );
  }

  @override
  RegistrationFormState copyWithoutErrors() {
    return RegistrationFormState(
      login: login,
      loginError: null,
      password: password,
      passwordError: null,
      fullName: fullName,
      fullNameError: null,
      birthDate: birthDate,
      birthDateError: null,
    );
  }
}
