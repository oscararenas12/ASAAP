import 'package:flutter/material.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalPage extends StatefulWidget {
  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  List<String> goals = [];
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      goals = _prefs.getStringList('goals') ?? [];
    });
  }

  Future<void> _saveGoals() async {
    await _prefs.setStringList('goals', goals);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goals'),
        backgroundColor: AppColors.darkblue,
      ),
      body: ListView.builder(
        itemCount: goals.length,
        itemBuilder: (context, index) {
          return _buildGoalContainer(goals[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGoalDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildGoalContainer(String goal) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.amber,
            size: 40.0,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Text(
              goal,
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _showCompletionDialog(goal);
            },
          ),
        ],
      ),
    );
  }

  void _showAddGoalDialog() {
    TextEditingController goalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Goal'),
          content: TextField(
            controller: goalController,
            decoration: InputDecoration(
              hintText: 'Enter goal',
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
                String newGoal = goalController.text.trim();
                if (newGoal.isNotEmpty) {
                  setState(() {
                    goals.add(newGoal);
                    _saveGoals();
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

  void _showCompletionDialog(String goal) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Congratulations on Achieving Your Goal !!!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Not yet'),
                  ),
                  TextButton(
                    onPressed: () {
                      _completeGoal(goal);
                      Navigator.pop(context);
                      _showFireworks();
                    },
                    child: Text('Thank you'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _completeGoal(String goal) {
    setState(() {
      goals.remove(goal);
      _saveGoals();
    });
  }

  void _showFireworks() {
    // Implement fireworks animation or any congratulatory effect
    // This can be achieved using packages like "flame" or custom animation
  }
}
