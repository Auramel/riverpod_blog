import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/models/user.dart';
import 'package:river_blog/modules/users/providers.dart';

class UsersScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<User>> users = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Пользователи')),
      body: SafeArea(
        child: users.when(
          data: (List<User> users) {
            if (users.isEmpty) {
              return const Center(child: Text('Пользователей нет'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: users.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (BuildContext context, int index) {
                final User user = users[index];
                final List<String> statuses = [
                  if (user.isBanned) 'забанен',
                  if (user.isDeleted) 'удалён',
                ];

                return ListTile(
                  title: Text(user.fullName),
                  subtitle: Text([
                    user.login,
                    _formatDate(user.birthDate),
                    if (statuses.isNotEmpty) statuses.join(', '),
                  ].join(' • ')),
                );
              },
            );
          },
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
