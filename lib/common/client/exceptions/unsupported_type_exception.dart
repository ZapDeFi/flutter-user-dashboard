class UnsupportedTypeException implements Exception {
  final dynamic message;

  UnsupportedTypeException([this.message]);

  @override
  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
