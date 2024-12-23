import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
        // backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms and Conditions for NxtStream',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Last updated: December 2024',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              Text(
                '1. Acceptance of Terms\n\nBy using the NxtStream App, you agree to these Terms. NxtStream reserves the right to update or modify these Terms at any time, and you are responsible for reviewing these updates. Continued use of the App after any changes constitutes your acceptance of the modified Terms.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '2. Account Registration\n\nTo use certain features of NxtStream, you may need to create an account. You must provide accurate and complete information during registration and update your information as needed. You are responsible for maintaining the confidentiality of your account credentials and are liable for any activity under your account.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '3. Subscription and Payment\n\nNxtStream offers both free and premium subscription plans. If you subscribe to a premium plan, you agree to pay the subscription fees as specified. Payments are non-refundable, except as required by applicable law. We reserve the right to modify subscription fees or offer new plans at any time.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
