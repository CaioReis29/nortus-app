import 'app_exception.dart';

class UnexpectedException extends AppException {
  const UnexpectedException(super.message, {super.code});
}
