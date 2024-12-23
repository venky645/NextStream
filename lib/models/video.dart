// lib/models/video.dart

class Video {
  final String videoId;
  final String title;
  final String channelId;
  final String channelName;
  final String views;
  final String publishedAt;
  final String thumbnail;
  final String videoUrl;
  final String description;

  Video({
    required this.videoId,
    required this.title,
    required this.channelId,
    required this.channelName,
    required this.views,
    required this.publishedAt,
    required this.thumbnail,
    required this.videoUrl,
    required this.description,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      videoId: json['videoId'] ?? '',
      title: json['title'] ?? '',
      channelId: json['channelId'] ?? '',
      channelName: json['channelName'] ?? '',
      views: json['views'] ?? '0',
      publishedAt: json['publishedAt'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'title': title,
      'channelId': channelId,
      'channelName': channelName,
      'views': views,
      'publishedAt': publishedAt,
      'thumbnail': thumbnail,
      'videoUrl': videoUrl,
      'description': description,
    };
  }
}
