import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/core/base/base_router.dart';
import 'package:river_blog/facades/users_facade.dart';
import 'package:river_blog/models/user.dart';
import 'package:river_blog/modules/users/routers/users_router.dart';
import 'package:river_blog/repositories/users/users_repository.dart';
import 'package:river_blog/shared/providers.dart';

final Provider<UsersRepository> usersRepositoryProvider = Provider<UsersRepository>((Ref ref) => UsersRepository(
  ref.watch(sqlDatabaseProvider),
  ref.watch(sqlLoaderProvider),
));

final Provider<UsersFacade> usersFacadeProvider = Provider<UsersFacade>((Ref ref) => UsersFacade(
  ref.watch(usersRepositoryProvider),
));

final FutureProvider<List<User>> usersProvider = FutureProvider.autoDispose<List<User>>((Ref ref) => (
  ref.watch(usersFacadeProvider).getAll()
));

final FutureProvider<User?> currentUserProvider = FutureProvider.autoDispose<User?>((Ref ref) {
  final String? login = ref.watch(userFacadeProvider).currentLogin;

  if (login == null) {
    return Future<User?>.value();
  }

  return ref.watch(usersFacadeProvider).getByLogin(login);
});

final Provider<BaseRouter> usersRouterProvider = Provider<BaseRouter>((Ref ref) => UsersRouter());
