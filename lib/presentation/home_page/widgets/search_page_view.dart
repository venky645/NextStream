import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nexstream/models/video_response_model.dart';
import 'package:nexstream/presentation/movie_detail_page/movie_detail_page.dart';
import 'package:nexstream/services/api_service.dart';

class SearchBarView extends StatefulWidget {
  final String searchQuery;

  SearchBarView({required this.searchQuery});

  @override
  _SearchBarViewState createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  List<VideoModel> _allVideos = [];
  List<VideoModel> _filteredVideos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSearchResults();
  }

  Future<void> _fetchSearchResults() async {
    try {
      VideoResponse videoResponse = await ApiService().fetchVideos(0);
      setState(() {
        _allVideos = videoResponse.videos;
        _isLoading = false;
      });

      _filterVideos(widget.searchQuery);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError("Failed to load videos (Network Error) : ${e.toString()}");
    }
  }

  void _filterVideos(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredVideos = _allVideos;
      });
    } else {
      setState(() {
        _filteredVideos = _allVideos
            .where((video) =>
                video.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Search Results: ',
              style: TextStyle(fontSize: 18),
            ),
            Expanded(
              child: Text(
                widget.searchQuery,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _filteredVideos.isEmpty
              ? Center(
                  child: Text('No videos found for "${widget.searchQuery}"'))
              : ListView.builder(
                  itemCount: _filteredVideos.length,
                  itemBuilder: (context, index) {
                    final video = _filteredVideos[index];
                    return _buildVideoCard(video);
                  },
                ),
    );
  }

  Widget _buildVideoCard(VideoModel video) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return MovieDetailPage(
                      videoId: video.videoId,
                      likes: video.likes,
                      views: video.views,
                      thumbnail: video.thumbnail,
                      title: video.title);
                },
              ));
            },
            child: Container(
              width: double.infinity,
              height: 180,
              child: Image.network(
                video.thumbnail,
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
            title: Text(video.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Channel: ${video.channelName}'),
              ],
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
