abstract class BaseEvent {
  const new();
}

abstract class MessageEvent {
  final String message;

  const new(this.message);
}
