import 'package:calendar_view/calendar_view.dart';
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

enum HomeMenu {
  edit,
  logout,
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime firstDay = DateTime(now.year, now.month, 1);
    DateTime lastDay = DateTime(now.year, now.month + 1, 0);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.darkblue,
        title: Text('Welcome Shark', style: AppText.header1),

        actions: [
          PopupMenuButton<HomeMenu>(
            onSelected: (value) {
              switch (value) {
                case HomeMenu.edit:
                  Navigator.of(context).pushNamed(AppRoutes.edit_profile);
                  break;
                case HomeMenu.logout:
                  print('logout');
                  break;
                default:
              }
            },
            icon: Icon(Icons.more_vert_rounded),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('edit'),
                  value: HomeMenu.edit,
                ),
                PopupMenuItem(
                  child: Text('logout'),
                  value: HomeMenu.logout,
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        
        children: [
          
          // Rounded Image
          Padding(
            padding: EdgeInsets.all(16),
            child: ClipOval(
              child: Image.asset(
                'assets/temp/User Icon.png',
                width: 100, // Adjust the width as needed
                height: 100, // Adjust the height as needed
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Weekly TableCalendar Widget
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
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: AppColors.darkblue),
              weekendStyle: TextStyle(color: AppColors.darkblue),
            ),
          ),

          // Expanded Lower Part of the Screen with Padding
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.lighterBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Today's Date in Bold
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                      child: Text(
                        'Today: ${DateFormat('MMMM d, yyyy').format(now)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Clickable Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Agenda Icon
                        GestureDetector(
                          onTap: () {
                            // Handle Agenda Icon Click
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AgendaPage()));
                            print('Agenda icon clicked');
                          },
                          child: Column(
                            children: [
                              Icon(Icons.more_vert, size: 40, color: AppColors.darkblue),
                              SizedBox(height: 8),
                              Text('Agenda'),
                            ],
                          ),
                        ),

                        // Goal Icon
                        GestureDetector(
                          onTap: () {
                            // Handle Goal Icon Click
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => GoalPage()));
                            print('Goal icon clicked');
                          },
                          child: Column(
                            children: [
                              Icon(Icons.star, size: 40, color: AppColors.darkblue),
                              SizedBox(height: 8),
                              Text('Goal'),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Storage Icon and Calendar Icon in the same row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Storage Icon
                        GestureDetector(
                          onTap: () {
                            // Handle Storage Icon Click
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => StoragePage()));
                            print('Storage icon clicked');
                          },
                          child: Column(
                            children: [
                              Icon(Icons.storage, size: 40, color: AppColors.darkblue),
                              SizedBox(height: 8),
                              Text('Storage'),
                            ],
                          ),
                        ),

                        // Calendar Icon
                        GestureDetector(
                          onTap: () {
                            print('Calendar icon clicked');
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding: EdgeInsets.all(10), // Add some padding to the Dialog
                                  backgroundColor: Colors.transparent, // Ensures no white background for rounded corners
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25), // Curved edges for the Dialog
                                  ),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeOut,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25), // Curved edges for the AnimatedContainer
                                    ),
                                    width: MediaQuery.of(context).size.width * 0.85,
                                    height: MediaQuery.of(context).size.height * 0.9,
                                    child: FullScreenCalendarPage(), // Your FullScreenCalendarPage widget
                                  ),
                                );
                              },
                            );
                          },
                          child: Column(
                            children: [
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

// Placeholder for the CalendarWidget, replace it with your actual calendar implementation
// class CalendarWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.now();
//     DateTime firstDay = DateTime(now.year, now.month, 1);
//     DateTime lastDay = DateTime(now.year, now.month + 1, 0);
//
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             height: 500, // Adjust the height as needed
//             child: TableCalendar(
//               focusedDay: now,
//               firstDay: firstDay,
//               lastDay: lastDay,
//               startingDayOfWeek: StartingDayOfWeek.monday,
//               calendarFormat: CalendarFormat.month,
//               headerStyle: HeaderStyle(
//                 formatButtonVisible: false,
//               ),
//               calendarStyle: CalendarStyle(
//                 todayDecoration: BoxDecoration(
//                   color: Colors.blue,
//                   shape: BoxShape.circle,
//                 ),
//                 selectedDecoration: BoxDecoration(
//                   color: Colors.green,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }