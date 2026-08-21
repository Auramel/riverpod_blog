import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/core/base/base_router.dart';
import 'package:river_blog/core/base/empty_state.dart';
import 'package:river_blog/modules/home/commands/home_commands.dart';
import 'package:river_blog/modules/home/routers/home_router.dart';
import 'package:river_blog/shared/providers.dart';

final NotifierProvider<HomeCommands, EmptyState> homeCommandsProvider = NotifierProvider.autoDispose<HomeCommands, EmptyState>(HomeCommands.new);
final Provider<BaseRouter> homeRouterProvider = Provider<BaseRouter>((Ref ref) => HomeRouter(
  eventBus: ref.watch(eventBusProvider),
));
