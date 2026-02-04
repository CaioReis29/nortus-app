import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nortus/domain/models/news/news_item.dart';

class NewsItemCard extends StatefulWidget {
  final NewsItem item;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;
  const NewsItemCard({super.key, required this.item, this.onTap, this.isFavorite = false, this.onToggleFavorite});

  @override
  State<NewsItemCard> createState() => _NewsItemCardState();
}

class _NewsItemCardState extends State<NewsItemCard> {
  late bool _fav;
  final bool _init = true;

  @override
  void initState() {
    super.initState();
    _fav = widget.isFavorite;
  }

  @override
  void didUpdateWidget(covariant NewsItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      setState(() => _fav = widget.isFavorite);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final category = item.categories.isNotEmpty ? item.categories.first : '';
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _TopImage(src: item.image.src),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.black54,
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: _fav ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
                      onPressed: () {
                        if (!_init) return;
                        widget.onToggleFavorite?.call();
                        setState(() => _fav = !_fav);
                      },
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                        child: Icon(
                          _fav ? Icons.star : Icons.star_border,
                          key: ValueKey<bool>(_fav),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (category.isNotEmpty)
                    Text(category.toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 4),
                  Text(item.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    item.summary.isNotEmpty ? item.summary : item.publishedAt.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopImage extends StatelessWidget {
  final String src;
  const _TopImage({required this.src});

  @override
  Widget build(BuildContext context) {
    if (src.isEmpty) {
      return ClipRRect(
          
        child: Container(
          color: Colors.grey.shade200,
          height: 180,
          alignment: Alignment.center,
          child: const Icon(Icons.image, size: 48, color: Colors.grey),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: CachedNetworkImage(
          imageUrl: src,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
