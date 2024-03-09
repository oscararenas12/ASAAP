import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Information Collected:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'ASAAPP may collect personal information, such as names, email addresses, location data, and user-generated content, to provide personalized services.',
            ),

            SizedBox(height: 20),

            Text(
              '2. Changes to Terms:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'ASAAPP reserves the right to update or modify these Terms and Conditions at any time without prior notice. Users are responsible for reviewing the terms regularly.',
            ),

            SizedBox(height: 20),

            Text(
              '3. User Registration:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Some features of ASAAPP may require user registration. Users must provide accurate and complete information during the registration process and keep their credentials secure.',
            ),

            SizedBox(height: 20),

            Text(
              '4. User Conduct:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Users are expected to conduct themselves responsibly while using ASAAPP. Prohibited activities include but are not limited to unauthorized access, data mining, and any action that may harm the integrity of the App.',
            ),

            SizedBox(height: 20),

            Text(
              '5. Intellectual Property:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'All content, trademarks, and materials on ASAAPP are the property of ASAAPP and are protected by intellectual property laws. Users may not reproduce, distribute, or create derivative works without explicit permission.',
            ),

            SizedBox(height: 20),

            Text(
              '6. Disclaimer of Warranty:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'ASAAPP is provided "as is" without any warranties, expressed or implied. We do not guarantee the accuracy, reliability, or completeness of any content or information provided.',
            ),

            SizedBox(height: 20),

            Text(
              '7. Limitation of Liability:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'ASAAPP and its affiliates shall not be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in connection with the use of the App.',
            ),

            // ... Other privacy policy points

            SizedBox(height: 20),

            Text(
              '8. Contact Information:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'For any questions or concerns about these terms and conditions or the privacy policy, please contact ASAAPP at ASAapp@gmail.com.',
            ),
          ],
        ),
      ),
    );
  }
}
