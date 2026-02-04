import 'package:nortus/domain/models/auth_result.dart';
import 'package:flutter_result/flutter_result.dart';
import 'package:nortus/core/exceptions/app_exception.dart';

abstract class AuthRepository {
  Future<Result<AuthResult, Failure>> login({
    required String login,
    required String password,
    bool keepConnected = false,
  });
  Future<Result<void, Failure>> logout();
  Future<Result<bool, Failure>> isLoggedIn();
}
