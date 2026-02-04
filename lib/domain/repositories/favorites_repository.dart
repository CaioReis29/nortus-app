abstract class FavoritesRepository {
  Future<Set<int>> getFavorites();
  Future<bool> isFavorite(int id);
  Future<bool> toggle(int id);
  Stream<Set<int>> changes();
}
