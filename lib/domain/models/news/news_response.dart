import 'package:nortus/domain/models/news/pagination.dart';
import 'package:nortus/domain/models/news/news_item.dart';

class NewsResponse {
  final Pagination pagination;
  final List<NewsItem> data;
  const NewsResponse({required this.pagination, required this.data});
  factory NewsResponse.fromJson(Map<String, dynamic> j) => NewsResponse(
        pagination: Pagination.fromJson(j['pagination'] ?? {}),
        data: (j['data'] as List<dynamic>? ?? [])
            .map((e) => NewsItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
