import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VideoStats {
  final int totalVideos;
  final int totalViews;
  final List<int> videoUploadsPerMonth;

  VideoStats({
    required this.totalVideos,
    required this.totalViews,
    required this.videoUploadsPerMonth,
  });

  factory VideoStats.fromJson(Map<String, dynamic> json) {
    return VideoStats(
      totalVideos: json['total_videos'],
      totalViews: json['total_views'],
      videoUploadsPerMonth:
          List<int>.from(json['video_uploads_per_month'].map((x) => x)),
    );
  }
}

class AdminStatistics extends StatelessWidget {
  final String apiUrl = 'https://api.nexstream.live/api/admin/video-stats';

  Future<VideoStats> fetchStats() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return VideoStats.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load statistics');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<VideoStats>(
          future: fetchStats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final stats = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatCard(
                      icon: FontAwesomeIcons.video,
                      title: 'Total Videos',
                      value: stats.totalVideos.toString(),
                    ),
                    _StatCard(
                      icon: FontAwesomeIcons.eye,
                      title: 'Total Views',
                      value: stats.totalViews.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Video Uploads per Month',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _MonthlyUploadsChart(data: stats.videoUploadsPerMonth),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _MonthlyUploadsChart extends StatelessWidget {
  final List<int> data;

  const _MonthlyUploadsChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: true),
          gridData: FlGridData(show: true),
          barGroups: List.generate(
            data.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data[index].toDouble(),
                  color: Colors.blue,
                  width: 20,
                  borderRadius: BorderRadius.zero,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
