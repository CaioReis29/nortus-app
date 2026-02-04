import 'package:flutter_result/flutter_result.dart';
import 'package:dio/dio.dart';
import 'package:nortus/core/network/http_client.dart';

class NewsRemoteDatasource {
  final HttpClient client;
  NewsRemoteDatasource(this.client);

  Future<Result<Response, Exception>> getNews({required int page, int pageSize = 5}) {
    return client.get('/news', queryParameters: {'page': page, 'pageSize': pageSize});
  }
}
