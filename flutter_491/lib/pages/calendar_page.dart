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
  bool _isButtonsVisible = false; // Variable to track the visibility of the buttons

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
    TimeOfDay? startTime; // Variable to store the start time
    TimeOfDay? endTime; // Variable to store the end time
    String? recurrence = 'Once'; // Default to 'Once'

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
                  if (eventType == 'Event') // Recurrence option for events
                    Column(
                      children: [
                        ListTile(
                          title: Text(startTime != null
                              ? 'Start Time: ${startTime?.format(context)}'
                              : 'Choose Start Time'),
                          trailing: Icon(Icons.access_time),
                          onTap: () async {
                            final TimeOfDay? pickedStartTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedStartTime != null && pickedStartTime != startTime) {
                              setState(() {
                                startTime = pickedStartTime;
                              });
                            }
                          },
                        ),
                        ListTile(
                          title: Text(endTime != null
                              ? 'End Time: ${endTime?.format(context)}'
                              : 'Choose End Time'),
                          trailing: Icon(Icons.access_time),
                          onTap: () async {
                            final TimeOfDay? pickedEndTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedEndTime != null && pickedEndTime != endTime) {
                              setState(() {
                                endTime = pickedEndTime;
                              });
                            }
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: recurrence,
                          decoration: InputDecoration(labelText: 'Recurrence'),
                          items: ['Once', 'Daily', 'Weekly', 'Monthly']
                              .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              recurrence = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  if (eventType == 'Task') // Recurrence option for tasks
                    DropdownButtonFormField<String>(
                      value: recurrence,
                      decoration: InputDecoration(labelText: 'Recurrence'),
                      items: ['Once', 'Daily', 'Weekly', 'Monthly']
                          .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          recurrence = newValue;
                        });
                      },
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: Text('Cancel'),
            ),
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


  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: _eventController,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: _isButtonsVisible,
              child: Container(
                width: 35, // Custom width for the button
                height: 35, // Custom height for the button
                child: FloatingActionButton(
                  onPressed: () {
                    _showAddEventDialog(context, 'Event');
                  },
                  child: Icon(Icons.calendar_today),
                  heroTag: 'eventButton',
                ),
              ),
            ),
            SizedBox(height: 10),
            Visibility(
              visible: _isButtonsVisible,
              child: Container(
                width: 35, // Custom width for the button
                height: 35, // Custom height for the button
                child: FloatingActionButton(
                  onPressed: () {
                    _showAddEventDialog(context, 'Task');
                  },
                  child: Icon(Icons.check),
                  heroTag: 'taskButton',
                ),
              ),
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isButtonsVisible = !_isButtonsVisible; // Toggle the visibility of the buttons
                });
              },
              child: Icon(Icons.add),
              heroTag: 'mainButton',
            ),
          ],
        ),
        body: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: _buildMonthView(),
          ),
        ),
      ),
    );
  }
}

