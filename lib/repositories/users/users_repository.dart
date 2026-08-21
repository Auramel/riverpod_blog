import 'package:sqflite/sqflite.dart';

import 'package:river_blog/database/sql_database.dart';
import 'package:river_blog/database/sql_loader.dart';
import 'package:river_blog/database/tables/users_table.dart';
import 'package:river_blog/models/user.dart';

class UsersRepository {
  final SqlDatabase _database;
  final SqlLoader _sqlLoader;

  static const String _isExistsColumn = 'is_exists';
  static const String _selectUsersSql = 'lib/repositories/users/sql/select_users.sql';
  static const String _selectUserByLoginSql = 'lib/repositories/users/sql/select_user_by_login.sql';
  static const String _selectUserByCredentialsSql = 'lib/repositories/users/sql/select_user_by_credentials.sql';
  static const String _selectUserByLoginExistsSql = 'lib/repositories/users/sql/select_user_by_login_exists.sql';
  static const String _insertUserSql = 'lib/repositories/users/sql/insert_user.sql';

  const UsersRepository(
    this._database,
    this._sqlLoader,
  );

  Future<List<User>> getAll() async {
    final Database database = await _database.instance;
    final String sql = await _sqlLoader.load(_selectUsersSql);
    final List<Map<String, Object?>> rows = await database.rawQuery(sql);

    return rows.map(_map).toList();
  }

  Future<User?> getByLogin(String login) async {
    final Database database = await _database.instance;
    final String sql = await _sqlLoader.load(_selectUserByLoginSql);
    final List<Map<String, Object?>> rows = await database.rawQuery(sql, [login]);

    return rows.isEmpty
      ? null
      : _map(rows.first);
  }

  Future<User?> findByCredentials({
    required String login,
    required String password,
  }) async {
    final Database database = await _database.instance;
    final String sql = await _sqlLoader.load(_selectUserByCredentialsSql);
    final List<Map<String, Object?>> rows = await database.rawQuery(sql, [login, password]);

    return rows.isEmpty
      ? null
      : _map(rows.first);
  }

  Future<bool> create({
    required String login,
    required String password,
    required String fullName,
    required DateTime birthDate,
  }) async {
    final String existsByLoginSql = await _sqlLoader.load(_selectUserByLoginExistsSql);
    final String insertSql = await _sqlLoader.load(_insertUserSql);
    final Database database = await _database.instance;

    return database.transaction((Transaction transaction) async {
      if (await _exists(
        transaction: transaction,
        sql: existsByLoginSql,
        value: login,
      )) {
        return false;
      }

      await transaction.rawInsert(insertSql, [
        login,
        password,
        fullName,
        birthDate.toIso8601String(),
      ]);

      return true;
    });
  }

  Future<bool> _exists({
    required Transaction transaction,
    required String sql,
    required String value,
  }) async {
    final List<Map<String, Object?>> rows = await transaction.rawQuery(sql, [value]);

    return rows.first[_isExistsColumn] == 1;
  }

  User _map(Map<String, Object?> row) {
    return User(
      id: row[UsersTable.id]! as int,
      login: row[UsersTable.login]! as String,
      fullName: row[UsersTable.fullName]! as String,
      birthDate: _mapDate(row[UsersTable.birthDate]!),
      isBanned: row[UsersTable.isBanned] == 1,
      isDeleted: row[UsersTable.isDeleted] == 1,
    );
  }

  DateTime _mapDate(Object value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    }

    return DateTime.parse(value as String);
  }
}
