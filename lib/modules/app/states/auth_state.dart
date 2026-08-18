enum Status {
  loggedIn,
  notLoggedIn,
  loggedOut,
}

class AuthState {
  final Status status;

  factory AuthState.loggedIn() {
    return const AuthState(
      status: Status.loggedIn,
    );
  }

  factory AuthState.notLoggedIn() {
    return const AuthState(
      status: Status.notLoggedIn,
    );
  }

  factory AuthState.loggedOut() {
    return const AuthState(
      status: Status.loggedOut,
    );
  }

  const new({
    required this.status,
  });

  AuthState copyWith({
    Status? status,
  }) {
    return AuthState(
      status: status ?? this.status,
    );
  }
}
