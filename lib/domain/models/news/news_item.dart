import 'package:nortus/domain/models/news/image_resource.dart';
import 'package:nortus/domain/models/news/author.dart';

class NewsItem {
  final int id;
  final String title;
  final ImageResource image;
  final List<String> categories;
  final DateTime publishedAt;
  final String summary;
  final List<Author> authors;
  const NewsItem({
    required this.id,
    required this.title,
    required this.image,
    required this.categories,
    required this.publishedAt,
    required this.summary,
    required this.authors,
  });
  factory NewsItem.fromJson(Map<String, dynamic> j) => NewsItem(
        id: j['id'] ?? 0,
        title: j['title'] ?? '',
        image: ImageResource.fromJson(j['image'] ?? {}),
        categories: (j['categories'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
        publishedAt: DateTime.tryParse(j['publishedAt'] ?? '') ?? DateTime.now(),
        summary: j['summary'] ?? '',
        authors: (j['authors'] as List<dynamic>? ?? [])
            .map((e) => Author.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
