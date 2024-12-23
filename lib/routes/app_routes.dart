// lib/routes/app_routes.dart

import 'package:flutter/material.dart';
import 'package:nexstream/presentation/settings_page/settings_page_view.dart';
import '../presentation/home_page/home_page.dart';
import '../presentation/auth_screens/login/login_page.dart';
import '../presentation/auth_screens/signup/signup_page.dart';
import '../presentation/video_upload_page.dart';
import '../presentation/dashboard_page/user_dashboard_page.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String watchSession = '/watchSession';
  static const String videoUpload = '/videoUpload';
  static const String userDashboard = '/userDashboard';
  static const String videoPlayer = '/videoPlayer';
  // static const String search = '/search';
  static const String settingsView = '/settingsView';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case login:
        return MaterialPageRoute(
            builder: (_) => LoginPage(
                  videoId: '',
                ));
      case signup:
        return MaterialPageRoute(builder: (_) => SignupPage());
      case videoUpload:
        return MaterialPageRoute(builder: (_) => VideoUploadPage());
      case userDashboard:
        return MaterialPageRoute(builder: (_) => UserDashboardPage());

      case settingsView:
        return MaterialPageRoute(builder: (_) => SettingsPage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
