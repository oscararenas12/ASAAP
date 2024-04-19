import 'dart:math';

import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Dart date formatting
import 'package:cloud_firestore/cloud_firestore.dart';

class Recurrence {
  final RecurrenceType type;
  final int interval;
  final DateTime? endDate;

  Recurrence({required this.type, this.interval = 1, this.endDate});
  factory Recurrence.fromMap(Map<String, dynamic> map) {
    return Recurrence(
      type: RecurrenceType.values.firstWhere((e) => e.toString() == map['type']),
      interval: map['interval'] ?? 1,
      endDate: map['endDate'] != null ? (map['endDate'] as Timestamp).toDate() : null,
    );
  }
}

// Define the list of predefined categories as a map
Map<String, Color> getPredefinedCategories() {
  return {
    Categories.personal: Colors.green,
    Categories.work: Colors.red,
    Categories.school: Colors.yellow,
    // Add more categories as needed
  };
}

/// *********************** SCHEDULED ITEM ABSTRACT CLASS *************************
abstract class ScheduleItem {
  String id;
  String title;
  String? description; // '?' denotes that description is not required
  DateTime dueDate;
  String category;
  Recurrence recurrence;
  ItemType itemType;

  ItemType getItemType();


  ScheduleItem({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.category,
    required this.recurrence,
    required this.itemType,
  });
}

enum PriorityLevel { low, medium, high, urgent }
enum Status { notStarted, inProgress, complete }
enum RecurrenceType { once, daily, weekly, monthly }
enum ItemType{ event, task}


class Categories {
  static const String work = 'Work';
  static const String personal = 'Personal';
  static const String school = 'School';
// Add more predefined categories as needed
}

/// **************************** TASK CLASS ***********************************
class Task extends ScheduleItem {
  PriorityLevel priority;
  Status currentStatus;
  @override
  ItemType itemType;

  @override
  ItemType getItemType() => ItemType.task;
  void setPriority () {

  }

  Task({
    required String id,
    required String title,
    String? description, // Make optional in constructor
    required DateTime dueDate,
    required String category,
    required Recurrence recurrence, // Add this line
    required this.priority,
    required Status currentStatus,
    required ItemType itemType

  }) : itemType = ItemType.task, currentStatus = Status.notStarted, super(
    id: id,
    title: title,
    description: description,
    dueDate: dueDate,
    category: category,
    recurrence: recurrence,
    itemType: itemType,
  );

  //FIREBASE TASK INFO
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description ?? "", // Firestore doesn't support null for all field types
      'dueDate': Timestamp.fromDate(dueDate),
      'category': category,
      'priority': priority.toString(),
      'currentStatus': currentStatus.toString(),
      'recurrence': {
        'type': recurrence.type.toString(),
        'interval': recurrence.interval,
        'endDate': recurrence.endDate != null ? Timestamp.fromDate(recurrence.endDate!) : null,
      },
    };
  }
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      category: map['category'],
      recurrence: Recurrence.fromMap(map['recurrence']),
      priority: PriorityLevel.values.firstWhere((e) => e.toString() == map['priority']),
      currentStatus: Status.values.firstWhere((e) => e.toString() == map['currentStatus']),
      itemType: ItemType.task,
      // Add other fields as necessary
    );
  }
}

CalendarEventData<Task> taskToCalendarEventData(Task task) {
  Map<String, Color> predefinedCategories = getPredefinedCategories();
  Color categoryColor = predefinedCategories[task.category] ?? Colors.blue; // Fallback to blue if not matched

  return CalendarEventData<Task>(
    date: task.dueDate,
    endDate: task.dueDate,
    title: task.title,
    description: task.description,
    color: categoryColor, // Assign the category color
    event: task,
  );
}


/// ********************************** EVENT CLASS *****************************************
class Event extends ScheduleItem {
  DateTime startTime;
  DateTime endTime;
  String? location;
  @override
  ItemType itemType;
  @override
  ItemType getItemType() => ItemType.event;

  Event({
    required String id,
    required String title,
    String? description, // Make optional in constructor
    required DateTime dueDate,
    required this.startTime,
    required this.endTime,
    required String category,
    required Recurrence recurrence, // Add this line
    this.location,
    required ItemType itemType,

  }) : itemType = ItemType.event, super(
    id: id,
    title: title,
    description: description,
    dueDate: dueDate,
    category: category,
    recurrence: recurrence, // Pass recurrence to superclass
    itemType: ItemType.event,
  );

  // FIREBASE EVENT INFO
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description ?? "",
      'dueDate': dueDate,
      'startTime':Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'category': category,
      'location': location ?? "",
      'recurrence': {
        'type': recurrence.type.toString(),
        'interval': recurrence.interval,
        'endDate': recurrence.endDate != null ? Timestamp.fromDate(recurrence.endDate!) : null,
      },
    };
  }

// Add this method to create an Event instance from a map
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      category: map['category'],
      recurrence: Recurrence.fromMap(map['recurrence']),
      itemType: ItemType.event,
      // Add other fields as necessary
    );
  }
}

