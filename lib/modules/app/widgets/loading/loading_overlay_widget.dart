import 'package:flutter/material.dart';

class LoadingOverlayWidget extends StatelessWidget {
  final bool isLoading;
  final String? description;
  final Widget child;

  const new({
    required this.isLoading,
    required this.description,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          const ModalBarrier(
            dismissible: false,
            color: Colors.black38,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 32,
              ),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 32,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  Text(
                    description ?? 'Loading...',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
