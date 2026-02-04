import 'package:nortus/domain/models/news/image_resource.dart';

class Author {
  final String name;
  final ImageResource image;
  final String description;
  const Author({required this.name, required this.image, required this.description});
  factory Author.fromJson(Map<String, dynamic> j) => Author(
        name: j['name'] ?? '',
        image: ImageResource.fromJson(j['image'] ?? {}),
        description: j['description'] ?? '',
      );
}
