import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:river_blog/core/configs/router.dart';

final GoRouter router = createRouter();

class AppLayout extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
