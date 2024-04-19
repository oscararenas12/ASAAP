import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_backend.dart'; // Import your calendar backend

class FullScreenCalendarPage extends StatefulWidget {
  const FullScreenCalendarPage({super.key});

  @override
  _FullScreenCalendarPageState createState() => _FullScreenCalendarPageState();
}

class _FullScreenCalendarPageState extends State<FullScreenCalendarPage> {
  late EventController _eventController;
  DateTime? _selectedDay;
  bool _isButtonsVisible = false;
  late Calendar _calendar; // Add a Calendar instance

  @override
  void initState() {
    super.initState();
    _eventController = EventController();
    _selectedDay = DateTime.now();;
    _initializeCalendar(); // Initialize the calendar
  }

  // Initialize the calendar with the current user's ID and calendar ID
  void _initializeCalendar() async {
    _calendar = await Calendar.create();
    final startDate = DateTime.now().subtract(Duration(days: 365));
    final endDate = DateTime.now().add(Duration(days: 365));
    await _calendar.fetchEventsAndTasks(_calendar, startDate, endDate);

    // After fetching, convert and add them to the EventController
    for (var scheduleItem in _calendar.scheduleItemsById.values) {
      if (scheduleItem is Event) {
        _eventController.add(eventToCalendarEventData(scheduleItem));
      } else if (scheduleItem is Task) {
        _eventController.add(taskToCalendarEventData(scheduleItem)); // Add tasks to the event controller
      }
    }
    setState(() {});
  }

  bool isDateInRecurrencePattern(Event event, DateTime date) {
    DateTime currentDate = DateTime(date.year, date.month, date.day);
    DateTime startDate = DateTime(event.startTime.year, event.startTime.month, event.startTime.day);
    DateTime? endDate = event.recurrence.endDate;

    if (currentDate.isBefore(startDate) || (endDate != null && currentDate.isAfter(endDate))) {
      return false;
    }

    switch (event.recurrence.type) {
      case RecurrenceType.daily:
        return true;
      case RecurrenceType.weekly:
        return currentDate.difference(startDate).inDays % 7 == 0;
      case RecurrenceType.monthly:
        return currentDate.month == startDate.month && currentDate.day == startDate.day;
      default:
        return currentDate.isAtSameMomentAs(startDate);
    }
  }

