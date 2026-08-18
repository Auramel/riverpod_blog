import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/modules/app/commands/app_commands.dart';
import 'package:river_blog/modules/app/states/app_state.dart';

final NotifierProvider<AppCommands, AppState> appCommandsProvider = NotifierProvider<AppCommands, AppState>(AppCommands.new);
