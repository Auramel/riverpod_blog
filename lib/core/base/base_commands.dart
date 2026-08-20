import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/core/base/base_state.dart';

abstract class BaseCommands<T extends BaseState> extends Notifier<T> {}
