import 'package:flutter/material.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomizeAIPage extends StatefulWidget {
  const CustomizeAIPage({Key? key}) : super(key: key);

  @override
  _CustomizeAIPageState createState() => _CustomizeAIPageState();
}

class _CustomizeAIPageState extends State<CustomizeAIPage> {
  String _aiName = 'Roexy'; // Default AI name
  String _aiVoice = 'Default Voice';
  int _humorLevel = 5;
  String _aiAppearanceImage = 'assets/images/AIpic.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize AI'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(_aiAppearanceImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height / 6,
                  ),
                  child: Image.asset(_aiAppearanceImage, fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: 16),

            // AI's Name Section
            Text(
              'AI\'s Name',
              style: Theme.of(context).textTheme.headline6,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  _aiName = value;
                });
              },
              decoration: InputDecoration(
                hintText: _aiName, // Set the initial value to the AI's name
                filled: true,
                fillColor: AppColors.darkblue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16),

            // AI's Voice Section
            Text(
              'AI\'s Voice',
              style: Theme.of(context).textTheme.headline6,
            ),
            DropdownButtonFormField<String>(
              value: _aiVoice,
              onChanged: (value) {
                setState(() {
                  _aiVoice = value!;
                });
              },
              items: <String>[
                'Default Voice',
                'Voice 1',
                'Voice 2',
                'Voice 3',
                // Add more voice options as needed
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // Humor Level Section
            Text(
              'Humor Level',
              style: Theme.of(context).textTheme.headline6,
            ),
            Slider(
              value: _humorLevel.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _humorLevel = value.toInt();
                });
              },
            ),
            SizedBox(height: 16),

            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _resetToDefault,
                  child: Text('Reset To Default'),
                ),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _resetToDefault() {
    setState(() {
      _aiName = 'Roexy';
      _aiVoice = 'Default Voice';
      _humorLevel = 5;
      // Reset AI appearance image if needed
    });
    _saveChanges(); // Save changes when resetting to default
  }

  void _saveChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('aiName', _aiName);
    prefs.setString('aiVoice', _aiVoice);
    prefs.setInt('humorLevel', _humorLevel);
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _aiName = prefs.getString('aiName') ?? 'Roexy';
      _aiVoice = prefs.getString('aiVoice') ?? 'Default Voice';
      _humorLevel = prefs.getInt('humorLevel') ?? 5;
    });
  }
}
