import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/modules/app/events/loading_events.dart';
import 'package:river_blog/shared/providers.dart';

typedef SetOperationDescription = void Function(String description);
typedef Operation<T> = Future<T> Function(SetOperationDescription describe);

final Provider<OperationRunner> operationRunnerProvider = Provider<OperationRunner>(
  (Ref ref) => OperationRunner._(ref.watch(eventBusProvider)),
);

class OperationRunner {
  final EventBus _eventBus;

  Future<void> _queue = Future<void>.value();
  int _pendingOperations = 0;

  OperationRunner._(this._eventBus);

  Future<T> run<T>(Operation<T> operation) {
    final Completer<T> completer = Completer<T>();

    _pendingOperations += 1;
    _queue = _queue.then((_) => _execute(
      operation: operation,
      completer: completer,
    ));

    return completer.future;
  }

  Future<void> _execute<T>({
    required Operation<T> operation,
    required Completer<T> completer,
  }) async {
    _eventBus.fire(const LoadingStartedEvent());

    try {
      final T result = await operation(_describe);

      completer.complete(result);
    } catch (error, stackTrace) {
      completer.completeError(error, stackTrace);
    } finally {
      _pendingOperations -= 1;

      if (_pendingOperations == 0) {
        _eventBus.fire(const LoadingFinishedEvent());
      }
    }
  }

  void _describe(String description) {
    _eventBus.fire(LoadingProgressEvent(description));
  }
}
