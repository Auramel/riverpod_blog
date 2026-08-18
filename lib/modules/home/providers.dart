import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/core/base/empty_state.dart';
import 'package:river_blog/modules/home/commands/home_commands.dart';

final NotifierProvider<HomeCommands, EmptyState> homeCommandsProvider = NotifierProvider<HomeCommands, EmptyState>(HomeCommands.new);
