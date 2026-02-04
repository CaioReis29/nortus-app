import 'package:nortus/domain/repositories/favorites_repository.dart';

class WatchFavoritesUseCase {
  final FavoritesRepository repo;
  const WatchFavoritesUseCase(this.repo);
  Stream<Set<int>> call() => repo.changes();
}
