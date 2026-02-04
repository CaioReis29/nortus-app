import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/core/router/app_router.dart';
import 'package:nortus/presentation/cubits/news/news_cubit.dart';
import 'package:nortus/presentation/screens/news/widgets/news_item_card.dart';

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final NewsCubit _cubit = getIt<NewsCubit>();

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
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pedro Silva",
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 22,
                ),
              ),
              Text(
                "pedro@gmail.com",
                style: TextStyle(
                  fontWeight: FontWeight.w400, 
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 4,
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  Text(
                    "São Paulo, Brasil",
                    style: TextStyle(
                      fontWeight: FontWeight.w400, 
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 44,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black),
                  ),
                  onPressed: () {}, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      Icon(Icons.settings_outlined, size: 16, color: Colors.black),
                      Text(
                          "Configurações de Usuário", 
                          style: TextStyle(color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 44,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                  ),
                  onPressed: () {}, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      Icon(Icons.logout, size: 16, color: Colors.red),
                      Text("Sair da Conta", style: TextStyle(color: Colors.red)),
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
                if (items.isEmpty) {
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
                      itemCount:
                          items.length +
                          (state.isLoading ? 1 : 0) +
                          (!state.isLoading && !state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        final isLoadingFooter =
                            state.isLoading && index == items.length;
                        final isEndFooter =
                            !state.isLoading &&
                            !state.hasMore &&
                            index == items.length;
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
