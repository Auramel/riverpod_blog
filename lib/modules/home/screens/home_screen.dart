import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:river_blog/core/configs/routes.dart';
import 'package:river_blog/models/user.dart';
import 'package:river_blog/modules/home/commands/home_commands.dart';
import 'package:river_blog/modules/home/providers.dart';
import 'package:river_blog/modules/users/providers.dart';

class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeCommands commands = ref.read(homeCommandsProvider.notifier);
    final AsyncValue<User?> currentUser = ref.watch(currentUserProvider);
    ref.watch(homeCommandsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: SafeArea(
        child: currentUser.when(
          data: (User? user) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: .stretch,
              spacing: 16,
              children: [
                if (user == null)
                  const Text('Профиль в базе не найден')
                else ...[
                  Text(
                    user.fullName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text('Email: ${user.login}'),
                  Text('Дата рождения: ${_formatDate(user.birthDate)}'),
                  Text('Забанен: ${user.isBanned ? 'да' : 'нет'}'),
                  Text('Удалён: ${user.isDeleted ? 'да' : 'нет'}'),
                ],
                const Spacer(),
                ElevatedButton(
                  onPressed: () => context.push(Routes.users),
                  child: const Text('Все пользователи'),
                ),
                ElevatedButton(
                  onPressed: () => commands.logout(),
                  child: const Text('Выйти'),
                ),
              ],
            ),
          ),
          error: (Object error, StackTrace stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.'
      '${date.year}';
  }
}
