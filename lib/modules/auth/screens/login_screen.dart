import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_blog/modules/auth/commands/login_commands.dart';
import 'package:river_blog/modules/auth/states/login_form_state.dart';

final _loginCommandsProvider =
    NotifierProvider.autoDispose<LoginCommands, LoginFormState>(
      LoginCommands.new,
    );

class LoginScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canSubmit = ref.watch(
      _loginCommandsProvider.select((state) => state.canSubmit),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .stretch,
            spacing: 20,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Login',
                  border: UnderlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                onChanged: (value) => ref
                    .read(_loginCommandsProvider.notifier)
                    .onLoginChanged(value),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: UnderlineInputBorder(),
                ),
                obscureText: true,
                textInputAction: TextInputAction.done,
                onChanged: (value) => ref
                    .read(_loginCommandsProvider.notifier)
                    .onPasswordChanged(value),
                onSubmitted: (_) {
                  if (canSubmit) {
                    ref.read(_loginCommandsProvider.notifier).onSubmit();
                  }
                },
              ),
              ElevatedButton(
                onPressed: canSubmit
                    ? () => ref
                        .read(_loginCommandsProvider.notifier)
                        .onSubmit()
                    : null,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
