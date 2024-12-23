import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  UserPreferences._privateConstructor();

  static final UserPreferences instance = UserPreferences._privateConstructor();

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId); // Storing the user_id as a String
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> removeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id'); // Removing the user_id
  }

  Future<void> addToWatchHistory(
      String videoId, String thumbnail, String title) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the existing watch history
    List<String> watchHistory = prefs.getStringList('watch_history') ?? [];

    // Create a new video map
    Map<String, String> videoData = {
      'videoId': videoId,
      'thumbnail': thumbnail,
      'title': title,
    };

    // Check if the videoId already exists
    bool alreadyExists = watchHistory.any((item) {
      final decodedItem = Map<String, dynamic>.from(jsonDecode(item));
      return decodedItem['videoId'] == videoId;
    });

    // Add only if it doesn't already exist
    if (!alreadyExists) {
      watchHistory.add(jsonEncode(videoData));
      await prefs.setStringList('watch_history', watchHistory);
    }
  }

  // Get the watch history
  Future<List<Map<String, String>>> getWatchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> watchHistory = prefs.getStringList('watch_history') ?? [];

    // Decode the stored JSON strings into a list of maps
    return watchHistory.map((item) {
      return Map<String, String>.from(jsonDecode(item));
    }).toList();
  }

  // Clear watch history
  Future<void> clearWatchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('watch_history');
  }

  Future<void> addToReportVideos(
      String videoId, String thumbnail, String title) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the existing report videos
    List<String> reportVideos = prefs.getStringList('report_videos') ?? [];

    // Create a new video map
    Map<String, String> videoData = {
      'videoId': videoId,
      'thumbnail': thumbnail,
      'title': title,
    };

    // Check if the videoId already exists
    bool alreadyExists = reportVideos.any((item) {
      final decodedItem = Map<String, dynamic>.from(jsonDecode(item));
      return decodedItem['videoId'] == videoId;
    });

    // Add only if it doesn't already exist
    if (!alreadyExists) {
      reportVideos.add(jsonEncode(videoData));
      await prefs.setStringList('report_videos', reportVideos);
    }
  }

  // Get the report videos
  Future<List<Map<String, String>>> getReportVideos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> reportVideos = prefs.getStringList('report_videos') ?? [];

    // Decode the stored JSON strings into a list of maps
    return reportVideos.map((item) {
      return Map<String, String>.from(jsonDecode(item));
    }).toList();
  }

  // Clear report videos
  Future<void> clearReportVideos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('report_videos');
  }

  Future<void> saveUserDetails(String username, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username); // Storing the username
    await prefs.setString('email', email); // Storing the email
  }

  Future<Map<String, String?>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? email = prefs.getString('email');
    return {'username': username, 'email': email};
  }

  Future<void> removeUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('email');
  }

  // Clear everything
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all stored data
  }
}
