import 'package:nortus/core/storage/favorites_service.dart';
import 'package:nortus/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesService service;
  FavoritesRepositoryImpl(this.service);

  @override
  Future<Set<int>> getFavorites() async {
    return service.getAll();
  }

  @override
  Future<bool> isFavorite(int id) => service.isFavoriteNews(id);

  @override
  Future<bool> toggle(int id) => service.toggleFavoriteNews(id);

  @override
  Stream<Set<int>> changes() => service.changes;
}
