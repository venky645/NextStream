class AdminUser {
  final String userId;
  final String name;
  final String email;
  final int statusId;

  AdminUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.statusId,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      statusId: json['status_id'],
    );
  }
}

class Pagination {
  final int totalRecords;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final bool hasNext;

  Pagination({
    required this.totalRecords,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.hasNext,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalRecords: json['totalRecords'],
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
      pageSize: json['pageSize'],
      hasNext: json['hasNext'],
    );
  }
}
