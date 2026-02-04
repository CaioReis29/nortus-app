abstract class Failure implements Exception {
  final String message;
  final int? code;
  const Failure(this.message, {this.code});

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}
