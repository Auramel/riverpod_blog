import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:river_blog/core/configs/router.dart';
import 'package:river_blog/core/ui/loading.dart';

final GoRouter router = createRouter();

class AppLayout extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      builder: (BuildContext context, Widget? child) => LoadingHost(
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
