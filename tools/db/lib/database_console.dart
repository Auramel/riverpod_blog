import 'dart:io';

import 'package:path/path.dart' as path;

class DatabaseConsole {
  static const String _migrationsDirectory = 'lib/database/migrations';
  static const String _seedersDirectory = 'lib/database/seeders';
  static const String _databaseName = 'river_blog.sqlite';
  static const String _databasePathEnvironment = 'RIVER_BLOG_DATABASE_PATH';

  Future<int> run(List<String> arguments) async {
    try {
      final String command = arguments.isEmpty
        ? 'help'
        : arguments.first;

      if (command == 'help' || command == '--help' || command == '-h') {
        _showHelp();
        return 0;
      }

      if (command == 'migrate') {
        await _migrate(_resolveDatabasePath(arguments));
        return 0;
      }

      if (command == 'status') {
        await _showMigrationStatus(_resolveDatabasePath(arguments));
        return 0;
      }

      if (command == 'fresh') {
        await _migrateFresh(
          databasePath: _resolveDatabasePath(arguments),
          force: arguments.contains('--force'),
        );
        return 0;
      }

      if (command == 'seed') {
        await _seed(_resolveDatabasePath(arguments));
        return 0;
      }

      if (command == 'path') {
        stdout.writeln(_resolveDatabasePath(arguments));
        return 0;
      }

      if (command == 'make:migration') {
        await _makeMigration(_readName(arguments));
        return 0;
      }

      if (command == 'make:seeder') {
        await _makeSeeder(_readName(arguments));
        return 0;
      }

      throw _ConsoleException('Неизвестная команда: $command');
    } on _ConsoleException catch (error) {
      stderr.writeln(error.message);
      return 1;
    }
  }

  Future<void> _migrate(String databasePath) async {
    final List<File> migrations = _sqlFiles(_migrationsDirectory);
    final int currentVersion = await _databaseVersion(databasePath);

    if (currentVersion > migrations.length) {
      throw _ConsoleException(
        'Версия БД $currentVersion выше числа миграций ${migrations.length}',
      );
    }

    if (currentVersion == migrations.length) {
      stdout.writeln('Нет pending-миграций');
      return;
    }

    await Directory(path.dirname(databasePath)).create(recursive: true);

    for (int index = currentVersion; index < migrations.length; index += 1) {
      final File migration = migrations[index];
      final int version = index + 1;
      final String sql = await migration.readAsString();

      await _execute(databasePath, '''
        BEGIN IMMEDIATE;
        $sql
        PRAGMA user_version = $version;
        COMMIT;
      ''');

      stdout.writeln('Migrated: ${path.basename(migration.path)}');
    }
  }

  Future<void> _showMigrationStatus(String databasePath) async {
    final List<File> migrations = _sqlFiles(_migrationsDirectory);
    final int currentVersion = await _databaseVersion(databasePath);

    stdout.writeln('База: $databasePath');

    for (int index = 0; index < migrations.length; index += 1) {
      final String status = index < currentVersion
        ? '[x]'
        : '[ ]';

      stdout.writeln('$status ${path.basename(migrations[index].path)}');
    }
  }

  Future<void> _migrateFresh({
    required String databasePath,
    required bool force,
  }) async {
    if (!force) {
      stdout.write('Удалить БД и все данные? [y/N]: ');
      final String answer = stdin.readLineSync()?.trim().toLowerCase() ?? '';

      if (answer != 'y' && answer != 'yes') {
        stdout.writeln('Отменено');
        return;
      }
    }

    for (final String suffix in ['', '-wal', '-shm']) {
      final File file = File('$databasePath$suffix');

      if (file.existsSync()) {
        file.deleteSync();
      }
    }

    stdout.writeln('База удалена');
    await _migrate(databasePath);
    await _seed(databasePath);
  }

  Future<void> _seed(String databasePath) async {
    if (!File(databasePath).existsSync()) {
      throw const _ConsoleException(
        'База не создана. Сначала выполни dart run db:migrate',
      );
    }

    final List<File> seeders = _sqlFiles(_seedersDirectory);

    for (final File seeder in seeders) {
      final String sql = await seeder.readAsString();

      await _execute(databasePath, '''
        BEGIN IMMEDIATE;
        $sql
        COMMIT;
      ''');

      stdout.writeln('Seeded: ${path.basename(seeder.path)}');
    }
  }

