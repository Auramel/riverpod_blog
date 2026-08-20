import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/modules/app/states/app_state.dart';

class AppCommands extends Notifier<AppState> {
  @override
  AppState build() {
    return const AppState();
  }
}
