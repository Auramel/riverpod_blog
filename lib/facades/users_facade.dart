import 'package:river_blog/models/user.dart';
import 'package:river_blog/modules/users/exceptions/user_exceptions.dart';
import 'package:river_blog/repositories/users/users_repository.dart';

class UsersFacade {
  final UsersRepository _repository;

  const UsersFacade(this._repository);

  Future<List<User>> getAll() => _repository.getAll();

  Future<User?> getByLogin(String login) => _repository.getByLogin(login);

  Future<User?> authenticate({
    required String login,
    required String password,
  }) async {
    final User? user = await _repository.findByCredentials(
      login: login,
      password: password,
    );

    if (user == null) {
      return null;
    }

    if (user.isBanned) {
      throw const UserBannedException();
    }

    return user;
  }

  Future<void> register({
    required String login,
    required String password,
    required String fullName,
    required DateTime birthDate,
  }) async {
    final bool isCreated = await _repository.create(
      login: login,
      password: password,
      fullName: fullName,
      birthDate: birthDate,
    );

    if (!isCreated) {
      throw const UserAlreadyExistsException();
    }
  }
}
