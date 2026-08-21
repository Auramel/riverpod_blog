import 'package:flutter/material.dart';

abstract class BottomSheetResult {
  const new();
}

class CustomBottomSheet extends StatelessWidget {
  final Widget child;

  const new({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: child,
      ),
    );
  }
}
