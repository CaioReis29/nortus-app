import 'app_exception.dart';

class AuthException extends Failure {
  const AuthException(super.message, {super.code});
}
