import 'dart:async';

class SimpleBehaviorSubject<T> {
  SimpleBehaviorSubject(T value) {
    _controller.onListen = () => _controller.add(this.value);
    this.value = value;
  }

  final _controller = StreamController<T>.broadcast();

  late T _value;

  T get value => _value;

  set value(T newValue) {
    _value = newValue;
    _controller.add(_value);
  }

  Stream<T> stream() => _controller.stream;

  void close() => _controller.close();
}
