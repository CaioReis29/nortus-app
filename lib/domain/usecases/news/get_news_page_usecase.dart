import 'package:flutter_result/flutter_result.dart';
import 'package:nortus/core/exceptions/app_exception.dart';
import 'package:nortus/domain/models/news/news_response.dart';
import 'package:nortus/domain/repositories/news_repository.dart';

class GetNewsPageUseCase {
  final NewsRepository repo;
  const GetNewsPageUseCase(this.repo);
  Future<Result<NewsResponse, Failure>> call(int page, {int pageSize = 5}) {
    return repo.fetchPage(page, pageSize: pageSize);
  }
}
