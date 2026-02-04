import 'package:dio/dio.dart';
import 'package:flutter_result/flutter_result.dart';
import 'package:nortus/core/exceptions/api_exception.dart';
import 'package:nortus/core/exceptions/network_exception.dart';
import 'package:nortus/core/exceptions/unexpected_exception.dart';

class HttpClient {
  final Dio dio;
  HttpClient(this.dio);

  Future<Result<Response, Exception>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final res = await dio.get(path, queryParameters: queryParameters, options: options);
      if (_ok(res.statusCode)) return Result.success(res);
      return Result.error(ApiFailure('Request failed', code: res.statusCode));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.receiveTimeout) {
        return Result.error(const NetworkException('Network error'));
      }
      return Result.error(ApiFailure(e.message ?? 'API error', code: e.response?.statusCode));
    } catch (e) {
      return Result.error(UnexpectedException(e.toString()));
    }
  }

  Future<Result<Response, Exception>> post(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    try {
      final res = await dio.post(path, data: data, options: options);
      if (_ok(res.statusCode)) return Result.success(res);
      return Result.error(ApiFailure('Request failed', code: res.statusCode));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.receiveTimeout) {
        return Result.error(const NetworkException('Network error'));
      }
      return Result.error(ApiFailure(e.message ?? 'API error', code: e.response?.statusCode));
    } catch (e) {
      return Result.error(UnexpectedException(e.toString()));
    }
  }

  bool _ok(int? code) => code != null && code >= 200 && code < 300;
}
