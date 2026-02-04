import 'package:flutter_test/flutter_test.dart';
import 'package:nortus/core/storage/favorites_service.dart';

void main() {
  setUp(() async {});

  test('getAll returns empty initially', () async {
    final service = FavoritesService();
    final all = await service.getAll();
    expect(all, isEmpty);
  });

  test('toggleFavoriteNews adds and removes, and emits changes', () async {
    final service = FavoritesService();
    final events = <Set<int>>[];
    final sub = service.changes.listen(events.add);

    final nowFav = await service.toggleFavoriteNews(1);
    expect(nowFav, isTrue);
    expect(await service.isFavoriteNews(1), isTrue);

    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(events.isNotEmpty, isTrue);
    expect(events.last.contains(1), isTrue);

    final nowFav2 = await service.toggleFavoriteNews(1);
    expect(nowFav2, isFalse);
    expect(await service.isFavoriteNews(1), isFalse);

    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(events.last.contains(1), isFalse);

    await sub.cancel();
    service.dispose();
  });
}
