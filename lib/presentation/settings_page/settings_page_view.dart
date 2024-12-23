import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexstream/presentation/auth_screens/login/login_page.dart';
import 'package:nexstream/presentation/settings_page/widgets/privacy_policy_page.dart';
import 'package:nexstream/presentation/settings_page/widgets/profile_card.dart';
import 'package:nexstream/presentation/settings_page/widgets/section_header.dart';
import 'package:nexstream/presentation/settings_page/widgets/settings_tile.dart';
import 'package:nexstream/presentation/settings_page/widgets/terms_and_condtions_view.dart';
import 'package:nexstream/presentation/utils/theme_service.dart';
import 'package:nexstream/sharedpref/shared_prefference.dart';
import 'package:provider/provider.dart';
import '../auth_screens/service/auth_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _username = '';
  String _email = '';
  String _profilePictureUrl = '';

  String _appVersion = 'V1.0.0.1';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    User? user = await AuthService().currentUser;

    if (user != null) {
      _getUserDetails();
    } else {
      setState(() {
        _username = 'Guest';
        _email = 'Not logged in';
        _profilePictureUrl = '';
      });
    }
  }

  Future<void> _getUserDetails() async {
    final userDetails = await UserPreferences.instance.getUserDetails();
    setState(() {
      _username = userDetails['username'] ?? 'User';
      _email = userDetails['email'] ?? 'user@example.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blueAccent,
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SectionHeader(title: 'Profile'),
            ProfileCard(
                profilePictureUrl: _profilePictureUrl,
                userName: _username,
                email: _email),
            SizedBox(height: 20),
            SectionHeader(title: 'Theme'),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: themeService.isDarkMode,
              onChanged: (value) {
                setState(() {});
                themeService.toggleTheme();
              },
              activeColor: Colors.blueAccent,
            ),
            SizedBox(height: 20),
            SectionHeader(title: 'Legal'),
            SettingsTile(
              icon: FontAwesomeIcons.fileContract,
              title: 'Terms and Conditions',
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      TermsAndConditionsPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                ));
              },
            ),
            SettingsTile(
              icon: FontAwesomeIcons.fileAlt,
              title: 'Privacy Policy',
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      PrivacyPolicyPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                ));
              },
            ),
            SizedBox(height: 20),
            if (_username == 'Guest') ...[
              SectionHeader(title: 'Account'),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        videoId: '',
                      ),
                    ),
                  );
                },
                child: Text('Login'),
              ),
              SizedBox(height: 20),
            ] else ...[
              SectionHeader(title: 'Account'),
              SettingsTile(
                icon: FontAwesomeIcons.signOutAlt,
                title: 'Logout',
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
              SizedBox(height: 20),
            ],
            SectionHeader(title: 'App Info'),
            ListTile(
              title: Text('Version: $_appVersion'),
              leading: Icon(
                FontAwesomeIcons.infoCircle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                AuthService().signOut(context, '');
                UserPreferences.instance.clearAll();
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
