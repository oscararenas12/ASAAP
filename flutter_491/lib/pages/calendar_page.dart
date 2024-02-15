import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';

class FullScreenCalendarPage extends StatefulWidget {
  @override
  _FullScreenCalendarPageState createState() => _FullScreenCalendarPageState();
}

class _FullScreenCalendarPageState extends State<FullScreenCalendarPage> {
  late EventController _eventController;
  DateTime? _selectedDay; // Variable to track the selected day

  @override
  void initState() {
    super.initState();
    _eventController = EventController();
  }

  // This method is used to build the MonthView.
  Widget _buildMonthView() {
    return MonthView(
      controller: _eventController,
      cellBuilder: (date, events, isToday, isInMonth) {
        final bool isSelectedDay =
            _selectedDay != null && date.isAtSameMomentAs(_selectedDay!);
        return GestureDetector(
          onTap: () {
            setState(() {
              print('Tapped on ${date.day}');
              _selectedDay = date; // Update the selected day
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelectedDay
                  ? Colors.blue[100]
                  : (isToday ? Colors.blue : Colors.white),
              border: Border.all(color: Colors.white),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0), // Add padding at the top for better positioning
                child: Text(
                  '${date.day}',
                  style:
                      TextStyle(color: isInMonth ? Colors.black : Colors.grey),
                ),
              ),
            ),
          ),
        );
      },
      minMonth: DateTime.now().subtract(Duration(days: 365)), // one year back
      maxMonth: DateTime.now().add(Duration(days: 365)), // one year forward
      initialMonth: DateTime.now(),
      startDay: WeekDays.sunday,
      onEventTap: (event, date) => print('Tapped on event $event'),
      onDateLongPress: (date) => print('Long pressed date $date'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: _eventController,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Calendar'),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the container
          ),
          child: _buildMonthView(), // The MonthView builder method
        ),
      ),
    );
  }
}
