import 'package:river_blog/modules/app/states/auth_state.dart';

class AppState {
  final AuthState authState;

  factory AppState.initial({
    required AuthState authState,
  }) {
    return AppState(
      authState: authState,
    );
  }

  const new({
    required this.authState
  });

  AppState copyWith({
    AuthState? authState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
    );
  }
}
