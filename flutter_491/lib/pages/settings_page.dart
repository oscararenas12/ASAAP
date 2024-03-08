
import 'package:flutter/material.dart';
import 'package:flutter_491/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_491/styles/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences _prefs;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }


  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = _prefs.getBool('darkMode') ?? false; // Jessica 

    });
  }

// Jessica 
  List<Widget> buildSettingsListTiles(Map<String, dynamic> settings) {
    return settings.keys.map((String key) {
      if (key == 'Dark Mode') {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.darkblue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SwitchListTile(
            title: Text(
              key,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            value: _isDarkMode,
            activeColor: Colors.lightBlue,
            inactiveThumbColor: Colors.grey,
            onChanged: (bool value) {
              _toggleDarkMode(value);
            },
          ),
        );
      } else {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.darkblue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            title: Text(
              key,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              _handleSettingsTap(key);
            },
          ),
        );
      }
    }).toList();
  }

  void _handleSettingsTap(String key) {
    switch (key) {
      //case 'Account Settings':
        // Implement logic for Account Settings
        //break;
      case 'Change Password':
        // Implement logic for Change Password
        break;
      //case 'Other Settings':
        // Implement logic for Other Settings
        //break;
      case 'Privacy Policy':
        _launchURL('https://example.com/privacy-policy');
        break;
      case 'Terms of Service':
        _launchURL('https://example.com/terms-of-service');
        break;
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

// Jessica 
  Future<void> _toggleDarkMode(bool value) async {
    setState(() {
      _isDarkMode = value;
    });

    await _prefs.setBool('darkMode', value);

    if (value) {
      MyApp.setDarkMode();
    } else {
      MyApp.setLightMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: _prefs == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildSettingsListTiles({
                  'Dark Mode': _isDarkMode, //Jessica Banuelos
                  'Change Password': null,
                  'Privacy Policy': null,
                  'Terms of Service': null,
                }),
              ),
            ),
    );
  }
}
