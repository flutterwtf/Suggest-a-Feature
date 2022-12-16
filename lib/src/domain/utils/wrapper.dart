import 'package:equatable/equatable.dart';

class Wrapper<T> extends Equatable {
  final T? data;
  final int status;

  static final int statusSuccess = 200;
  static final int statusError = 500;

  Wrapper({this.data, this.status = 200});

  bool success() {
    return status >= 200 && status < 400;
  }

  @override
  List<Object?> get props => <Object?>[
        data,
        status,
      ];
}
