abstract class ScheduleItem {
  String id;
  String title;
  String? description; // '?' denotes that description is not required
  DateTime dueDate;
  String category;
  
  ScheduleItem({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.category,
  });
}

enum PriorityLevel { low, medium, high, urgent }

enum RecurrenceType { none, daily, weekly, monthly }

class Recurrence {
  final RecurrenceType type;
  final int interval;
  final DateTime? endDate;

  Recurrence({required this.type, this.interval = 1, this.endDate});
}

class Categories {
  static const String work = 'Work';
  static const String personal = 'Personal';
  static const String shopping = 'Shopping';
  static const String education = 'Education';
  static const String health = 'Health';
  // Add more predefined categories as needed
}

class Task extends ScheduleItem {
  PriorityLevel priority;
  String status;
  Recurrence recurrence;

  Task({
    required String id,
    required String title,
    required String description,
    required DateTime dueDate,
    required String category,
    required this.priority,
    required this.status,
    required this.recurrence,
  }) : super(
          id: id,
          title: title,
          description: description,
          dueDate: dueDate,
          category: category,
        );
}

class Event extends ScheduleItem {
  DateTime endTime;
  String? location;
  Recurrence recurrence;

  Event({
    required String id,
    required String title,
    required String description,
    required DateTime dueDate,
    required this.endTime,
    this.location,
    required String category,
    required this.recurrence,
  }) : super(
          id: id,
          title: title,
          description: description,
          dueDate: dueDate,
          category: category,
        );
}





class Calendar {
  Map<String, List<ScheduleItem>> scheduleItemsByDate = {};
  Map<String, List<Reminder>> remindersByItemId = {}; // Map item ID to its reminders

  void addScheduleItem(ScheduleItem item) {
    final dateKey = _dateKey(item.dueDate);
    scheduleItemsByDate.putIfAbsent(dateKey, () => []).add(item);
  }

  void addReminderToItem(String itemId, Reminder reminder) {
    if (!remindersByItemId.containsKey(itemId)) {
      remindersByItemId[itemId] = [];
    }
    remindersByItemId[itemId]?.add(reminder);
  }

  List<Reminder>? getRemindersForItem(String itemId) {
    return remindersByItemId[itemId];
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
