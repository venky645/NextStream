class VideoDetailModel {
  final String videoId;
  final String title;
  final String videoDescription;
  final String userId;
  final DateTime createdAt;
  final String videoUrl;
  final String channelName;
  final String channelDescription;
  final String? archievedUrl;

  VideoDetailModel(
      {required this.videoId,
      required this.title,
      required this.videoDescription,
      required this.userId,
      required this.createdAt,
      required this.videoUrl,
      required this.channelName,
      required this.channelDescription,
      required this.archievedUrl});

  factory VideoDetailModel.fromJson(Map<String, dynamic> json) {
    return VideoDetailModel(
      videoId: json['video_id'],
      title: json['title'],
      videoDescription: json['video_description'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      videoUrl: json['video_url'],
      channelName: json['channel_name'],
      channelDescription: json['channel_description'],
      archievedUrl: json['archived_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'video_id': videoId,
      'title': title,
      'video_description': videoDescription,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'video_url': videoUrl,
      'channel_name': channelName,
      'channel_description': channelDescription,
      'archived_url': archievedUrl
    };
  }
}
