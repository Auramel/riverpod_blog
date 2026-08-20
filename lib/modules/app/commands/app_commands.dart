import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/core/events/auth_event.dart';
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

    _initEventCallbacks();

    return AppState.initial(
      authState: authState,
    );
  }

  void _initEventCallbacks() {
    final EventBus eventBus = ref.read(eventBusProvider);

    final StreamSubscription<UserLoggedInEvent> userLoggedInSubscription = eventBus.on<UserLoggedInEvent>().listen(_onUserLoggedIn);
    final StreamSubscription<UserLoggedOutEvent> userLoggedOutSubscription = eventBus.on<UserLoggedOutEvent>().listen(_onUserLoggedOut);

    ref.onDispose(() {
      userLoggedInSubscription.cancel();
      userLoggedOutSubscription.cancel();
    });
  }

  void _onUserLoggedIn(UserLoggedInEvent event) {
    state = state.copyWith(
      authState: AuthState.loggedIn()
    );
  }

  void _onUserLoggedOut(UserLoggedOutEvent event) {
    state = state.copyWith(
      authState: AuthState.loggedOut()
    );
  }
}
