import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/core/router/app_router.dart';
import 'package:nortus/presentation/cubits/news/news_cubit.dart';
import 'package:nortus/presentation/screens/news/widgets/news_item_card.dart';
import 'package:nortus/core/theme/app_colors.dart';

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final NewsCubit _cubit = getIt<NewsCubit>();
  bool _onlyFavorites = false;

  @override
  void initState() {
    super.initState();
    _cubit.load(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'lib/assets/logo/nortus_blue_name.png',
                height: 30,
                width: 120,
              ),
              IconButton(
                icon: const Icon(Icons.search, size: 28),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pedro Silva",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const Text(
                "pedro@gmail.com",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    "São Paulo, Brasil",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 44,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black)),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.settings_outlined, size: 16, color: Colors.black),
                      SizedBox(width: 4),
                      Text("Configurações de Usuário", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 44,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.logout, size: 16, color: Colors.red),
                      SizedBox(width: 4),
                      Text("Sair da Conta", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => setState(() => _onlyFavorites = !_onlyFavorites),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mostrar favoritos',
                        style: TextStyle(
                          color: _onlyFavorites ? AppColors.buttonColor : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (_onlyFavorites)
                        const SizedBox(
                          height: 2,
                          child: ColoredBox(color: AppColors.buttonColor),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<NewsCubit, NewsState>(
              bloc: _cubit,
              builder: (context, state) {
                final items = state.items;
                final visibleItems = _onlyFavorites
                    ? items.where((e) => state.favorites.contains(e.id)).toList()
                    : items;

                if (state.isLoading && items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.error != null && items.isEmpty) {
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
                            onPressed: () => _cubit.load(
                              page: state.page == 0 ? 1 : state.page,
                            ),
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (visibleItems.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma notícia encontrada'),
                  );
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
                      itemCount: visibleItems.length +
                          ((!_onlyFavorites && state.isLoading) ? 1 : 0) +
                          ((!_onlyFavorites && !state.isLoading && !state.hasMore) ? 1 : 0),
                      itemBuilder: (context, index) {
                        final isLoadingFooter = !_onlyFavorites &&
                            state.isLoading && index == visibleItems.length;
                        final isEndFooter = !_onlyFavorites &&
                            !state.isLoading && !state.hasMore &&
                            index == visibleItems.length;
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
                        final n = visibleItems[index];
                        return NewsItemCard(
                          item: n,
                          isFavorite: state.favorites.contains(n.id),
                          onToggleFavorite: () async {
                            final added = await _cubit.toggleFavorite(n.id);
                            final msg = added
                                ? 'Adicionado aos favoritos'
                                : 'Removido dos favoritos';
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(msg),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
