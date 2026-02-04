import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nortus/domain/models/news/news_item.dart';
import 'package:nortus/presentation/cubits/news/news_cubit.dart';
import 'package:nortus/core/router/app_router.dart';
import 'package:nortus/core/theme/app_colors.dart';
import 'package:nortus/core/extensions/date_extensions.dart';

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
                    InkWell(
                      onTap: () => Navigator.of(context).maybePop(),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.arrow_back),
                            const SizedBox(width: 8),
                            Text('Voltar', style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (item.categories.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.buttonColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              item.categories.first,
                              style: TextStyle(color: AppColors.buttonColor, fontWeight: FontWeight.w600),
                            ),
                          ),
                        const Spacer(),
                        IconButton(
                          tooltip: isFav ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
                          icon: Icon(isFav ? Icons.star : Icons.star_border),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CachedNetworkImage(
                          imageUrl: item.image.src,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
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
