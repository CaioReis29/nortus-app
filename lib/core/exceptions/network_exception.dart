import 'app_exception.dart';

class NetworkException extends Failure {
  const NetworkException(super.message, {super.code});
}
