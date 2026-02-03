import 'package:dio/dio.dart';
import 'package:flutter_result/flutter_result.dart';
import 'package:nortus/core/network/http_client.dart';

class AuthRemoteDatasource {
  final HttpClient client;
  AuthRemoteDatasource(this.client);

  Future<Result<Response, Exception>> authenticate({
    required String login,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 3));
    return client.post(
      '/auth',
      data: {
        'login': login,
        'password': password,
      },
    );
  }
}