CalendarEventData<Event> eventToCalendarEventData(Event event) {
  Map<String, Color> predefinedCategories = getPredefinedCategories();
  Color categoryColor = predefinedCategories[event.category] ?? Colors.blue; // Fallback to blue if not matched

  return CalendarEventData<Event>(
    date: event.startTime,
    endDate: event.endTime,
    title: event.title,
    description: event.description,
    color: categoryColor, // Assign the category color
    event: event,
  );
}



/// ****************************** REMINDER CLASS *******************************
class Reminder {
  String id; // New field for the reminder ID
  ScheduleItem item;
  DateTime reminderTime;
  String message;

  Reminder({
    required this.id, // Include id parameter in the constructor
    required this.item,
    required this.reminderTime,
    String? message,
  }) : message = message ?? _defaultMessageForItem(item, reminderTime);

  // Updated helper method to format event date and time
  static String _defaultMessageForItem(ScheduleItem item, DateTime reminderTime) {
    if (item is Task) {
      final daysLeft = item.dueDate.difference(DateTime.now()).inDays;
      return "Task reminder: ${item.title} - $daysLeft days left until due";
    } else if (item is Event) {
      final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
      final eventDateTime = dateFormat.format(item.dueDate);
      return "Event reminder: ${item.title} on $eventDateTime";
    } else {
      return "Reminder: ${item.title}";
    }
  }

  void notifyUser() {
    print("Reminder: $message at ${reminderTime.toString()}");
  }

  // FIREBASE
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reminderTime': Timestamp.fromDate(reminderTime),
      'message': message,
    };
  }
}


/// ************************ CALENDAR CLASS ***********************************

class Calendar {
  Map<String, ScheduleItem> scheduleItemsById = {};
  Map<String, List<Reminder>> remindersByItemId = {};
  String? userId;
  String? calendarId;

  Calendar._privateConstructor();

  static Future<Calendar> create() async {
    var calendar = Calendar._privateConstructor();
    await calendar._initialize();
    return calendar;
  }

  Future<void> _initialize() async {
    try {
      Map<String, String?> ids = await CalendarUtils.getCurrentUserIdAndCalendarId();
      userId = ids['userId'];
      calendarId = ids['calendarId'];
    } catch (e) {
      print("Error initializing calendar with user and calendar ID: $e");
    }
  }

  // Update an existing task in the calendar and Firebase
  Future<void> updateTask(Task updatedTask) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('calendar')
          .doc(calendarId)
          .collection('tasks')
          .doc(updatedTask.id)
          .set(updatedTask.toMap());

      scheduleItemsById[updatedTask.id] = updatedTask;
      print("Task updated successfully in Firestore");
    } catch (e) {
      print("Error updating task in Firestore: $e");
      throw e;
    }
  }

// Update an existing event in the calendar and Firebase
  Future<void> updateEvent(Event updatedEvent) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('calendar')
          .doc(calendarId)
          .collection('events')
          .doc(updatedEvent.id)
          .set(updatedEvent.toMap());

      scheduleItemsById[updatedEvent.id] = updatedEvent;
      print("Event updated successfully in Firestore");
    } catch (e) {
      print("Error updating event in Firestore: $e");
      throw e;
    }
  }

  // Add event or task to calendar list and firebase
  void addScheduleItem(ScheduleItem item, String userId, String calendarId) {
    try {
      scheduleItemsById[item.id] = item;

      if (item is Task) {
        addTaskToFirebase(item, userId, calendarId);
      } else if (item is Event) {
        addEventToFirebase(item, userId, calendarId);
      }
    } catch (e) {
      print("Error adding schedule item: $e");
    }
  }
  //Add reminder to calendar class reminder list and firebase
  void addReminderToItem(String itemId, Reminder reminder) {
    try {
      remindersByItemId.putIfAbsent(itemId, () => []).add(reminder);

      var item = scheduleItemsById[itemId];
      if (item != null) {
        if (item is Task) {
          addReminderToFirebase(userId!, calendarId!, itemId, "Task", reminder);
        } else if (item is Event) {
          addReminderToFirebase(userId!, calendarId!, itemId, "Event", reminder);
        }
      }
    } catch (e) {
      print("Error adding reminder to item: $e");
    }
  }


  // If user wants to delete scheduled item, it will delete scheduled item and any other associations it has like its reminders
  //Also deletes information from firebase as well
  Future<void> deleteScheduledItemAndReminders(String itemId, String itemType) async {
    try {
      // Delete the scheduled item from its respective collection (tasks or events) in Firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('calendar')
          .doc(calendarId)
          .collection(itemType.toLowerCase() + 's') // 'tasks' or 'events'
          .doc(itemId)
          .delete();

      // Query and delete all reminders associated with this item in Firebase
      var remindersQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('calendar')
          .doc(calendarId)
          .collection('reminders')
          .where('itemId', isEqualTo: itemId)
          .get();

      for (var doc in remindersQuerySnapshot.docs) {
        await doc.reference.delete();
      }

      // Remove the scheduled item from the in-memory list
      scheduleItemsById.remove(itemId);

      // Remove all associated reminders from the in-memory list
      remindersByItemId.remove(itemId);

      print("Scheduled item and all associated reminders deleted successfully from Firebase and local lists.");
    } catch (e) {
      print("Error deleting scheduled item and reminders: $e");
      throw e; // Consider handling this more gracefully in your application
    }
  }

