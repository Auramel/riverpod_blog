import 'dart:io';

import 'package:db/database_console.dart';

Future<void> runDatabaseCommand(String command, List<String> arguments) async {
  if (arguments.contains('--help') || arguments.contains('-h')) {
    exitCode = await DatabaseConsole().run(['help']);
    return;
  }

  exitCode = await DatabaseConsole().run([command, ...arguments]);
}
