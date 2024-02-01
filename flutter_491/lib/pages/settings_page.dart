import 'package:flutter/material.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: _isDarkModeEnabled(),
                onChanged: (value) {
                  _toggleDarkMode(value);
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Notifications'),
              onTap: () {
                // Navigate to the notification settings page
                // You can implement this based on your app's structure
              },
            ),
            Divider(),
            Text(
              'Account Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
            ListTile(
              title: Text('Change Password'),
              onTap: () {
                // Navigate to the change password page
                // You can implement this based on your app's structure
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                // Implement logout functionality
                // You can clear user data or navigate to the login page
              },
            ),
            Divider(),
            Text(
              'Other Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
            ListTile(
              title: Text('Privacy Policy'),
              onTap: () {
                _launchURL('https://example.com/privacy-policy');
              },
            ),
            Divider(),
            ListTile(
              title: Text('Terms of Service'),
              onTap: () {
                _launchURL('https://example.com/terms-of-service');
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _isDarkModeEnabled() {
    // Replace this with your actual dark mode logic using SharedPreferences
    // For example, you can store a boolean value in SharedPreferences
    return true; // Placeholder value
  }

  Future<void> _toggleDarkMode(bool value) async {
    // Replace this with your actual logic to toggle dark mode using SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
