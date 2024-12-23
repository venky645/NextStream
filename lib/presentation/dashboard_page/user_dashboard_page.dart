import 'package:flutter/material.dart';
import 'package:nexstream/presentation/dashboard_page/widgets/empty_history_widget.dart';
import 'package:nexstream/presentation/dashboard_page/widgets/empty_report_card.dart';
import 'package:nexstream/presentation/dashboard_page/widgets/reported_video_card.dart';
import 'package:nexstream/presentation/dashboard_page/widgets/rich_button_widget.dart';
import 'package:nexstream/presentation/dashboard_page/widgets/section_title.dart';
import 'package:nexstream/presentation/dashboard_page/widgets/watch_history_card.dart';
import 'package:nexstream/presentation/video_upload_page.dart';
import '../../sharedpref/shared_prefference.dart';

class UserDashboardPage extends StatefulWidget {
  @override
  _UserDashboardPageState createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  List<Map<String, String>> watchHistory = [];
  bool isLoading = true;
  List<Map<String, String>> watchHistoryVideos = [];
  List<Map<String, String>> reportedVideos = [];

  @override
  void initState() {
    super.initState();
    _fetchWatchHistory();
    _fetchReportedVideos();
  }

  Future<void> _fetchWatchHistory() async {
    setState(() => isLoading = true);
    try {
      watchHistory = await UserPreferences.instance.getWatchHistory();
      setState(() {
        watchHistoryVideos = List.from(watchHistory.reversed);
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching watch history: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchReportedVideos() async {
    setState(() => isLoading = true);
    try {
      reportedVideos = await UserPreferences.instance.getReportVideos();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching reported videos: $e");
      setState(() => isLoading = false);
    }
  }

  void _clearWatchHistory() async {
    await UserPreferences.instance.clearWatchHistory();
    setState(() {
      watchHistory.clear();
      watchHistoryVideos.clear();
    });
  }

  void _clearReportedVideos() async {
    await UserPreferences.instance.clearReportVideos();
    setState(() {
      reportedVideos.clear();
    });
  }

  void _uploadVideo() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return VideoUploadPage();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            print('clear history');
            UserPreferences.instance.clearWatchHistory();
          },
          child: Text(
            'Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(title: 'Watch History'),
                    watchHistoryVideos.isEmpty
                        ? EmptyHistoryWidget()
                        : _buildWatchHistoryList(),
                    SizedBox(height: 10),
                    SectionTitle(title: 'Reported Videos'),
                    SizedBox(height: 10),
                    reportedVideos.isEmpty
                        ? EmptyReportCard()
                        : _buildReportedVideosList(),
                    SizedBox(height: 30),
                    RichButtonWidget(
                        text: 'Clear Watch History',
                        onPressed: _clearWatchHistory),
                    SizedBox(height: 10),
                    RichButtonWidget(
                        text: 'Clear Reported Videos',
                        onPressed: _clearReportedVideos),
                    SizedBox(height: 16),
                    RichButtonWidget(
                        text: 'Upload Video', onPressed: _uploadVideo),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildWatchHistoryList() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: watchHistoryVideos.length,
        itemBuilder: (context, index) {
          return WatchHistoryCard(
            thumbnail: watchHistoryVideos[index]['thumbnail']!,
            title: watchHistoryVideos[index]['title']!,
          );
        },
      ),
    );
  }

  Widget _buildReportedVideosList() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: reportedVideos.length,
        itemBuilder: (context, index) {
          return ReportedVideoCard(
            thumbnail: reportedVideos[index]['thumbnail']!,
            title: reportedVideos[index]['title']!,
          );
        },
      ),
    );
  }
}
