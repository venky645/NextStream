import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexstream/models/video_comments_model.dart';
import 'package:nexstream/models/video_detail_model.dart';
import 'package:nexstream/models/video_response_model.dart';
import 'package:nexstream/presentation/movie_detail_page/widgets/comment_view.dart';
import 'package:nexstream/presentation/movie_detail_page/widgets/video_player_widget.dart';
import 'package:nexstream/presentation/movie_detail_page/widgets/comment_placeholder_view.dart';
import 'package:nexstream/presentation/movie_detail_page/widgets/recommended_videos_widget.dart';
import 'package:nexstream/services/api_service.dart';
import 'package:nexstream/sharedpref/shared_prefference.dart';
import 'package:provider/provider.dart';

import '../utils/theme_service.dart';

class MovieDetailPage extends StatefulWidget {
  final String videoId;
  final String? likes;
  final String thumbnail;
  final String title;
  final String? views; // Add videoId to load specific video details
  MovieDetailPage(
      {required this.videoId,
      required this.likes,
      required this.views,
      required this.thumbnail,
      required this.title});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool fullscreen = false;
  bool _isLoading = true;
  bool _isPostingComment = false;
  List<Comment> comments = [];
  VideoDetailModel? videoDetails;
  List<VideoModel> recommendedVideos = [];

  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadVideoDetailsAndRecommendedVideos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadVideoDetailsAndRecommendedVideos() async {
    try {
      await Future.wait([
        ApiService().fetchVideoDetails(videoId: widget.videoId).then((value) {
          setState(() {
            videoDetails = value;
          });
        }),
        ApiService().fetchVideos(0).then((value) {
          setState(() {
            recommendedVideos = value.videos;
            recommendedVideos.shuffle(Random());
          });
        }),
        ApiService().fetchVideoComments(videoId: widget.videoId).then((value) {
          setState(() {
            print('video _ id: ${widget.videoId}');
            print('comments are : ${value?.comments}');
            comments = value?.comments ?? [];
          });
        })
      ]);

      setState(() {
        _isLoading = false;
      });

      UserPreferences.instance
          .addToWatchHistory(widget.videoId, widget.thumbnail, widget.title);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadComments() async {
    try {
      VideoCommentsModel? response =
          await ApiService().fetchVideoComments(videoId: widget.videoId);
      setState(() {
        comments = response?.comments ?? [];
      });
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  void _postComment() async {
    String? userId = await UserPreferences.instance.getUserId();

    print('user id in post comment : $userId');

    if (_commentController.text.isNotEmpty) {
      setState(() {
        _isPostingComment = true;
      });

      await ApiService().postComment(
        videoId: widget.videoId,
        content: _commentController.text,
      );

      _commentController.clear();

      _loadComments();

      setState(() {
        _isPostingComment = false;
      });
    }
  }

  void _showReportDialog() async {
    bool isConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(Icons.report_problem, color: Colors.red, size: 30),
              SizedBox(width: 10),
              Text("Report Video",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            "Are you sure you want to report this video?",
            style: TextStyle(color: Colors.grey[700]),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("No", style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () async {
                await ApiService().reportVideo(videoId: videoDetails!.videoId);

                _showSnackBar("Your report was successful.");
                UserPreferences.instance.addToReportVideos(
                    widget.videoId, widget.thumbnail, widget.title);
                if (mounted) {
                  Navigator.of(context).pop(true);
                }
              },
              child: Text("Yes", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (isConfirmed) {}
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        elevation: 10,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.play_arrow_rounded, color: Colors.blue),
            SizedBox(width: 8),
            Text("NexStream", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          GestureDetector(
              onTap: themeService.toggleTheme,
              child: Icon(themeService.isDarkMode
                  ? Icons.sunny
                  : Icons.nightlight_round)),
          SizedBox(width: 16)
        ],
        elevation: 0,
        centerTitle: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                      minHeight: 200,
                    ),
                    child: VideoPlayerWidget(
                      videoUrl: videoDetails?.archievedUrl,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text(videoDetails?.title ?? 'title',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.blue,
                                child: Text("TC",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    videoDetails?.channelName ?? 'channel name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    videoDetails?.channelDescription ??
                                        "A channel for tech discussions",
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () async {
                                final user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  _showReportDialog();
                                } else {
                                  _showSnackBar(
                                      'Please Login to Report the Video');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                  elevation: 0),
                              child: Text("Report",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.thumb_up),
                              onPressed: () {},
                            ),
                            Text('${widget.likes ?? 0} Likes'),
                            SizedBox(width: 16),
                            Icon(Icons.remove_red_eye),
                            SizedBox(width: 8),
                            Text('${widget.views ?? 0} Views'),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                            videoDetails?.videoDescription ??
                                'videoDescription',
                            style: TextStyle(color: Colors.grey[700])),
                        SizedBox(height: 16),
                        Text("Comments",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        CommentSection(videoId: videoDetails!.videoId),
                        SizedBox(height: 16),
                        comments.isNotEmpty
                            ? GestureDetector(
                                onTap: _showCommentsBottomSheet,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: 120,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Scrollbar(
                                    trackVisibility: true,
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: comments.map((comment) {
                                        return CommentCardView(
                                          username: comment.userName,
                                          comment: comment.content,
                                          date: comment.createdAt,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(height: 16),
                        Text("Recommended Videos",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Column(
                          children:
                              List.generate(recommendedVideos.length, (index) {
                            if (recommendedVideos[index].videoId !=
                                widget.videoId) {
                              return BuildRecommendedVideos(
                                  title: recommendedVideos[index].title,
                                  channel: recommendedVideos[index].channelName,
                                  thumbnailUrl:
                                      recommendedVideos[index].thumbnail,
                                  videoId: recommendedVideos[index].videoId,
                                  views: widget.views,
                                  likes: widget.likes);
                            } else {
                              return SizedBox();
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showCommentsBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.85,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: [
                  Text(
                    "Comments",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          ...comments.map((comment) {
                            return CommentCardView(
                              username: comment.userName,
                              comment: comment.content,
                              date: comment.createdAt,
                            );
                          }).toList(),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: "Add a comment",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isPostingComment ? null : _postComment,
                        style: ElevatedButton.styleFrom(
                            // backgroundColor: Colors.blue,
                            ),
                        child: _isPostingComment
                            ? CircularProgressIndicator()
                            : Text("Post"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
