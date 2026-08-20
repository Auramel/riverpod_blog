import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

import 'package:river_blog/core/base/base_events.dart';

class LoggerFacade {
  final Talker _talker;

  LoggerFacade(): _talker = TalkerFlutter.init();

  ProviderObserver riverpodObserver() {
    return TalkerRiverpodObserver(
      talker: _talker,
    );
  }

  void event(BaseEvent event) {
    if (event is MessageEvent) {
      _talker.info('CREATED EVENT [${event.runtimeType}] [${event.message}]');
      return;
    }

    _talker.info('CREATED EVENT [${event.runtimeType}]');
  }
}
