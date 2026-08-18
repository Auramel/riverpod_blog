import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/modules/auth/commands/login_commands.dart';
import 'package:river_blog/modules/auth/states/login_form_state.dart';

final NotifierProvider<LoginCommands, LoginFormState> loginCommandsProvider = NotifierProvider.autoDispose<LoginCommands, LoginFormState>(LoginCommands.new);
