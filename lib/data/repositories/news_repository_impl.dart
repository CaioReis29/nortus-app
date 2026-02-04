import 'dart:convert';
import 'package:flutter_result/flutter_result.dart';
import 'package:nortus/core/exceptions/app_exception.dart';
import 'package:nortus/core/exceptions/api_exception.dart';
import 'package:nortus/core/exceptions/unexpected_exception.dart';
import 'package:nortus/data/datasources/news_remote_datasource.dart';
import 'package:nortus/domain/models/news/news_response.dart';
import 'package:nortus/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDatasource remote;
  NewsRepositoryImpl(this.remote);

  @override
  Future<Result<NewsResponse, Failure>> fetchPage(int page, {int pageSize = 5}) async {
    final res = await remote.getNews(page: page, pageSize: pageSize);
    return res.open(
      (ok) {
        final data = ok?.data;
        if (data is Map<String, dynamic>) {
          return Result.success(NewsResponse.fromJson(data));
        }
        if (data is String) {
          final map = json.decode(data) as Map<String, dynamic>;
          return Result.success(NewsResponse.fromJson(map));
        }
        return Result.error(const UnexpectedException('Formato de resposta inválido'));
      },
      (err) => Result.error(ApiFailure(err?.toString() ?? 'Erro na API')),
    );
  }
}
