import 'package:flutter/material.dart';
import 'package:nortus/domain/models/news/news_item.dart';
import 'package:nortus/presentation/screens/news/widgets/news_item_card.dart';

class NewsItemList extends StatelessWidget {
  final List<NewsItem> items;
  final void Function(NewsItem)? onItemTap;
  const NewsItemList({super.key, required this.items, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final n = items[index];
        return NewsItemCard(
          item: n,
          onTap: onItemTap != null ? () => onItemTap!(n) : null,
        );
      },
    );
  }
}
