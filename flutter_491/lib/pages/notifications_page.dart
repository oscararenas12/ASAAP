import 'package:flutter/material.dart';
import 'package:flutter_491/components/app_textfield.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:flutter_491/components/user_avatar.dart';
import 'package:flutter_491/styles/app_colors.dart';

import 'package:flutter/material.dart';



class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Toolbar(title: 'Notifications'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: MySettings(),
          ),
        ),
      );

  }
}

class MySettings extends StatefulWidget {
  @override
  _MySettingsState createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  Map<String, bool> personalGoals = {
    'Daily Goals': false,
    'Weekly Goals': false,
    'Long Term Goals': false,
  };

  Map<String, bool> schoolWork = {
    'Important Dates': false,
    'Homework Due Dates': false,
  };

  Map<String, bool> aiNotifications = {
    'AI Notifications': false,
  };

  Widget sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  List<Widget> buildSwitchListTiles(Map<String, bool> settings) {
    return settings.keys.map((String key) {
      return Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.darkblue, // Or your AppColors.darkblue
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: SwitchListTile(
          title: Text(key,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          value: settings[key]!,
          activeColor: Colors.lightBlue,
          inactiveThumbColor: Colors.grey,
          onChanged: (bool value) {
            setState(() {
              settings[key] = value;
            });
          },
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader('Personal Goals'),
        ...buildSwitchListTiles(personalGoals),
        sectionHeader('School Work'),
        ...buildSwitchListTiles(schoolWork),
        sectionHeader('AI Notifications'),
        ...buildSwitchListTiles(aiNotifications),
      ],
    );
  }
}
