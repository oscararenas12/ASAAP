import 'package:flutter/material.dart';
import 'package:flutter_491/main.dart';
import 'package:flutter_491/pages/privacypolicy.dart';
import 'package:flutter_491/pages/termsandconditions.dart';
import 'package:flutter_491/pages/themenotifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:provider/provider.dart';

//new code for the setting page by Nhat
//do so because themenotifier required a different approach
//in order to make darkmode change automatically
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildSettingsListTiles(context),
        ),
      ),
    );
  }

  List<Widget> buildSettingsListTiles(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return [
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.darkblue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SwitchListTile(
          title: Text(
            'Dark Mode',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          value: themeNotifier.isDarkMode,
          activeColor: Colors.lightBlue,
          inactiveThumbColor: Colors.grey,
          onChanged: (bool value) {
            themeNotifier.toggleDarkMode();
          },
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.darkblue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          title: Text(
            'Change Password',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onTap: () {
            // Implement logic for Change Password
          },
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.darkblue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          title: Text(
            'Privacy Policy',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
            );
          },
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.darkblue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          title: Text(
            'Terms of Service',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
            );
          },
        ),
      ),
    ];
  }
}