  Future<void> _makeMigration(String name) async {
    final Directory directory = Directory(_migrationsDirectory);
    await directory.create(recursive: true);

    final List<File> migrations = _sqlFiles(_migrationsDirectory);
    final int nextVersion = migrations.isEmpty
      ? 1
      : _migrationVersion(migrations.last) + 1;
    final String fileName = '${nextVersion.toString().padLeft(4, '0')}_${_snakeCase(name)}.sql';
    final File file = File(path.join(directory.path, fileName));

    await file.writeAsString('-- Write migration SQL here.\n');
    stdout.writeln('Created: ${file.path}');
  }

  Future<void> _makeSeeder(String name) async {
    final Directory directory = Directory(_seedersDirectory);
    await directory.create(recursive: true);

    final String normalizedName = _snakeCase(name);
    final String fileName = normalizedName.endsWith('_seeder')
      ? '$normalizedName.sql'
      : '${normalizedName}_seeder.sql';
    final File file = File(path.join(directory.path, fileName));

    if (file.existsSync()) {
      throw _ConsoleException('Сидер уже существует: ${file.path}');
    }

    await file.writeAsString('-- Write seeder SQL here.\n');
    stdout.writeln('Created: ${file.path}');
  }

  Future<int> _databaseVersion(String databasePath) async {
    if (!File(databasePath).existsSync()) {
      return 0;
    }

    final String result = await _execute(databasePath, 'PRAGMA user_version;');
    return int.tryParse(result.trim()) ?? 0;
  }

  Future<String> _execute(String databasePath, String sql) async {
    try {
      final ProcessResult result = await Process.run('sqlite3', [databasePath, sql]);

      if (result.exitCode != 0) {
        throw _ConsoleException(result.stderr.toString().trim());
      }

      return result.stdout.toString();
    } on ProcessException {
      throw const _ConsoleException('sqlite3 не найден в PATH');
    }
  }

  List<File> _sqlFiles(String directoryPath) {
    final Directory directory = Directory(directoryPath);

    if (!directory.existsSync()) {
      return [];
    }

    return directory.listSync()
      .whereType<File>()
      .where((File file) => path.extension(file.path) == '.sql')
      .toList()
      ..sort((File first, File second) => first.path.compareTo(second.path));
  }

  int _migrationVersion(File migration) {
    final String prefix = path.basename(migration.path).split('_').first;
    final int? version = int.tryParse(prefix);

    if (version == null) {
      throw _ConsoleException('Неверное имя миграции: ${migration.path}');
    }

    return version;
  }

  String _readName(List<String> arguments) {
    if (arguments.length < 2 || arguments[1].startsWith('--')) {
      throw const _ConsoleException('Не указано имя');
    }

    return arguments[1];
  }

  String _snakeCase(String value) {
    final String normalized = value
      .trim()
      .replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '')
      .toLowerCase();

    if (normalized.isEmpty) {
      throw const _ConsoleException('Неверное имя');
    }

    return normalized;
  }

  String _resolveDatabasePath(List<String> arguments) {
    for (int index = 0; index < arguments.length; index += 1) {
      final String argument = arguments[index];

      if (argument.startsWith('--database=')) {
        return path.absolute(argument.substring('--database='.length));
      }

      if (argument == '--database' && index + 1 < arguments.length) {
        return path.absolute(arguments[index + 1]);
      }
    }

    final String? environmentPath = Platform.environment[_databasePathEnvironment];

    if (environmentPath != null && environmentPath.isNotEmpty) {
      return path.absolute(environmentPath);
    }

    if (Platform.isMacOS) {
      final String? userDirectory = Platform.environment['HOME'];

      if (userDirectory != null) {
        return path.join(
          userDirectory,
          'Library',
          'Containers',
          'com.example.riverBlog',
          'Data',
          'Documents',
          _databaseName,
        );
      }
    }

    throw const _ConsoleException(
      'Укажи путь через --database=/path/to/database.sqlite',
    );
  }

  void _showHelp() {
    stdout.writeln('''
River Blog database

  dart run db:migrate
  dart run db:status
  dart run db:fresh [--force]
  dart run db:seed
  dart run db:path
  dart run db:make_migration <name>
  dart run db:make_seeder <name>

Options:
  --database=/path/to/database.sqlite
''');
  }
}

class _ConsoleException implements Exception {
  final String message;

  const _ConsoleException(this.message);
}
