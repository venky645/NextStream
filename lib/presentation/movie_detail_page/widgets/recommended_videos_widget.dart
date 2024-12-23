import 'package:flutter/material.dart';
import 'package:nexstream/presentation/movie_detail_page/movie_detail_page.dart';
import 'package:nexstream/presentation/movie_detail_page/widgets/video_player_widget.dart';

class BuildRecommendedVideos extends StatelessWidget {
  final String title;
  final String channel;
  final String thumbnailUrl;
  final String? views;
  final String? likes;
  final String videoId;
  const BuildRecommendedVideos(
      {super.key,
      required this.title,
      required this.channel,
      required this.thumbnailUrl,
      required this.views,
      required this.likes,
      required this.videoId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        videoPlayerKey.currentState?.disposePlayer();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieDetailPage(
                      videoId: videoId,
                      likes: likes,
                      views: views,
                      thumbnail: thumbnailUrl,
                      title: title,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Image.network(
              thumbnailUrl,
              width: 100,
              height: 60,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                }
              },
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.network(
                  'https://via.placeholder.com/100x60.png?text=Error',
                  width: 100,
                  height: 60,
                  fit: BoxFit.cover,
                );
              },
            ),
            SizedBox(width: 8),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(channel, style: TextStyle(color: Colors.grey)),
                ])),
            Icon(Icons.more_vert),
          ],
        ),
      ),
    );
  }
}
