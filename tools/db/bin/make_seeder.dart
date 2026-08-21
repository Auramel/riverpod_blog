import 'package:db/run_database_command.dart';

Future<void> main(List<String> arguments) async {
  await runDatabaseCommand('make:seeder', arguments);
}
