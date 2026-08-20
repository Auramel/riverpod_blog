abstract class BaseEvent {
  const new();
}

abstract class MessageEvent extends BaseEvent {
  final String message;

  const new(this.message);
}
