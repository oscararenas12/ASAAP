import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';

class FullScreenCalendarPage extends StatefulWidget {
  @override
  _FullScreenCalendarPageState createState() => _FullScreenCalendarPageState();
}

class _FullScreenCalendarPageState extends State<FullScreenCalendarPage> {
  late EventController _eventController;
  DateTime? _selectedDay; // Variable to track the selected day
  DateTime? _focusedDay; // Variable to track the current focused month for the header

  @override
  void initState() {
    super.initState();
    _eventController = EventController();
    _selectedDay = DateTime.now(); // Initialize with the current day
    _focusedDay = DateTime.now(); // Initialize with the current month
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
      minMonth: DateTime.now().subtract(Duration(days: 365)),
      // one year back
      maxMonth: DateTime.now().add(Duration(days: 365)),
      // one year forward
      initialMonth: DateTime.now(),
      startDay: WeekDays.sunday,
      onEventTap: (event, date) => print('Tapped on event $event'),
      onDateLongPress: (date) => print('Long pressed date $date'),
    );
  }

  void _showAddEventDialog(BuildContext context, String eventType) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add $eventType'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  // Add more fields if needed
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add logic to save event/task details and update the calendar
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Updated to show a popup menu
  // This new method shows a pop-up menu to choose between adding an Event or a Task
  void _showAddMenu(BuildContext context) async {
    final RenderBox fabRenderBox = context.findRenderObject() as RenderBox;
    final fabPosition = fabRenderBox.localToGlobal(Offset.zero);

    // Here you can adjust these offsets
    final double offsetX = -410.0; // horizontal offset from the FAB
    final double offsetY = -1220.0; // vertical offset from the FAB

    final left = fabPosition.dx - offsetX; // move left from the FAB's right edge
    final top = fabPosition.dy - fabRenderBox.size.height - offsetY; // move up from the FAB's bottom edge
    final right = left + fabRenderBox.size.width + offsetX * 2; // maintain the width of the popup menu
    final bottom = top + fabRenderBox.size.height + offsetY; // maintain the height

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, bottom),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          value: 'event',
          child: Icon(Icons.calendar_today), // Calendar symbol for events
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0), // Adjust padding as needed
        ),
        PopupMenuItem(
          value: 'task',
          child: Icon(Icons.check), // Check mark for tasks
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0), // Adjust padding as needed
        ),
      ],
      constraints: BoxConstraints(
        minWidth: 0, // Minimum width of the menu box
        maxWidth: 100, // Maximum width of the menu box, ensure it is equal to minWidth for a fixed width
        minHeight: 0, // Minimum height of the menu box
        maxHeight: 100, // Maximum height of the menu box, ensure it is equal to minHeight for a fixed height
      ),
    ).then((value) {
      if (value != null) {
        if (value == 'event') {
          _showAddEventDialog(context, 'Event');
        } else if (value == 'task') {
          _showAddEventDialog(context, 'Task');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: _eventController,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddMenu(context); // Call the _showAddMenu method here
          },
          child: Icon(Icons.add),
        ),
        body: ClipRRect(
          borderRadius: BorderRadius.circular(25), // This clips the Scaffold body
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the container
            ),
            child: _buildMonthView(), // The MonthView builder method
          ),
        ),
      ),
    );
  }
}

