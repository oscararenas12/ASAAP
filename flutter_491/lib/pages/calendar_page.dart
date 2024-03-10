import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'calendar_backend.dart'; // Import your calendar backend

// Define the list of predefined categories as a map
Map<String, Color> getPredefinedCategories() {
  return {
    Categories.personal: Colors.green,
    Categories.work: Colors.red,
    Categories.school: Colors.yellow,
    // Add more categories as needed
  };
}

class FullScreenCalendarPage extends StatefulWidget {
  @override
  _FullScreenCalendarPageState createState() => _FullScreenCalendarPageState();
}

class _FullScreenCalendarPageState extends State<FullScreenCalendarPage> {
  late EventController _eventController;
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  bool _isButtonsVisible = false;
  late Calendar _calendar; // Add a Calendar instance

  @override
  void initState() {
    super.initState();
    _eventController = EventController();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _initializeCalendar(); // Initialize the calendar
  }

  // Initialize the calendar with the current user's ID and calendar ID
  void _initializeCalendar() async {
    _calendar = await Calendar.create();
    setState(() {});
  }

  Widget _buildMonthView() {
    return MonthView(
      controller: _eventController,
      cellBuilder: (date, events, isToday, isInMonth) {
        final bool isSelectedDay = _selectedDay != null && date.isAtSameMomentAs(_selectedDay!);
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = date;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelectedDay ? Colors.blue[100] : (isToday ? Colors.blue : Colors.white),
              border: Border.all(color: Colors.white),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '${date.day}',
                  style: TextStyle(color: isInMonth ? Colors.black : Colors.grey),
                ),
              ),
            ),
          ),
        );
      },
      minMonth: DateTime.now().subtract(Duration(days: 365)),
      maxMonth: DateTime.now().add(Duration(days: 365)),
      initialMonth: DateTime.now(),
      startDay: WeekDays.sunday,
      onEventTap: (event, date) => print('Tapped on event $event'),
      onDateLongPress: (date) => print('Long pressed date $date'),
    );
  }

  RecurrenceType _getRecurrenceType(String? recurrence) {
    switch (recurrence) {
      case 'Daily':
        return RecurrenceType.daily;
      case 'Weekly':
        return RecurrenceType.weekly;
      case 'Monthly':
        return RecurrenceType.monthly;
      default:
        return RecurrenceType.once;
    }
  }


  void _showAddEventDialog(BuildContext context, String eventType) {
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    String? recurrence = 'Once';
    DateTime? selectedStartDate = _selectedDay;
    List<String> selectedDays = []; // List to store selected days
    DateTime? selectedEndDate = _selectedDay; // Initialize the end date with the selected day

    // Create TextEditingController instances for title and description
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    // List of all days of the week
    final List<String> daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    String? selectedCategory = getPredefinedCategories().keys.first;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add $eventType'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController, // Use the title controller
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: descriptionController, // Use the description controller
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    ListTile(
                      title: Text(selectedStartDate != null
                          ? 'Start Date: ${selectedStartDate?.year}-${selectedStartDate?.month}-${selectedStartDate?.day}'
                          :'Choose Date'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedStartDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null && pickedDate != selectedStartDate) {
                          setState(() {
                            selectedStartDate = pickedDate;
                          });
                        }
                      },
                    ),
                    if (eventType == 'Event')
                      Column(
                        children: [
                          ListTile(
                            title: Text(selectedEndDate != null
                                ? 'End Date: ${selectedEndDate?.year}-${selectedEndDate?.month}-${selectedEndDate?.day}'
                                : 'Choose End Date'),
                            trailing: Icon(Icons.calendar_today),
                            onTap: () async {
                              final DateTime? pickedEndDate = await showDatePicker(
                                context: context,
                                initialDate: selectedEndDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedEndDate != null && pickedEndDate != selectedEndDate) {
                                setState(() {
                                  selectedEndDate = pickedEndDate;
                                });
                              }
                            },
                          ),
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
                            items: ['Once', 'Daily', 'Weekly', 'Monthly', 'Custom']
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
                          if (recurrence == 'Custom')
                            Wrap(
                              children: daysOfWeek.map((day) {
                                return ChoiceChip(
                                  label: Text(day),
                                  selected: selectedDays.contains(day),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedDays.add(day);
                                      } else {
                                        selectedDays.remove(day);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    if (eventType == 'Task')
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(labelText: 'Category'),
                      items: getPredefinedCategories().keys
                          .map((String categoryName) => DropdownMenuItem<String>(
                        value: categoryName,
                        child: Text(categoryName),
                      ))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                DateTime? startDateTime;
                DateTime? endDateTime;

                if (startTime != null) {
                  startDateTime = DateTime(
                    selectedStartDate!.year,
                    selectedStartDate!.month,
                    selectedStartDate!.day,
                    startTime!.hour,
                    startTime!.minute,
                  );
                }

                if (endTime != null) {
                  endDateTime = DateTime(
                    selectedEndDate!.year,
                    selectedEndDate!.month,
                    selectedEndDate!.day,
                    endTime!.hour,
                    endTime!.minute,
                  );
                }

                  if (eventType == 'Event') {
                    // Create a new Event object using the calculated start and end times
                    Event newEvent = Event(
                      id: DateTime
                          .now()
                          .millisecondsSinceEpoch
                          .toString(),
                      title: titleController.text,
                      description: descriptionController.text,
                      dueDate: selectedEndDate ?? DateTime.now(),
                      startTime: startDateTime ?? DateTime.now(),
                      endTime: endDateTime ?? DateTime.now(),
                      category: selectedCategory ?? 'Personal',
                      recurrence: Recurrence(
                        type: _getRecurrenceType(recurrence),
                        interval: 1,
                        endDate: selectedEndDate ?? DateTime.now(),
                      ),
                      itemType: ItemType.event,
                    );

                    // Add the new event to the calendar
                    _calendar.addScheduleItem(
                        newEvent, _calendar.userId!, _calendar.calendarId!);
                  } else if (eventType == 'Task') {
                    // For tasks, only the dueDate is relevant
                    Task newTask = Task(
                      id: DateTime
                          .now()
                          .millisecondsSinceEpoch
                          .toString(),
                      title: titleController.text,
                      description: descriptionController.text,
                      dueDate: selectedEndDate ?? DateTime.now(),
                      category: selectedCategory ?? 'Personal',
                      recurrence: Recurrence(
                        type: _getRecurrenceType(recurrence),
                        interval: 1,
                      ),
                      priority: PriorityLevel.medium,
                      currentStatus: Status.notStarted,
                      itemType: ItemType.task,
                    );

                    // Add the new task to the calendar
                    _calendar.addScheduleItem(
                        newTask, _calendar.userId!, _calendar.calendarId!);
                  }

                  Navigator.of(context).pop(); // Close the dialog
                  setState(() {}); // Refresh the UI to display the new event or task
              },
              child: Text('Add'),
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
                width: 35,
                height: 35,
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
                width: 35,
                height: 35,
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
                  _isButtonsVisible = !_isButtonsVisible;
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
