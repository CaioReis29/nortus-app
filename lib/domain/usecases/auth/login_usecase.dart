import 'package:flutter_result/flutter_result.dart';
import 'package:nortus/core/exceptions/app_exception.dart';
import 'package:nortus/domain/entities/auth_result.dart';
import 'package:nortus/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  const LoginUseCase(this.repository);

  Future<Result<AuthResult, Failure>> call({
    required String login,
    required String password,
    bool keepConnected = false,
  }) {
    return repository.login(login: login, password: password, keepConnected: keepConnected);
  }
}
