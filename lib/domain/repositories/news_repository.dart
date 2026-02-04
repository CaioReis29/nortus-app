import 'package:flutter_result/flutter_result.dart';
import 'package:nortus/core/exceptions/app_exception.dart';
import 'package:nortus/domain/models/news/news_response.dart';

abstract class NewsRepository {
  Future<Result<NewsResponse, Failure>> fetchPage(int page, {int pageSize = 5});
}
