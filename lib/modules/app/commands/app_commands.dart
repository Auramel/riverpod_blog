import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/facades/user_facade.dart';
import 'package:river_blog/modules/app/states/app_state.dart';
import 'package:river_blog/modules/app/states/auth_state.dart';
import 'package:river_blog/shared/providers.dart';

class AppCommands extends Notifier<AppState> {
  @override
  AppState build() {
    final UserFacade userFacade = ref.read(userFacadeProvider);

    final AuthState authState = userFacade.isLoggedIn
      ? AuthState.loggedIn()
      : AuthState.notLoggedIn();

    return AppState.initial(
      authState: authState,
    );
  }

  void login() {
    state = state.copyWith(
      authState: AuthState.loggedIn(),
    );
  }

  void logout() {
    state = state.copyWith(
      authState: AuthState.loggedOut(),
    );
  }
}
