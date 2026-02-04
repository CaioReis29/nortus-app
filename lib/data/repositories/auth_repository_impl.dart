import 'package:nortus/data/datasources/auth_local_datasource.dart';
import 'package:nortus/data/datasources/auth_remote_datasource.dart';
import 'package:nortus/domain/entities/auth_result.dart';
import 'package:nortus/domain/repositories/auth_repository.dart';
import 'package:flutter_result/flutter_result.dart';
import 'package:nortus/core/exceptions/app_exception.dart';
import 'package:nortus/core/exceptions/api_exception.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;
  final AuthLocalDatasource local;

  AuthRepositoryImpl({required this.remote, required this.local});

  @override
  Future<Result<AuthResult, AppException>> login({
    required String login,
    required String password,
    bool keepConnected = false,
  }) async {
    try {
      await local.setLoggedIn(keepConnected);
      return Result.success(const AuthResult(true));
    } catch (e) {
      return Result.error(ApiException(e.toString()));
    }
  }

  @override
  Future<Result<void, AppException>> logout() async {
    try {
      await local.clear();
      return Result.success(null);
    } catch (e) {
      return Result.error(ApiException(e.toString()));
    }
  }

  @override
  Future<Result<bool, AppException>> isLoggedIn() async {
    try {
      final v = await local.isLoggedIn();
      return Result.success(v);
    } catch (e) {
      return Result.error(ApiException(e.toString()));
    }
  }
}
