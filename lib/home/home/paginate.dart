class Paginate {
  int? total;
  int? count;
  int? perPage;
  String? nextPageUrl;
  String? prevPageUrl;
  int? currentPage;
  int? totalPages;

  Paginate({
    this.total,
    this.count,
    this.perPage,
    this.nextPageUrl,
    this.prevPageUrl,
    this.currentPage,
    this.totalPages,
  });

  factory Paginate.fromJson(Map<String, dynamic> json) => Paginate(
        total: json['total'] as int?,
        count: json['count'] as int?,
        perPage: json['per_page'] as int?,
        nextPageUrl: json['next_page_url'] as String?,
        prevPageUrl: json['prev_page_url'] as String?,
        currentPage: json['current_page'] as int?,
        totalPages: json['total_pages'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'count': count,
        'per_page': perPage,
        'next_page_url': nextPageUrl,
        'prev_page_url': prevPageUrl,
        'current_page': currentPage,
        'total_pages': totalPages,
      };
}
