import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/core/base/base_router.dart';
import 'package:river_blog/modules/auth/commands/login_commands.dart';
import 'package:river_blog/modules/auth/routers/auth_router.dart';
import 'package:river_blog/modules/auth/states/login_form_state.dart';
import 'package:river_blog/shared/providers.dart';

final NotifierProvider<LoginCommands, LoginFormState> loginCommandsProvider = NotifierProvider.autoDispose<LoginCommands, LoginFormState>(LoginCommands.new);
final Provider<BaseRouter> authRouterProvider = Provider<BaseRouter>((Ref ref) => AuthRouter(
  eventBus: ref.watch(eventBusProvider),
));
