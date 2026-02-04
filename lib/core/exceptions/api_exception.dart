import 'app_exception.dart';

class ApiFailure extends Failure {
  const ApiFailure(super.message, {super.code});
}
