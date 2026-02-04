import 'package:flutter/material.dart';
import 'package:nortus/presentation/screens/news/news_view.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      body: const NewsView(),
    );
  }
}