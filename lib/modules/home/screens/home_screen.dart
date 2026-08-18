import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/modules/home/commands/home_commands.dart';
import 'package:river_blog/modules/home/providers.dart';

class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeCommands commands = ref.read(homeCommandsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .stretch,
            spacing: 20,
            children: [
              const Text('Welcome to the Home screen'),
              ElevatedButton(
                onPressed: () => commands.logout(),
                child: const Text('Logged out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
