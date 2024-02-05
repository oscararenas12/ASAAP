import 'package:flutter/material.dart';
import 'package:flutter_491/styles/app_colors.dart';

class CustomizeAIPage extends StatefulWidget {
  const CustomizeAIPage({Key? key}) : super(key: key);

  @override
  _CustomizeAIPageState createState() => _CustomizeAIPageState();
}

class _CustomizeAIPageState extends State<CustomizeAIPage> {
  // Placeholder values for AI customization
  String _aiName = 'AI Name';
  String _aiVoice = 'Default Voice';
  int _humorLevel = 5;

  // Placeholder image for AI appearance
  String _aiAppearanceImage = 'assets/images/AIpic.png';

  // Reset AI customization to default values
  void _resetToDefault() {
    setState(() {
      _aiName = 'AI Name';
      _aiVoice = 'Default Voice';
      _humorLevel = 5;
      // Reset AI appearance image if needed
    });
  }

  // Save changes to AI customization
  void _saveChanges() {
    // Implement logic to save changes
    // You may want to save these values to shared preferences or a database
  }

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
            // AI Appearance Section
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
                hintText: 'Enter AI\'s Name',
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
            TextField(
              onChanged: (value) {
                setState(() {
                  _aiVoice = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter AI\'s Voice',
                filled: true,
                fillColor: AppColors.darkblue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
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
}
