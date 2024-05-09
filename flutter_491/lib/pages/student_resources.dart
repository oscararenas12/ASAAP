import 'package:flutter/material.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentResourcePage extends StatelessWidget {
  const StudentResourcePage({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false); // Opening the URL in the default browser
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkblue, // Use your AppColors for the app bar background
        title: Text('Student Resources', style: AppText.header1), // Use your AppText for the app bar title
      ),
      body: Container(
        color: AppColors.background, // Use your AppColors for the background
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Resource 1 - Chegg',
                style: AppText.header2.copyWith(color: Colors.white), // Override the color property
              ),
              onTap: () => _launchURL('https://www.chegg.com/'),
            ),
            Divider(color: AppColors.darkblue, height: 1),
            ListTile(
              title: Text('Resource 2 - ChatGPT',
                style: AppText.header2.copyWith(color: Colors.white), // Override the color property
              ),
              onTap: () => _launchURL('https://chat.openai.com/'),
            ),
            Divider(color: AppColors.darkblue, height: 1),
            ListTile(
              title: Text('Resource 3 - Khan Academy',
                style: AppText.header2.copyWith(color: Colors.white), // Override the color property
              ),
              onTap: () => _launchURL('https://www.khanacademy.org/'),
            ),
            Divider(color: AppColors.darkblue, height: 1),
            ListTile(
              title: Text('Resource 4 - Quizlet',
                style: AppText.header2.copyWith(color: Colors.white), // Override the color property
              ),
              onTap: () => _launchURL('https://quizlet.com/'),
            ),
            Divider(color: AppColors.darkblue, height: 1),
            ListTile(
              title: Text('Resource 5 - Evernote',
                style: AppText.header2.copyWith(color: Colors.white), // Override the color property
              ),
              onTap: () => _launchURL('https://evernote.com/'),
            ),
            Divider(color: AppColors.darkblue, height: 1),
            ListTile(
              title: Text('Resource 6 - Draw.io',
                style: AppText.header2.copyWith(color: Colors.white), // Override the color property
              ),
              onTap: () => _launchURL('https://www.drawio.com/'),
            ),
            Divider(color: AppColors.darkblue,  height: 1),
            ListTile(
              title: Text('Resource 7 - PhotoMath',
                style: AppText.header2.copyWith(color: Colors.white), // Override the color property
              ),
              onTap: () => _launchURL('https://www.photomath.com/'),
            ),
            Divider(color: AppColors.darkblue,  height: 1),
            ListTile(
              title: Text('Resource 8 - MathWay',
                style: AppText.header2.copyWith(color: Colors.white), // Override the color property
              ),
              onTap: () => _launchURL('https://www.mathway.com/'),
            ),
            Divider(color: AppColors.darkblue,  height: 1),
            ListTile(
              title: Text('Resource 9 - Desmos',
                style: AppText.header2.copyWith(color: Colors.white), // Override the color property
              ),
              onTap: () => _launchURL('https://www.desmos.com/'),
            ),
            Divider(color: AppColors.darkblue,  height: 1),
            ListTile(
              title: Text('Resource 10 - Linkedin Learning',
                style: AppText.header2.copyWith(color: Colors.white), // Override the color property
              ),
              onTap: () => _launchURL('https://learning.linkedin.com/'),
            ),
            Divider(color: AppColors.darkblue,  height: 1),
            ListTile(
              title: Text('Resource 11 - Stack Overflow',
                style: AppText.header2.copyWith(color: Colors.white), // Override the color property
              ),
              onTap: () => _launchURL('https://stackoverflow.com/'),
            ),
            Divider(color: AppColors.darkblue,  height: 1),
            ListTile(
              title: Text('Resource 12 - W3 Schools',
                style: AppText.header2.copyWith(color: Colors.white), // Override the color property
              ),
              onTap: () => _launchURL('https://www.w3schools.com/'),
            ),
          ],
        ),
      ),
    );
  }
}
