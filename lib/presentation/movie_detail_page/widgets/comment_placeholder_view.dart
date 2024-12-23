import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexstream/presentation/auth_screens/login/login_page.dart';
import 'package:nexstream/presentation/movie_detail_page/widgets/video_player_widget.dart';
import 'package:nexstream/services/api_service.dart';

class CommentSection extends StatefulWidget {
  final String videoId;

  const CommentSection({super.key, required this.videoId});
  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      isLoggedIn = user != null;
    });
  }

  void _redirectToLogin() {
    videoPlayerKey.currentState?.disposePlayer();
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return LoginPage(videoId: widget.videoId);
      },
    ));
  }

  void _postComment() {
    if (isLoggedIn) {
      print("Comment posted: ${_commentController.text}");
      ApiService().postComment(
          videoId: widget.videoId, content: _commentController.text);

      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isLoggedIn)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Please log in to comment.",
              style: TextStyle(color: Colors.red),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: !isLoggedIn ? _redirectToLogin : null,
                child: TextField(
                  controller: _commentController,
                  enabled: isLoggedIn,
                  decoration: InputDecoration(
                    hintText:
                        isLoggedIn ? "Write a comment..." : "Login to comment",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: isLoggedIn ? _postComment : _redirectToLogin,
              child: isLoggedIn ? Text("Post") : Text('Login'),
            ),
          ],
        ),
      ],
    );
  }
}
