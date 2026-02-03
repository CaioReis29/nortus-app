import 'package:nortus/domain/entities/auth_result.dart';
import 'package:flutter_result/flutter_result.dart';
import 'package:nortus/core/exceptions/app_exception.dart';

abstract class AuthRepository {
  Future<Result<AuthResult, AppException>> login({required String login, required String password});
  Future<Result<void, AppException>> logout();
  Future<Result<bool, AppException>> isLoggedIn();
}
