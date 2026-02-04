import 'package:nortus/data/datasources/auth_local_datasource.dart';
import 'package:nortus/data/datasources/auth_remote_datasource.dart';
import 'package:nortus/domain/entities/auth_result.dart';
import 'package:nortus/domain/repositories/auth_repository.dart';
import 'package:flutter_result/flutter_result.dart';
import 'package:nortus/core/exceptions/app_exception.dart';
import 'package:nortus/core/exceptions/api_exception.dart';
import 'package:nortus/core/network/connectivity_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;
  final AuthLocalDatasource local;
  final ConnectivityService connectivity;

  AuthRepositoryImpl({required this.remote, required this.local, required this.connectivity});

  @override
  Future<Result<AuthResult, Failure>> login({
    required String login,
    required String password,
    bool keepConnected = false,
  }) async {
    try {
      if (!keepConnected) {
        final hasNet = await connectivity.hasInternet();
        if (!hasNet) {
          return Result.error(const ApiFailure('Sem conexão com a internet'));
        }
        final res = await remote.authenticate(login: login, password: password);
        if (res.isSuccess) {
          await local.setLoggedIn(true);
          return Result.success(const AuthResult(true));
        }
        await local.setLoggedIn(false);
        return Result.error(const ApiFailure('Authentication failed'));
      }
      await local.setLoggedIn(true);
      return Result.success(const AuthResult(true));
    } catch (e) {
      return Result.error(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> logout() async {
    try {
      await local.clear();
      return Result.success(null);
    } catch (e) {
      return Result.error(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool, Failure>> isLoggedIn() async {
    try {
      final v = await local.isLoggedIn();
      return Result.success(v);
    } catch (e) {
      return Result.error(ApiFailure(e.toString()));
    }
  }
}
