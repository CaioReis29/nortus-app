import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/core/router/app_router.dart';
import 'package:nortus/presentation/cubits/news/news_cubit.dart';
import 'package:nortus/presentation/screens/news/widgets/news_item_card.dart';

class NewsPage extends StatefulWidget {

  const NewsPage({ super.key });

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final NewsCubit _cubit = getIt<NewsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.load(page: 1);
  }

   @override
   Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(title: const Text('News')),
         body: BlocBuilder<NewsCubit, NewsState>(
           bloc: _cubit,
           builder: (context, state) {
             if (state.isLoading && state.items.isEmpty) {
               return const Center(child: CircularProgressIndicator());
             }
            if (state.error != null && state.items.isEmpty) {
              final msg = state.error!;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(msg, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _cubit.load(page: state.page == 0 ? 1 : state.page),
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              );
            }
             final items = state.items;
             if (items.isEmpty) {
               return const Center(child: Text('Nenhuma notícia encontrada'));
             }
            return RefreshIndicator(
              onRefresh: () => _cubit.load(page: 1),
              child: NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
                    if (state.hasMore) {
                      _cubit.loadMore();
                    }
                  }
                  return false;
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: items.length + (state.isLoading ? 1 : 0) + (!state.isLoading && !state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    final isLoadingFooter = state.isLoading && index == items.length;
                    final isEndFooter = !state.isLoading && !state.hasMore && index == items.length;
                    if (isLoadingFooter) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (isEndFooter) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: Text('Você chegou ao fim')),
                      );
                    }
                    final n = items[index];
                    return NewsItemCard(
                      item: n,
                      isFavorite: state.favorites.contains(n.id),
                      onToggleFavorite: () async {
                        final added = await _cubit.toggleFavorite(n.id);
                        final msg = added ? 'Adicionado aos favoritos' : 'Removido dos favoritos';
                        if (!mounted) return;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 1)));
                      },
                    );
                  },
                ),
              ),
            );
           },
         ),
       );
  }
}