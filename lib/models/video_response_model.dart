class VideoResponse {
  final List<VideoModel> videos;
  final int? nextPage;
  final bool hasMore;

  VideoResponse({
    required this.videos,
    required this.nextPage,
    required this.hasMore,
  });

  factory VideoResponse.fromJson(Map<String, dynamic> json) {
    return VideoResponse(
      videos: (json['videos'] as List)
          .map((video) => VideoModel.fromJson(video))
          .toList(),
      nextPage: json['nextPage'],
      hasMore: json['hasMore'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videos': videos.map((video) => video.toJson()).toList(),
      'nextPage': nextPage,
      'hasMore': hasMore,
    };
  }
}

class VideoModel {
  final String videoId;
  final String title;
  final String channelId;
  final String channelName;
  final String views;
  final String? likes;
  final String? dislikes;
  final String publishedAt;
  final String thumbnail;

  VideoModel({
    required this.videoId,
    required this.title,
    required this.channelId,
    required this.channelName,
    required this.views,
    this.likes,
    this.dislikes,
    required this.publishedAt,
    required this.thumbnail,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      videoId: json['video_id'],
      title: json['title'],
      channelId: json['channel_id'],
      channelName: json['channel_name'],
      views: json['views'],
      likes: json['likes'],
      dislikes: json['dislikes'],
      publishedAt: json['published_at'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'video_id': videoId,
      'title': title,
      'channel_id': channelId,
      'channel_name': channelName,
      'views': views,
      'likes': likes,
      'dislikes': dislikes,
      'published_at': publishedAt,
      'thumbnail': thumbnail,
    };
  }
}
