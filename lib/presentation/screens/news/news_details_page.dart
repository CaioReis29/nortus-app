import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/domain/models/news/news_item.dart';
import 'package:nortus/presentation/cubits/news/news_cubit.dart';
import 'package:nortus/core/router/app_router.dart';
import 'package:nortus/core/extensions/date_extensions.dart';
import 'package:nortus/presentation/components/back_text_button.dart';
import 'package:nortus/presentation/components/category_chip.dart';
import 'package:nortus/presentation/components/favorite_icon_button.dart';
import 'package:nortus/presentation/components/news_hero_image.dart';

class NewsDetailsPage extends StatefulWidget {
  final NewsItem item;
  const NewsDetailsPage({super.key, required this.item});

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  final NewsCubit _cubit = getIt<NewsCubit>();

  @override
  Widget build(BuildContext context) {
    final extra = widget.item;
    final NewsItem item = extra;
    return BlocBuilder<NewsCubit, NewsState>(
      bloc: _cubit,
      builder: (context, state) {
        final isFav = state.favorites.contains(item.id);
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BackTextButton(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (item.categories.isNotEmpty) CategoryChip(label: item.categories.first),
                        const Spacer(),
                        FavoriteIconButton(
                          isFavorite: isFav,
                          onPressed: () async {
                            final added = await _cubit.toggleFavorite(item.id);
                            if (!context.mounted) return;
                            final msg = added ? 'Adicionado aos favoritos' : 'Removido dos favoritos';
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text('Publicado em: ${item.publishedAt.formatBr()}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
                    const SizedBox(height: 16),
                    NewsHeroImage(src: item.image.src, borderRadius: 12),
                    const SizedBox(height: 16),
                    Text(
                      item.summary.isNotEmpty ? item.summary : 'Sem conteúdo adicional disponível.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
