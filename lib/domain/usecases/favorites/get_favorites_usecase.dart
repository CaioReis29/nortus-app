import 'package:nortus/domain/repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  final FavoritesRepository repo;
  const GetFavoritesUseCase(this.repo);
  Future<Set<int>> call() => repo.getFavorites();
}
