import 'package:river_blog/core/base/base_events.dart';

final class LoadingStartedEvent extends BaseEvent {
  const new();
}

final class LoadingProgressEvent extends MessageEvent {
  const new(super.description);
}

final class LoadingFinishedEvent extends BaseEvent {
  const new();
}
