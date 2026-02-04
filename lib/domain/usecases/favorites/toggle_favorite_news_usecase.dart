import 'package:nortus/domain/repositories/favorites_repository.dart';

class ToggleFavoriteNewsUseCase {
  final FavoritesRepository repo;
  const ToggleFavoriteNewsUseCase(this.repo);
  Future<bool> call(int id) => repo.toggle(id);
}
