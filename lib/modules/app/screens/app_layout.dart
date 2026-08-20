import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:river_blog/core/ui/loading.dart';
import 'package:river_blog/modules/app/providers.dart';

class AppLayout extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      builder: (BuildContext context, Widget? child) => LoadingHost(
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
