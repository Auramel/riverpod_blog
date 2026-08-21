import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import 'package:river_blog/database/sql_loader.dart';

class SqlDatabase {
  final SqlLoader _sqlLoader;

  static const String _name = 'river_blog.sqlite';
  static const String _migrationsDirectory = 'lib/database/migrations';
  static const String _seedersDirectory = 'lib/database/seeders';

  Future<Database>? _database;

  SqlDatabase(this._sqlLoader);

  Future<Database> get instance => _database ??= _open();

  Future<void> close() async {
    final Future<Database>? database = _database;

    if (database == null) {
      return;
    }

    await (await database).close();
    _database = null;
  }

  Future<Database> _open() async {
    final String databasesPath = await getDatabasesPath();
    final List<String> migrations = await _sqlLoader.loadDirectory(_migrationsDirectory);

    return openDatabase(
      path.join(databasesPath, _name),
      version: migrations.length,
      onConfigure: (Database database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (Database database, int version) async {
        await _execute(database, migrations);
        await _execute(
          database,
          await _sqlLoader.loadDirectory(_seedersDirectory),
        );
      },
      onUpgrade: (Database database, int oldVersion, int newVersion) async {
        await _execute(
          database,
          migrations.skip(oldVersion),
        );
      },
    );
  }

  Future<void> _execute(
    Database database,
    Iterable<String> queries,
  ) async {
    for (final String query in queries) {
      await database.execute(query);
    }
  }
}
