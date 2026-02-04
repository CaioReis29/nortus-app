class ImageResource {
  final String src;
  final String alt;
  const ImageResource({required this.src, required this.alt});
  factory ImageResource.fromJson(Map<String, dynamic> j) => ImageResource(
        src: j['src'] ?? '',
        alt: j['alt'] ?? '',
      );
}
