class Pagination {
  final int page;
  final int pageSize;
  final int totalPages;
  final int totalItems;
  const Pagination({
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.totalItems,
  });
  factory Pagination.fromJson(Map<String, dynamic> j) => Pagination(
        page: j['page'] ?? 1,
        pageSize: j['pageSize'] ?? 0,
        totalPages: j['totalPages'] ?? 0,
        totalItems: j['totalItems'] ?? 0,
      );
}
