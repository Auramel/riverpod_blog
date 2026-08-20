import 'package:flutter/foundation.dart';

abstract class BaseRouter {
  bool _isInitialized = false;

  new();

  @mustCallSuper
  void init() {
    if (_isInitialized) {
      throw StateError('Router is already initialized');
    }

    _isInitialized = true;
  }

  @mustCallSuper
  void dispose() {
    _isInitialized = false;
  }
}
