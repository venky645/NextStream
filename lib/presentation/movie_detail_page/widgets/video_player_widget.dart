import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

// Define a GlobalKey to access VideoPlayerWidget's state
GlobalKey<_VideoPlayerWidgetState> videoPlayerKey =
    GlobalKey<_VideoPlayerWidgetState>();

class VideoPlayerWidget extends StatefulWidget {
  final String? videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl ?? ''));
    await _videoPlayerController.initialize().then(
      (value) {
        setState(() {
          _isInitialized = true;
        });
      },
    );

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.blue,
        handleColor: Colors.blueAccent,
        backgroundColor: const Color.fromARGB(255, 248, 246, 246),
        bufferedColor: const Color.fromARGB(255, 197, 236, 153),
      ),
      placeholder: Container(
        color: Colors.grey,
      ),
      allowFullScreen: true,
      draggableProgressBar: true,
      showControls: true,
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    disposePlayer();
    super.dispose();
  }

  void disposePlayer() {
    _videoPlayerController.pause();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: Chewie(
              controller: _chewieController,
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
