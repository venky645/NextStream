import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        // backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy for NxtStream',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Last updated: December 2024',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              Text(
                '1. Information We Collect\n\nWe collect the following types of information when you use NxtStream:\n\n- Personal Information: When you register an account, we may collect your name, email address, payment information, and other details you provide.\n- Usage Data: We collect data about how you interact with the App, including your viewing history, device information, and IP address.\n- Cookies and Tracking: We use cookies to enhance your experience and collect usage data. You can manage your cookie preferences through your device settings.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '2. How We Use Your Information\n\nWe use the collected information for the following purposes:\n- To provide and improve our services, including video streaming and content recommendations.\n- To process payments and manage your subscription.\n- To communicate with you, including sending updates, promotions, and customer support.\n- To analyze usage patterns and optimize the App.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '3. Sharing Your Information\n\nWe may share your information with third parties in the following circumstances:\n- Service Providers: We may share your data with third-party service providers to assist in providing the App (e.g., payment processors, cloud storage).\n- Legal Requirements: We may disclose your information if required by law or in response to a valid legal request.\n- Business Transfers: In the event of a merger, acquisition, or sale of assets, your information may be transferred to the acquiring entity.',
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
