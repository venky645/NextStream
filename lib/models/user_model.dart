class UserBackendModel {
  final String userId;
  final String name;
  final String email;
  final int statusId;
  final DateTime createdAt;

  UserBackendModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.statusId,
    required this.createdAt,
  });

  factory UserBackendModel.fromJson(Map<String, dynamic> json) {
    return UserBackendModel(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      statusId: json['status_id'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'status_id': statusId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
