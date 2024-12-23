class VideoCommentsModel {
  final List<Comment> comments;
  final int? nextPage;
  final bool hasMore;

  VideoCommentsModel({
    required this.comments,
    required this.nextPage,
    required this.hasMore,
  });

  factory VideoCommentsModel.fromJson(Map<String, dynamic> json) {
    return VideoCommentsModel(
      comments: (json['comments'] as List<dynamic>)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
      nextPage: json['nextPage'],
      hasMore: json['hasMore'] ?? false,
    );
  }
}

class Comment {
  final String commentId;
  final String userId;
  final String content;
  final String createdAt;
  final String userName;

  Comment({
    required this.commentId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.userName,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: json['created_at'],
      userName: json['user_name'],
    );
  }
}
