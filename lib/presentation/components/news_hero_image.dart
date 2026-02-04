import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsHeroImage extends StatelessWidget {
  final String src;
  final double borderRadius;
  final double aspectRatio;
  final double? height;
  const NewsHeroImage({super.key, required this.src, this.borderRadius = 16, this.aspectRatio = 16/9, this.height});

  @override
  Widget build(BuildContext context) {
    if (src.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          color: Colors.grey.shade200,
          height: height ?? 180,
          alignment: Alignment.center,
          child: const Icon(Icons.image, size: 48, color: Colors.grey),
        ),
      );
    }
    final content = CachedNetworkImage(
      imageUrl: src,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: height != null
          ? SizedBox(height: height, width: double.infinity, child: content)
          : AspectRatio(aspectRatio: aspectRatio, child: content),
    );
  }
}
