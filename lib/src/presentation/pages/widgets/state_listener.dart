import 'package:flutter/material.dart';

class StateListener<T> extends StatefulWidget {
  final T state;
  final Widget child;
  final ValueChanged<T>? listener;
  final bool Function(T, T)? listenWhen;

  const StateListener({
    required this.state,
    required this.child,
    super.key,
    this.listener,
    this.listenWhen,
  });

  @override
  State<StateListener<T>> createState() => _StateListenerState<T>();
}

class _StateListenerState<T> extends State<StateListener<T>> {
  @override
  void didUpdateWidget(StateListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.listener != null &&
        (widget.listenWhen == null ||
            widget.listenWhen!(oldWidget.state, widget.state))) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => widget.listener!(widget.state));
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