// deleting just a reminder (needs reminderID)
  Future<void> deleteReminder(String itemId, String reminderId) async {
    try {
      // Delete the reminder from Firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('calendar')
          .doc(calendarId)
          .collection('reminders')
          .doc(reminderId) // Use the reminder's unique ID
          .delete();

      // Remove the reminder from the in-memory list
      // Check if the list of reminders for the item exists and contains the reminder
      if (remindersByItemId.containsKey(itemId)) {
        // Assuming reminders have a unique 'id' property for identification
        remindersByItemId[itemId]?.removeWhere((reminder) => reminder.id == reminderId);
        // Optionally, if there are no more reminders for the item, you might remove the item's entry
        if (remindersByItemId[itemId]?.isEmpty ?? false) {
          remindersByItemId.remove(itemId);
        }
      }

      print("Reminder deleted successfully from Firebase and local list.");
    } catch (e) {
      print("Error deleting reminder: $e");
      throw e;
    }
  }

  List<Reminder>? getRemindersForItem(String itemId) {
    try {
      return remindersByItemId[itemId];
    } catch (e) {
      print("Error retrieving reminders for item: $e");
      return null;
    }
  }
  /************* Firebase Functions ****************/
  // Add Task to Firebase

  Future<void> addTaskToFirebase(Task task, String userId, String calendarId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('calendar')
          .doc(calendarId)
          .collection('tasks')
          .add(task.toMap());
      print("Task added successfully to Firestore");
    } catch (e) {
      print("Error adding task to Firestore: $e");
      throw e;
    }
  }

// Add Reminder to Firebase
  Future<void> addReminderToFirebase( String userId,String calendarId,String itemId,
      String itemType,Reminder reminder,
      ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('calendar')
          .doc(calendarId)
          .collection('reminders')
          .add({
        ...reminder.toMap(),
        'itemId': itemId,
        'itemType': itemType,
      });
    } catch (e) {
      print("Error adding reminder to Firestore: $e");
      throw e;
    }
  }

// Add Event to Firebase
  Future<void> addEventToFirebase(
      Event event, String userId,String calendarId
      ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('calendar')
          .doc(calendarId)
          .collection('events')
          .add(event.toMap());
      print("Successfully Added EventID");
    } catch (e) {
      print("Error adding event to Firestore: $e");
      throw e;
    }
  }

  Future<void> fetchEventsAndTasks(Calendar calendar, DateTime startDate, DateTime endDate) async {
    final userId = calendar.userId;
    final calendarId = calendar.calendarId;

    if (userId == null || calendarId == null) {
      return;
    }

    print('Before fetching: ${calendar.scheduleItemsById.length}'); // Modify this line

    final eventsQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('calendar')
        .doc(calendarId)
        .collection('events')
        .get();

    final tasksQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('calendar')
        .doc(calendarId)
        .collection('tasks')
        .get();

    // Convert the query snapshots to Event and Task objects and store them in the calendar
    for (var doc in eventsQuerySnapshot.docs) {
      final event = Event.fromMap(doc.data());
      calendar.scheduleItemsById[event.id] = event;
    }

    for (var doc in tasksQuerySnapshot.docs) {
      final task = Task.fromMap(doc.data());
      calendar.scheduleItemsById[task.id] = task;
    }

    print('After fetching: ${calendar.scheduleItemsById.length}'); // Modify this line
  }

}

/// ************************ CALENDAR UTILS CLASS **********************************/

class CalendarUtils {
  static Future<Map<String, String>> getCurrentUserIdAndCalendarId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user signed in");
    }
    final userId = user.uid;

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = userDoc.data();
    if (data == null) {
      throw Exception("No data found for the user");
    }

    // Explicitly cast data to Map<String, dynamic> to avoid type errors
    final Map<String, dynamic> userData = data as Map<String, dynamic>;

    // Extract calendarId from user document data
    String? calendarId = userData['defaultCalendarId'];
    if (calendarId == null) {
      throw Exception("No calendarId found for user");
    }

    return {'userId': userId, 'calendarId': calendarId};
  }
}


// Calendar Firebase
//Jessica Calendar
String generateCalendarId() {
  var rng = Random();
  return 'cal_${List.generate(10, (_) => rng.nextInt(9).toString()).join()}';
}

Future<void> createUserCalendar(String userId) async {
  // Create a new calendar ID
  String calendarId = userId; // Using the user's ID as the calendar ID for simplicity

  // Create a calendar document with the user's ID as the calendar ID
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('calendar')
      .doc(calendarId)
      .set({'name': 'My Calendar', /* other calendar properties */});

  // Store the calendarId in the user's document for easy access
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .set({'defaultCalendarId': calendarId}, SetOptions(merge: true));
}

