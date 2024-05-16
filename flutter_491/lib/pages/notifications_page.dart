import 'package:flutter/material.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Notification Service for handling the logic of showing notifications
class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    try {
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    } catch (e) {
      print('Failed to initialize notifications: $e');
    }
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        0,  // Consider managing notification IDs for unique notifications
        title,
        body,
        platformChannelSpecifics,
      );
    } catch (e) {
      print('Failed to show notification: $e');
    }
  }
}

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
  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
    _notificationService.init();
  }

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
          color: AppColors.darkblue, // Using predefined AppColors.darkblue
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: SwitchListTile(
          title: Text(key, style: TextStyle(color: Colors.white)),
          value: settings[key]!,
          activeColor: Colors.lightBlue,
          inactiveThumbColor: Colors.grey,
          onChanged: (bool value) {
            setState(() {
              settings[key] = value;
            });
            if (value) {
              _notificationService.showNotification(
                  'Notification Enabled',
                  '$key is now enabled.'
              );
            }
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
