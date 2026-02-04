part of 'news_cubit.dart';

sealed class NewsState extends Equatable {
  const NewsState();

  List<NewsItem> get items => const [];
  int get page => 0;
  int get totalPages => 0;
  Set<int> get favorites => const <int>{};
  bool get isLoading => false;
  String? get error => null;
  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [items, page, totalPages, favorites, isLoading, error];
}

class NewsInitial extends NewsState {
  const NewsInitial();
}

class NewsLoading extends NewsState {
  final List<NewsItem> prevItems;
  final int prevPage;
  final int prevTotalPages;
  final Set<int> prevFavorites;
  const NewsLoading({this.prevItems = const [], this.prevPage = 0, this.prevTotalPages = 0, this.prevFavorites = const {}});

  @override
  List<NewsItem> get items => prevItems;
  @override
  int get page => prevPage;
  @override
  int get totalPages => prevTotalPages;
  @override
  Set<int> get favorites => prevFavorites;
  @override
  bool get isLoading => true;
}

class NewsLoaded extends NewsState {
  final List<NewsItem> data;
  final int currentPage;
  final int total;
  final Set<int> favs;
  const NewsLoaded({required this.data, required this.currentPage, required this.total, required this.favs});

  @override
  List<NewsItem> get items => data;
  @override
  int get page => currentPage;
  @override
  int get totalPages => total;
  @override
  Set<int> get favorites => favs;
}

class NewsFailure extends NewsState {
  final String message;
  final List<NewsItem> prevItems;
  final int prevPage;
  final int prevTotalPages;
  final Set<int> prevFavorites;
  const NewsFailure(this.message, {this.prevItems = const [], this.prevPage = 0, this.prevTotalPages = 0, this.prevFavorites = const {}});

  @override
  List<NewsItem> get items => prevItems;
  @override
  int get page => prevPage;
  @override
  int get totalPages => prevTotalPages;
  @override
  String? get error => message;
  @override
  Set<int> get favorites => prevFavorites;
}
