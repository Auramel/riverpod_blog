import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:river_blog/core/configs/routes.dart';
import 'package:river_blog/modules/auth/commands/registration_commands.dart';
import 'package:river_blog/modules/auth/providers.dart';
import 'package:river_blog/modules/auth/states/registration_form_state.dart';

class RegistrationScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RegistrationCommands commands = ref.read(registrationCommandsProvider.notifier);
    final RegistrationFormState state = ref.watch(registrationCommandsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: state.loginError,
              ),
              onChanged: commands.onLoginChanged,
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Пароль',
                errorText: state.passwordError,
              ),
              onChanged: commands.onPasswordChanged,
            ),
            const SizedBox(height: 16),
            TextField(
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'ФИО',
                errorText: state.fullNameError,
              ),
              onChanged: commands.onFullNameChanged,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                final DateTime? birthDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  initialDate: state.birthDate ?? DateTime(2000),
                );

                if (birthDate == null || !context.mounted) {
                  return;
                }

                commands.onBirthDateChanged(birthDate);
              },
              child: Text(state.birthDate == null
                ? 'Дата рождения'
                : _formatDate(state.birthDate!),
              ),
            ),
            if (state.birthDateError != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: Text(
                  state.birthDateError!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: commands.onSubmit,
              child: const Text('Зарегистрироваться'),
            ),
            TextButton(
              onPressed: () => context.replace(Routes.login),
              child: const Text('Уже есть аккаунт'),
            ),
          ],
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
