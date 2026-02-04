import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_result/flutter_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nortus/core/exceptions/api_exception.dart';
import 'package:nortus/domain/models/news/author.dart';
import 'package:nortus/domain/models/news/image_resource.dart';
import 'package:nortus/domain/models/news/news_item.dart';
import 'package:nortus/domain/models/news/news_response.dart';
import 'package:nortus/domain/models/news/pagination.dart';
import 'package:nortus/domain/usecases/favorites/get_favorites_usecase.dart';
import 'package:nortus/domain/usecases/favorites/toggle_favorite_news_usecase.dart';
import 'package:nortus/domain/usecases/favorites/watch_favorites_usecase.dart';
import 'package:nortus/domain/usecases/news/get_news_page_usecase.dart';
import 'package:nortus/presentation/cubits/news/news_cubit.dart';

class MockGetNewsPageUseCase extends Mock implements GetNewsPageUseCase {}
class MockGetFavoritesUseCase extends Mock implements GetFavoritesUseCase {}
class MockToggleFavoriteNewsUseCase extends Mock implements ToggleFavoriteNewsUseCase {}
class MockWatchFavoritesUseCase extends Mock implements WatchFavoritesUseCase {}

void main() {
  late MockGetNewsPageUseCase getPage;
  late MockGetFavoritesUseCase getFavs;
  late MockToggleFavoriteNewsUseCase toggleFav;
  late MockWatchFavoritesUseCase watchFavs;
  late StreamController<Set<int>> favsController;

  setUp(() {
    getPage = MockGetNewsPageUseCase();
    getFavs = MockGetFavoritesUseCase();
    toggleFav = MockToggleFavoriteNewsUseCase();
    watchFavs = MockWatchFavoritesUseCase();
    favsController = StreamController<Set<int>>.broadcast();

    when(() => watchFavs()).thenAnswer((_) => favsController.stream);
  });

  tearDown(() async {
    await favsController.close();
  });

  final item = NewsItem(
    id: 1,
    title: 'Title',
    image: const ImageResource(src: 'https://example.com/img.jpg', alt: 'alt'),
    categories: const ['Tech'],
    publishedAt: DateTime(2024, 1, 1),
    summary: 'Summary',
    authors: const <Author>[],
  );
  final response = NewsResponse(
    pagination: const Pagination(page: 1, pageSize: 5, totalPages: 2, totalItems: 10),
    data: [item],
  );

  blocTest<NewsCubit, NewsState>(
    'emits Loading then Loaded on successful load',
    build: () {
      when(() => getPage(1, pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => Result.success(response));
      when(() => getFavs()).thenAnswer((_) async => <int>{});
      return NewsCubit(
        getPage,
        getFavorites: getFavs,
        toggleFavorite: toggleFav,
        watchFavorites: watchFavs,
      );
    },
    act: (cubit) => cubit.load(page: 1),
    expect: () => [
      isA<NewsLoading>(),
      isA<NewsLoaded>().having((s) => s.items.length, 'items', 1).having((s) => s.favorites, 'favs', <int>{}),
    ],
  );

  blocTest<NewsCubit, NewsState>(
    'updates favorites when stream emits',
    build: () {
      when(() => getPage(1, pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => Result.success(response));
      when(() => getFavs()).thenAnswer((_) async => <int>{});
      return NewsCubit(
        getPage,
        getFavorites: getFavs,
        toggleFavorite: toggleFav,
        watchFavorites: watchFavs,
      );
    },
    act: (cubit) async {
      await cubit.load(page: 1);
      favsController.add(<int>{1});
      await Future<void>.delayed(const Duration(milliseconds: 10));
    },
    verify: (cubit) {
      expect(cubit.state.favorites, <int>{1});
    },
  );

  blocTest<NewsCubit, NewsState>(
    'emits Failure when repository returns error',
    build: () {
      when(() => getPage(1, pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => Result.error(const ApiFailure('Erro')));
      when(() => getFavs()).thenAnswer((_) async => <int>{});
      return NewsCubit(
        getPage,
        getFavorites: getFavs,
        toggleFavorite: toggleFav,
        watchFavorites: watchFavs,
      );
    },
    act: (cubit) => cubit.load(page: 1),
    expect: () => [
      isA<NewsLoading>(),
      isA<NewsFailure>(),
    ],
  );
}
