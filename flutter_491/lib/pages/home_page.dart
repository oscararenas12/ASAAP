import 'package:flutter/material.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/pages/agenda.dart';
import 'package:flutter_491/pages/goal.dart';
import 'package:flutter_491/pages/storage_page.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'calendar_page.dart';
import 'weather_services.dart'; // Ensure you have this service set up to fetch weather data

final GlobalKey agendaKey = GlobalKey();
final GlobalKey goalKey = GlobalKey();
final GlobalKey storageKey = GlobalKey();
final GlobalKey calendarKey = GlobalKey();

enum HomeMenu {
  edit,
  logout,
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      WeatherService weatherService = WeatherService();
      Map<String, dynamic> data = await weatherService.fetchWeather();
      setState(() {
        weatherData = data;
      });
    } catch (e) {
      // If the weather data fails to load, use dummy data
      setState(() {
        weatherData = {'temp': '72°F', 'icon': Icons.wb_sunny};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime firstDay = DateTime(now.year, now.month, 1);
    DateTime lastDay = DateTime(now.year, now.month + 1, 0);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.darkblue,
        title: const Text('Welcome Shark', style: AppText.header1),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: weatherData == null
                ? Icon(Icons.wb_cloudy, color: Colors.white) // Placeholder icon when data is null
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(weatherData!['icon'] ?? Icons.wb_sunny, color: Colors.white),
                SizedBox(width: 5),
                Text('${weatherData!['temp'] ?? '72°F'}', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          PopupMenuButton<HomeMenu>(
            onSelected: (value) {
              switch (value) {
                case HomeMenu.edit:
                  Navigator.of(context).pushNamed(AppRoutes.edit_profile);
                  break;
                case HomeMenu.logout:
                  print('Logout clicked');
                  break;
                default:
              }
            },
            icon: const Icon(Icons.more_vert_rounded),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: HomeMenu.edit,
                child: Text('Edit Profile'),
              ),
              const PopupMenuItem(
                value: HomeMenu.logout,
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ClipOval(
              child: Image.asset(
                'assets/temp/User Icon.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          TableCalendar(
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: now,
            calendarFormat: CalendarFormat.week,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.darkblue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.darkblue,
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: AppColors.darkblue),
              weekendStyle: TextStyle(color: AppColors.darkblue),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.lighterBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                      child: Text(
                        'Today: ${DateFormat('MMMM d, yyyy').format(now)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AgendaPage()));
                            print('Agenda icon clicked');
                          },
                          child: Column(
                            key: agendaKey,
                            children: const [
                              Icon(Icons.more_vert, size: 40, color: AppColors.darkblue),
                              SizedBox(height: 8),
                              Text('Agenda'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => GoalPage()));
                            print('Goal icon clicked');
                          },
                          child: Column(
                            key: goalKey,
                            children: const [
                              Icon(Icons.star, size: 40, color: AppColors.darkblue),
                              SizedBox(height: 8),
                              Text('Goal'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => StoragePage()));
                            print('Storage icon clicked');
                          },
                          child: Column(
                            key: storageKey,
                            children: const [
                              Icon(Icons.storage, size: 40, color: AppColors.darkblue),
                              SizedBox(height: 8),
                              Text('Storage'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Calendar icon clicked');
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding: const EdgeInsets.all(10),
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    width: MediaQuery.of(context).size.width * 0.85,
                                    height: MediaQuery.of(context).size.height * 0.9,
                                    child: FullScreenCalendarPage(), // Implement your calendar page here
                                  ),
                                );
                              },
                            );
                          },
                          child: Column(
                            key: calendarKey,
                            children: const [
                              Icon(Icons.event, size: 40, color: AppColors.darkblue),
                              SizedBox(height: 8),
                              Text('Calendar'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
