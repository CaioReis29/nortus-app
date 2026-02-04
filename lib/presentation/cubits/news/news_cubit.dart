import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_result/flutter_result.dart';
import 'package:nortus/core/exceptions/app_exception.dart';
import 'package:nortus/domain/models/news/news_response.dart';
import 'package:nortus/domain/models/news/news_item.dart';
import 'package:nortus/domain/usecases/news/get_news_page_usecase.dart';
import 'package:nortus/domain/usecases/favorites/get_favorites_usecase.dart';
import 'package:nortus/domain/usecases/favorites/toggle_favorite_news_usecase.dart';
import 'package:nortus/domain/usecases/favorites/watch_favorites_usecase.dart';
import 'package:get_it/get_it.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final GetNewsPageUseCase getPage;
  final GetFavoritesUseCase getFavorites;
  final ToggleFavoriteNewsUseCase toggleFavoriteUseCase;
  final WatchFavoritesUseCase watchFavoritesUseCase;
  StreamSubscription<Set<int>>? _favSub;
  NewsCubit(this.getPage, {GetFavoritesUseCase? getFavorites, ToggleFavoriteNewsUseCase? toggleFavorite, WatchFavoritesUseCase? watchFavorites})
      : getFavorites = getFavorites ?? GetIt.I<GetFavoritesUseCase>(),
        toggleFavoriteUseCase = toggleFavorite ?? GetIt.I<ToggleFavoriteNewsUseCase>(),
        watchFavoritesUseCase = watchFavorites ?? GetIt.I<WatchFavoritesUseCase>(),
        super(const NewsInitial());

  void _startFavoritesSubscription() {
    _favSub ??= watchFavoritesUseCase().listen((f) {
      final favs = Set<int>.unmodifiable(f);
      final s = state;
      if (s is NewsLoaded) {
        emit(NewsLoaded(data: s.data, currentPage: s.currentPage, total: s.total, favs: favs));
      } else if (s is NewsLoading) {
        emit(NewsLoading(prevItems: s.prevItems, prevPage: s.prevPage, prevTotalPages: s.prevTotalPages, prevFavorites: favs));
      } else if (s is NewsFailure) {
        emit(NewsFailure(s.message, prevItems: s.prevItems, prevPage: s.prevPage, prevTotalPages: s.prevTotalPages, prevFavorites: favs));
      }
    });
  }

  Future<void> load({int page = 1}) async {
    if (state.isLoading) return;
    _startFavoritesSubscription();
    final bool isFirstPage = page == 1;
    emit(NewsLoading(
      prevItems: isFirstPage ? const [] : state.items,
      prevPage: isFirstPage ? 0 : state.page,
      prevTotalPages: isFirstPage ? 0 : state.totalPages,
      prevFavorites: state.favorites,
    ));

    final Result<NewsResponse, Failure> res = await getPage(page, pageSize: 5);
    res.open(
      (ok) {
        final response = ok!;
        final totalPages = response.pagination.totalPages;
        final merged = <NewsItem>[...(!isFirstPage ? state.items : const <NewsItem>[]), ...response.data];
        final favs = state.favorites.isEmpty && isFirstPage ? null : state.favorites;
        Future<Set<int>> ensureFavs() async => favs ?? await getFavorites();
        ensureFavs().then((f) {
          emit(NewsLoaded(data: List.unmodifiable(merged), currentPage: page, total: totalPages, favs: f));
        }).catchError((_) {
          emit(NewsLoaded(data: List.unmodifiable(merged), currentPage: page, total: totalPages, favs: state.favorites));
        });
      },
      (err) => emit(NewsFailure(
        err?.message ?? 'Falha ao carregar notícias',
        prevItems: state.items,
        prevPage: state.page,
        prevTotalPages: state.totalPages,
        prevFavorites: state.favorites,
      )),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading) return;
    if (!state.hasMore && state.page != 0) return;
    final next = state.page == 0 ? 1 : state.page + 1;
    await load(page: next);
  }

  Future<bool> toggleFavorite(int id) async {
    final nowFav = await toggleFavoriteUseCase(id);
    final currentFavs = Set<int>.from(state.favorites);
    if (nowFav) {
      currentFavs.add(id);
    } else {
      currentFavs.remove(id);
    }
    if (state is NewsLoaded) {
      final s = state as NewsLoaded;
      emit(NewsLoaded(data: s.data, currentPage: s.currentPage, total: s.total, favs: Set<int>.unmodifiable(currentFavs)));
    } else if (state is NewsLoading) {
      final s = state as NewsLoading;
      emit(NewsLoading(prevItems: s.prevItems, prevPage: s.prevPage, prevTotalPages: s.prevTotalPages, prevFavorites: Set<int>.unmodifiable(currentFavs)));
    } else if (state is NewsFailure) {
      final s = state as NewsFailure;
      emit(NewsFailure(s.message, prevItems: s.prevItems, prevPage: s.prevPage, prevTotalPages: s.prevTotalPages, prevFavorites: Set<int>.unmodifiable(currentFavs)));
    }
    return nowFav;
  }

  @override
  Future<void> close() {
    _favSub?.cancel();
    _favSub = null;
    return super.close();
  }
}