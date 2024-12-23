import 'package:flutter/material.dart';

class LoginLogoView extends StatelessWidget {
  const LoginLogoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.lightBlue.shade50,
          child: Icon(Icons.person, size: 50, color: Colors.blueAccent),
        ),
        SizedBox(height: 10),
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade700,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Log in to your account',
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey.shade400,
          ),
        ),
      ],
    );
  }
}
