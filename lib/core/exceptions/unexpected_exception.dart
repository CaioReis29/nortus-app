import 'app_exception.dart';

class UnexpectedException extends Failure {
  const UnexpectedException(super.message, {super.code});
}
