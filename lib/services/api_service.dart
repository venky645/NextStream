// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nexstream/models/admin_user_model.dart';
import 'package:nexstream/models/user_model.dart';
import 'package:nexstream/models/video_comments_model.dart';
import 'package:nexstream/models/video_detail_model.dart';
import 'package:nexstream/sharedpref/shared_prefference.dart';
import '../models/video_response_model.dart';

class ApiService {
  static const String _baseUrl = 'https://api.nexstream.live';

  Future<VideoResponse> fetchVideos(int pageNum) async {
    //https://api.nexstream.live/api/dashboard?page=$pageNum
    final response =
        await http.get(Uri.parse('$_baseUrl/api/dashboard?page=$pageNum'));

    if (response.statusCode == 200) {
      return VideoResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load videos');
    }
  }

  Future<String?> reportVideo({required String videoId}) async {
    final String endpoint = '$_baseUrl/api/video/report/$videoId';
    final Map<String, dynamic> requestBody = {
      'dispute_type_id': 1,
    };

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<VideoDetailModel?> fetchVideoDetails({required String videoId}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/video/$videoId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> videoDetails = jsonDecode(response.body);

        print('video details : $videoDetails');

        final VideoDetailModel videoDetailResponse =
            VideoDetailModel.fromJson(videoDetails);

        return videoDetailResponse;
      } else {
        print(
            'Failed to fetch video details. Status Code: ${response.statusCode}');
        print('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching video details: $e');
      return null;
    }
  }

  Future<VideoCommentsModel?> fetchVideoComments({
    required String videoId,
    int pageNum = 0,
  }) async {
    print('fetch video comments called');
    final String endpoint = '$_baseUrl/comments/$videoId?page=$pageNum';

    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('success comments');
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print('json response comments:  $jsonResponse');

        // Ensure the response is valid before attempting to parse it
        if (jsonResponse.containsKey('comments')) {
          final VideoCommentsModel commentsResponse =
              VideoCommentsModel.fromJson(jsonResponse);
          print(
              'comments response length:  ${commentsResponse.comments.length}');
          return commentsResponse;
        } else {
          print('Invalid response format: comments not found');
          return null;
        }
      } else {
        print('Failed to fetch comments. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Log the exception for debugging
      print('Error fetching comments: $e');
      return null;
    }
  }

  Future<void> postComment({
    required String videoId,
    required String content,
  }) async {
    String? userId = await UserPreferences.instance.getUserId();
    final String endpoint = '$_baseUrl/api/comments/$videoId';

    final Map<String, dynamic> requestBody = {
      'user_id': userId,
      'content': content,
    };

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
      } else {
        print('Failed to post comment. Status Code: ${response.statusCode}');
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while posting comment: $e');
    }
  }

  Future<Map<String, dynamic>?> createUserSession(String email) async {
    final String endpoint = '$_baseUrl/api/user/session';

    final Map<String, String> requestBody = {
      "email": email,
    };

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Decode the JSON response
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        print('Session created successfully: $responseData');
        return responseData;
      } else {
        print('Failed to create session. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error during session creation: $e');
    }
    return null;
  }

  Future<UserBackendModel?> createUser(String name, String email) async {
    try {
      // print('name : $name, email : $email');
      final response = await http.post(
        Uri.parse('$_baseUrl/api/user'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        final responseBody = json.decode(response.body);

        return UserBackendModel.fromJson(responseBody);
      } else {
        print(response.body);
        print('status code : ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print("Error creating user: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> fetchAdminUsers(int page) async {
    try {
      final response = await http
          .get(Uri.parse('https://api.nexstream.live/api/admin/users'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Parse users
        final List<AdminUser> users = (jsonResponse['data'] as List)
            .map((userJson) => AdminUser.fromJson(userJson))
            .toList();

        // Parse pagination
        final Pagination pagination =
            Pagination.fromJson(jsonResponse['pagination']);

        return {'users': users, 'pagination': pagination};
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}
