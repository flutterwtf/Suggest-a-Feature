class Wrapper<T> {
  final T? data;
  final int status;

  static final int statusSuccess = 200;
  static final int statusError = 500;

  Wrapper({this.data, this.status = 200});

  bool success() {
    return status >= 200 && status < 400;
  }
}
