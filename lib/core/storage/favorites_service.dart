import 'dart:async';

class FavoritesService {
  final StreamController<Set<int>> _controller = StreamController<Set<int>>.broadcast();

  final Set<int> _ids = <int>{};
  bool _busy = false;

  Stream<Set<int>> get changes => _controller.stream;

  Future<void> _ensureLoaded() async {}

  Future<bool> isFavoriteNews(int id) async {
    await _ensureLoaded();
    return _ids.contains(id);
  }

  Future<bool> toggleFavoriteNews(int id) async {
    if (_busy) return _ids.contains(id);
    _busy = true;
    await _ensureLoaded();
    bool nowFav;
    if (_ids.contains(id)) {
      _ids.remove(id);
      nowFav = false;
    } else {
      _ids.add(id);
      nowFav = true;
    }
    _controller.add(Set<int>.unmodifiable(_ids));
    _busy = false;
    return nowFav;
  }

  Future<Set<int>> getAll() async {
    await _ensureLoaded();
    return Set<int>.unmodifiable(_ids);
  }

  void dispose() {
    _controller.close();
  }
}
