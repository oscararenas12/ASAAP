import 'package:flutter/material.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgendaPage extends StatefulWidget {
  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  List<String> tasks = [];
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = _prefs.getStringList('tasks') ?? [];
    });
  }

  Future<void> _saveTasks() async {
    await _prefs.setStringList('tasks', tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
        backgroundColor: AppColors.darkblue,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return _buildTaskContainer(tasks[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskContainer(String task) {
    Color containerColor = AppColors.darkblue; // You can set different colors based on your preference

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        title: Text(
          task,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Add your notification logic here
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _removeTask(task);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(
              hintText: 'Enter task',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newTask = taskController.text.trim();
                if (newTask.isNotEmpty) {
                  setState(() {
                    tasks.add(newTask);
                    _saveTasks();
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeTask(String task) {
    setState(() {
      tasks.remove(task);
      _saveTasks();
    });
  }
}
