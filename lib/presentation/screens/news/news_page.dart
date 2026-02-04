import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/core/router/app_router.dart';
import 'package:nortus/presentation/cubits/news/news_cubit.dart';
import 'package:nortus/presentation/screens/news/widgets/news_item_list.dart';

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
               return Center(child: Text(state.error!));
             }
             final items = state.items;
             if (items.isEmpty) {
               return const Center(child: Text('Nenhuma notícia encontrada'));
             }
             return NotificationListener<ScrollNotification>(
               onNotification: (n) {
                 if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
                   if (state.hasMore) {
                     _cubit.loadMore();
                   }
                 }
                 return false;
               },
               child: NewsItemList(items: items),
             );
           },
         ),
       );
  }
}