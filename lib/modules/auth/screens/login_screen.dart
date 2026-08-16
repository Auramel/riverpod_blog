import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_blog/modules/auth/commands/login_commands.dart';
import 'package:river_blog/modules/auth/states/login_form_state.dart';

final NotifierProvider<LoginCommands, LoginFormState> _commandsProvider = NotifierProvider.autoDispose<LoginCommands, LoginFormState>(LoginCommands.new);

class LoginScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Авторизация')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .stretch,
            spacing: 20,
            children: [
              TextField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Логин',
                  border: const UnderlineInputBorder(),
                  errorText: ref.watch(_commandsProvider).loginError,
                ),
                onChanged: (String value) => ref.read(_commandsProvider.notifier)
                  .onLoginChanged(value),
              ),
              TextField(
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  border: const UnderlineInputBorder(),
                  errorText: ref.watch(_commandsProvider).passwordError,
                ),
                onChanged: (String value) => ref.read(_commandsProvider.notifier)
                  .onPasswordChanged(value),
                onSubmitted: (String? value) {
                  ref.read(_commandsProvider.notifier).onSubmit();
                },
              ),
              ElevatedButton(
                onPressed: () => ref.read(_commandsProvider.notifier).onSubmit(),
                child: const Text('Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
