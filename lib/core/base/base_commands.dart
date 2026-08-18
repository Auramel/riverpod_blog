import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/core/ui/loading.dart';

abstract class BaseCommands<State> extends Notifier<State> {
  Future<T> loading<T>(LoadingTask<T> task) {
    return Loading.run(ref, task);
  }
}
