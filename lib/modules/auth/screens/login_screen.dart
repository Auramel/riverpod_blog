import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:river_blog/core/configs/routes.dart';
import 'package:river_blog/modules/auth/commands/login_commands.dart';
import 'package:river_blog/modules/auth/providers.dart';
import 'package:river_blog/modules/auth/states/login_form_state.dart';

class LoginScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginCommands commands = ref.read(loginCommandsProvider.notifier);
    final LoginFormState state = ref.watch(loginCommandsProvider);

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
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const UnderlineInputBorder(),
                  errorText: state.loginError,
                ),
                onChanged: (String value) => commands.onLoginChanged(value),
              ),
              TextField(
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  border: const UnderlineInputBorder(),
                  errorText: state.passwordError,
                ),
                onChanged: (String value) => commands.onPasswordChanged(value),
                onSubmitted: (String? value) => commands.onSubmit(),
              ),
              ElevatedButton(
                onPressed: () => commands.onSubmit(),
                child: const Text('Войти'),
              ),
              TextButton(
                onPressed: () => context.replace(Routes.registration),
                child: const Text('Зарегистрироваться'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
