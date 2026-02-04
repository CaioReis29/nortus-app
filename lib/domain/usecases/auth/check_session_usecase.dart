import 'package:flutter_result/flutter_result.dart';
import 'package:nortus/core/exceptions/app_exception.dart';
import 'package:nortus/domain/repositories/auth_repository.dart';

class CheckSessionUseCase {
  final AuthRepository repository;
  const CheckSessionUseCase(this.repository);

  Future<Result<bool, Failure>> call() {
    return repository.isLoggedIn();
  }
}
