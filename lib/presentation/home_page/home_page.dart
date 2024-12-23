import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexstream/presentation/dashboard_page/user_dashboard_page.dart';
import 'package:nexstream/presentation/dashboard_page/widgets/section_title.dart';
import 'package:nexstream/presentation/home_page/widgets/carousel_view.dart';
import 'package:nexstream/presentation/home_page/widgets/search_bar_widget.dart';

import 'package:nexstream/presentation/settings_page/settings_page_view.dart';
import 'package:nexstream/services/api_service.dart';
import 'package:provider/provider.dart';
import '../../models/video_response_model.dart';
import 'widgets/movieCard.dart';
import '../utils/theme_service.dart';
import '../video_upload_page.dart' as upload;

enum BottomNavItem { Home, Dashboard, Settings }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BottomNavItem _currentNavItem;

  final ScrollController _gridScrollController = ScrollController();

  List<VideoModel> _videos = [];
  String? _errorMessage;

  bool _isLoading = false;
  bool _hasMore = false;
  int _page = 0;

  @override
  void initState() {
    _currentNavItem = BottomNavItem.Home;
    super.initState();
    _loadVideos();

    _gridScrollController.addListener(() {
      if (_gridScrollController.position.pixels ==
          _gridScrollController.position.maxScrollExtent) {
        print('has more at end  :  $_hasMore');
        if (_hasMore && !_isLoading) {
          _loadVideos();
        }
      }
    });
  }

  @override
  void dispose() {
    _gridScrollController.dispose();
    super.dispose();
  }

  void _loadVideos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      VideoResponse videoResponse = await ApiService().fetchVideos(_page);
      setState(() {
        if (videoResponse.hasMore) {
          _hasMore = true;
          _page++;
          _videos.addAll(videoResponse.videos);
        } else {
          _hasMore = false;
          _videos.addAll(videoResponse.videos);
        }
      });
    } catch (e) {
      setState(() {
        print('error msg is  :  ${e.toString()}');
        _errorMessage =
            'Failed to load videos. Please try again. : ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.stream, color: Colors.blue, size: 32),
              SizedBox(width: 8),
              Text(
                'NexStream',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.upload_file),
                onPressed: _onUploadVideoTap,
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.bell),
                onPressed: () {},
              ),
              GestureDetector(
                onTap: themeService.toggleTheme,
                child: Icon(themeService.isDarkMode
                    ? Icons.sunny
                    : Icons.nightlight_round),
              ),
            ],
          ),
          elevation: 0,
        ),
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentNavItem.index,
          onTap: _onNavItemTapped,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ));
  }

  Widget _buildBody() {
    if (_isLoading && _videos.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadVideos,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_videos.isEmpty) {
      return Center(child: Text('No videos available at the moment.'));
    }

    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        SearchBarWidget(),
        SizedBox(
          height: 10,
        ),
        CarouselViewWidget(videos: _videos),
        SizedBox(height: 20),
        SectionTitle(title: 'Recommendations'),
        Expanded(
          child: _buildRecommendedVideos(),
        ),
      ],
    );
  }

  Widget _buildRecommendedVideos() {
    return CustomScrollView(
      controller: _gridScrollController,
      slivers: [
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
            childAspectRatio: 0.7,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final movie = _videos[index];
              return MovieCard(movie: movie);
            },
            childCount: _videos.length,
          ),
        ),
        if (_hasMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }

  void _onUploadVideoTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => upload.VideoUploadPage()),
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentNavItem = BottomNavItem.values[index];
    });

    if (_currentNavItem == BottomNavItem.Dashboard) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserDashboardPage()),
      );
    } else if (_currentNavItem == BottomNavItem.Settings) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage()),
      );
    }
  }
}
