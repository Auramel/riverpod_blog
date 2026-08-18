import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SetLoadingDescription = void Function(String description);
typedef LoadingTask<T> = Future<T> Function(SetLoadingDescription describe);

final NotifierProvider<_LoadingCommands, _LoadingState> _loadingProvider = NotifierProvider<_LoadingCommands, _LoadingState>(_LoadingCommands.new);

abstract class Loading {
  static Future<T> run<T>(Ref ref, LoadingTask<T> task) {
    return ref.read(_loadingProvider.notifier).run(task);
  }
}

class _LoadingState {
  final bool isLoading;
  final String? description;

  const _LoadingState.hidden():
    isLoading = false,
    description = null;

  const _LoadingState.visible([this.description]):
    isLoading = true;
}


class LoadingHost extends ConsumerWidget {
  final Widget child;

  const new({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _LoadingState state = ref.watch(_loadingProvider);

    return LoadingOverlay(
      isLoading: state.isLoading,
      description: state.description,
      child: child,
    );
  }
}

class _LoadingCommands extends Notifier<_LoadingState> {
  @override
  _LoadingState build() => const _LoadingState.hidden();

  Future<T> run<T>(LoadingTask<T> task) async {
    if (state.isLoading) {
      throw StateError('A loading operation is already running');
    }

    state = const _LoadingState.visible();

    try {
      return await task(_setDescription);
    } finally {
      if (ref.mounted) {
        state = const _LoadingState.hidden();
      }
    }
  }

  void _setDescription(String description) {
    if (ref.mounted) {
      state = _LoadingState.visible(description);
    }
  }
}

class LoadingOverlay extends StatelessWidget {
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
