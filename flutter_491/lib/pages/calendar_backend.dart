import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Dart date formatting
import 'package:cloud_firestore/cloud_firestore.dart';

class Recurrence {
  final RecurrenceType type;
  final int interval;
  final DateTime? endDate;

  Recurrence({required this.type, this.interval = 1, this.endDate});
}

/// *********************** SCHEDULED ITEM ABSTRACT CLASS *************************
abstract class ScheduleItem {
  String id;
  String title;
  String? description; // '?' denotes that description is not required
  DateTime dueDate;
  String category;
  Recurrence recurrence;
  String type;

  Type getType();

  
  ScheduleItem({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.category,
    required this.recurrence,
    required this.type
  });
}

enum PriorityLevel { low, medium, high, urgent }
enum Status { notStarted, inProgress, complete }
enum RecurrenceType { none, daily, weekly, monthly }
enum Type{ Event, Task}


class Categories {
  static const String work = 'Work';
  static const String personal = 'Personal';
  static const String shopping = 'Shopping';
  static const String education = 'Education';
  static const String health = 'Health';
  // Add more predefined categories as needed
}

/// **************************** TASK CLASS ***********************************
class Task extends ScheduleItem {
  PriorityLevel priority;
  Status currentStatus;
  Type type;

   @override
  Type getType() => Type.Task; 

  Task({
    required String id,
    required String title,
    String? description, // Make optional in constructor
    required DateTime dueDate,
    required String category,
    required Recurrence recurrence, // Add this line
    required this.priority,
    this.currentStatus = Status.notStarted,
  }) : super(
          id: id,
          title: title,
          description: description,
          dueDate: dueDate,
          category: category,
          recurrence: recurrence, // Pass recurrence to superclass
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
}

/// ********************************** EVENT CLASS *****************************************
class Event extends ScheduleItem {
  DateTime endTime;
  String? location;
  @override
  Type getType() => Type.Event;

  Event({
    required String id,
    required String title,
    String? description, // Make optional in constructor
    required DateTime dueDate,
    required this.endTime,
    required String category,
    required Recurrence recurrence, // Add this line
    this.location,
  }) : super(
          id: id,
          title: title,
          description: description,
          dueDate: dueDate,
          category: category,
          recurrence: recurrence, // Pass recurrence to superclass
        );

  // FIREBASE EVENT INFO
  Map<String, dynamic> toMap() {
  return {
    'id': id,
    'title': title,
    'description': description ?? "",
    'startTime': Timestamp.fromDate(dueDate), 
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
}

/// ****************************** REMINDER CLASS *******************************
class Reminder {
  ScheduleItem item;
  DateTime reminderTime;
  String message;

  Reminder({
    required this.item,
    required this.reminderTime,
    String? message,
  }) : this.message = message ?? _defaultMessageForItem(item, reminderTime);

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
    'reminderTime': Timestamp.fromDate(reminderTime),
    'message': message,
  };
  }
}

/// ************************ CALENDAR CLASS ***********************************

class Calendar {
  
  Map<String, List<ScheduleItem>> scheduleItemsByDate = {};
  Map<String, List<Reminder>> remindersByItemId = {}; // Map item ID to its reminders
  Map<String, String?> ids = await CalendarUtils.getCurrentUserIdAndCalendarId();
    final String? userId = ids['userId'];
    final String? calendarId = ids['calendarId'];

    

  void addScheduleItem(ScheduleItem item, String userId, String calendarId) {
    final dateKey = _dateKey(item.dueDate);
    scheduleItemsByDate.putIfAbsent(dateKey, () => []).add(item);

      // Add Scheduled Items to Firebase Database
      if (item is Task){
        addTaskToFirebase(item,userId,calendarId);
      }
      else if (item is Event){
        addEventToFirebase(item,userId,calendarId);
      }
    }
  

  void addReminderToItem(String itemId, Reminder reminder) {
    try{
      if (!remindersByItemId.containsKey(itemId)) {
        remindersByItemId[itemId] = [];
        remindersByItemId[itemId]?.add(reminder);
        if(reminder.item is Task){
          addReminderToFirebase(userId,calendarId, itemId, Task, reminder);
        }
        else if (reminder.item is Event){
           addReminderToFirebase(userId,calendarId, itemId, Event, reminder);

        }
    }

    }
     catch (e) {
    print("An error occurred: $e");
  }

  }

  List<Reminder>? getRemindersForItem(String itemId) {
    return remindersByItemId[itemId];
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

/// ************************ CALENDAR UTILS CLASS **********************************/

class CalendarUtils {
  static Future<Map<String, String?>> getCurrentUserIdAndCalendarId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user signed in");
    }
    final userId = user.uid;

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final calendarId = userDoc.data()?['calendarId'] as String?;

    if (calendarId == null) {
      throw Exception("No calendarId found for user");
    }

    return {'userId': userId, 'calendarId': calendarId};
  }
}
/// ************************ ADDITIONAL FIREBASE FUNCTIONS ******************************

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
  } catch (e) {
    print("Error adding task to Firestore: $e");
    throw e;
  }
}
// Add Reminder to Firebase
Future<void> addReminderToFirebase({
  required String userId,
  required String calendarId,
  required String itemId,
  required String itemType,
  required Reminder reminder,
}) async {
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
Future<void> addEventToFirebase({
  required Event event,
  required String userId,
  required String calendarId
  }) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('calendar')
        .doc(calendarId)
        .collection('events')
        .add(event.toMap());
  } catch (e) {
    print("Error adding event to Firestore: $e");
    throw e; 
  }
}


