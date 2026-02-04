import 'package:flutter/material.dart';
import 'package:nortus/core/extensions/date_extensions.dart';
import 'package:nortus/presentation/components/favorite_icon_button.dart';
import 'package:nortus/presentation/components/news_hero_image.dart';
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
                const SizedBox(height: 8),
                NewsHeroImage(src: item.image.src, borderRadius: 16, height: 180),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.black54,
                    shape: const CircleBorder(),
                    child: FavoriteIconButton(
                      isFavorite: _fav,
                      iconColor: Colors.white,
                      onPressed: () {
                        if (!_init) return;
                        widget.onToggleFavorite?.call();
                        setState(() => _fav = !_fav);
                      },
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
                    item.summary.isNotEmpty ? item.summary : item.publishedAt.formatBr(),
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

// TopImage substituído por NewsHeroImage componente reutilizável