  Widget _buildMonthView() {
    // Helper function to get color based on category
    Color getCategoryColor(String category) {
      switch (category) {
        case 'Work':
          return Colors.red;
        case 'School':
          return Colors.yellow;
        case 'Personal':
          return Colors.green;
        default:
          return Colors.blue; // Default color if category not matched
      }
    }

    return MonthView(
      controller: _eventController,
      cellBuilder: (date, eventList, isToday, isInMonth) {
        final bool isSelectedDay = _selectedDay != null && date.isAtSameMomentAs(_selectedDay!);

        // Separate events and tasks
        List<CalendarEventData<Event>> eventsForDay = eventList
            .where((e) => e.event is Event)
            .toList()
            .cast<CalendarEventData<Event>>();
        List<CalendarEventData<Task>> tasks = eventList.where((e) => e.event is Task).toList().cast<CalendarEventData<Task>>();

        // Filter events to show only those that start or end on the current date
        eventsForDay = eventsForDay.where((event) =>
        event.date.isAtSameMomentAs(date) ||
            (event.endDate != null && event.endDate!.isAtSameMomentAs(date)) ||
            isDateInRecurrencePattern(event.event!, date)
        ).toList();

        // Determine the background color
        Color backgroundColor;
        if (isSelectedDay) {
          backgroundColor = Colors.blue[100]!;
        } else if (isToday) {
          backgroundColor = Colors.blue;
        } else {
          backgroundColor = Colors.white;
        }

        final double topPadding = 30.0;

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
            child: Stack(
              children: [
                // Align the day number to the top-right
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(color: isInMonth ? Colors.black : Colors.grey),
                    ),
                  ),
                ),
                // Position the events/tasks starting from the center
                Padding(
                  padding: EdgeInsets.only(top: topPadding),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const ClampingScrollPhysics(), // Enable scrolling physics
                    shrinkWrap: true,
                    children: [
                      // Display all events
                      for (var event in eventsForDay)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: getCategoryColor(event.event!.category).withOpacity(0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              event.title,
                              style: const TextStyle(fontSize: 10, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      // Display all tasks
                      for (var task in tasks)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: getCategoryColor(task.event!.category).withOpacity(0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              task.title,
                              style: const TextStyle(fontSize: 10, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      minMonth: DateTime.now().subtract(const Duration(days: 365)),
      maxMonth: DateTime.now().add(const Duration(days: 365)),
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

  void _showAddTaskDialog(BuildContext context) {
    DateTime? selectedDueDate = _selectedDay;
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String? selectedCategory = getPredefinedCategories().keys.first;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    ListTile(
                      title: Text(selectedDueDate != null
                          ? 'Due Date: ${selectedDueDate?.year}-${selectedDueDate?.month}-${selectedDueDate?.day}'
                          : 'Choose Due Date'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDueDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null && pickedDate != selectedDueDate) {
                          setState(() {
                            selectedDueDate = pickedDate;
                          });
                        }
                      },
                    ),
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
                Task newTask = Task(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  description: descriptionController.text,
                  dueDate: selectedDueDate ?? DateTime.now(),
                  category: selectedCategory ?? 'Personal',
                  recurrence: Recurrence(type: RecurrenceType.once),
                  priority: PriorityLevel.medium,
                  currentStatus: Status.notStarted,
                  itemType: ItemType.task,
                );

                _calendar.addScheduleItem(newTask, _calendar.userId!, _calendar.calendarId!);
                _eventController.add(taskToCalendarEventData(newTask));
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddEventDialog(BuildContext context) {
    DateTime? selectedStartDate = _selectedDay;
    DateTime? selectedEndDate = _selectedDay;
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    String? recurrence = 'Once';
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String? selectedCategory = getPredefinedCategories().keys.first;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Event'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    ListTile(
                      title: Text(selectedStartDate != null
                          ? 'Start Date: ${selectedStartDate?.year}-${selectedStartDate?.month}-${selectedStartDate?.day}'
                          : 'Choose Start Date'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedStartDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null && pickedDate != selectedStartDate) {
                          setState((){
                            selectedStartDate = pickedDate;
                          });
                        }
                      },
                    ),
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
                      trailing: const Icon(Icons.access_time),
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
                      trailing: const Icon(Icons.access_time),
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

                DateTime now = DateTime.now();
                DateTime today = DateTime(now.year, now.month, now.day);

                // Use today's date as a fallback if selectedStartDate or selectedEndDate is null
                DateTime startDate = selectedStartDate ?? today;
                DateTime endDate = selectedEndDate ?? today;

                // Set default start and end times if not provided
                TimeOfDay defaultStartTime = TimeOfDay(hour: 9, minute: 0); // Example: 9:00 AM
                TimeOfDay defaultEndTime = TimeOfDay(hour: 17, minute: 0); // Example: 5:00 PM

                // Use provided times or default times if not provided
                TimeOfDay startTimeToUse = startTime ?? defaultStartTime;
                TimeOfDay endTimeToUse = endTime ?? defaultEndTime;

                // Combine dates and times
                startDateTime = DateTime(
                  startDate.year,
                  startDate.month,
                  startDate.day,
                  startTimeToUse.hour,
                  startTimeToUse.minute,
                );

                endDateTime = DateTime(
                  endDate.year,
                  endDate.month,
                  endDate.day,
                  endTimeToUse.hour,
                  endTimeToUse.minute,
                );

                Event newEvent = Event(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
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

                _calendar.addScheduleItem(newEvent, _calendar.userId!, _calendar.calendarId!);
                _eventController.add(eventToCalendarEventData(newEvent));
                setState(() {});
                Navigator.of(context).pop();
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
                    _showAddEventDialog(context);
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
                    _showAddTaskDialog(context);
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
