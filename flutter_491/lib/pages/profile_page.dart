import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_491/components/user_avatar.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/pages/friends_list_page.dart';
import 'package:flutter_491/pages/main_page.dart';
import 'package:flutter_491/pages/tutorial_manager.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:flutter_491/config/user_data.dart';

class ProfilePage extends StatefulWidget {
 // Pass in the function to change the page.
  final Function(int)? changePage;
  
  const ProfilePage({Key? key, this.changePage}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  String _firstName = '';
  String _lastName = '';
  String _bio = '';


  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }
  
  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userData.exists) {
          setState(() {
            _firstName = userData['firstName'] ?? '';
            _lastName = userData['lastName'] ?? '';
            _bio = userData['bio'] ?? '';

            // If 'bio' field doesn't exist, add it with an empty string value
            if (!_bio.isNotEmpty) {
              FirebaseFirestore.instance.collection('users').doc(user.uid).update({'bio': ''});
              _bio = ''; // Update local variable
            }
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false); // Navigate to login and remove all other routes
    } catch (e) {
      print('Error logging out: $e');
    }
  }
    //Tutorial Display
    // List of tutorials
  final List<String> tutorials = [
    "Newsfeed",
    "Map",
    "Homepage",
    "Chatbot",
    "Profile",

    // Add more tutorials here
  ];

 

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: const Toolbar(title: 'Profile'),
    body: FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(UserData.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        
        // Check if 'fluttermoji' field exists, if not, add it with an empty string value
        if (!data.containsKey('fluttermoji')) {
          FirebaseFirestore.instance.collection('users').doc(UserData.uid).update({'fluttermoji': ''});
        }
        final avatarDetails = data['fluttermoji'];
        _firstName = data['firstName'] ?? '';
        _lastName = data['lastName'] ?? '';
        _bio = data['bio'] ?? '';

        return ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(height: 25),
            CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey[200],
                      child: SvgPicture.string(
                        FluttermojiFunctions()
                            .decodeFluttermojifromString(avatarDetails ?? ''),
                            fit: BoxFit.contain, // Ensure the SVG fits within the CircleAvatar
                            height: 160, // Specify the height to match the CircleAvatar size
                            width: 160, // Specify the width to match the CircleAvatar size
                          ),
                    ),
            SizedBox(height: 15),
            Text('$_firstName $_lastName', style: AppText.header1, textAlign: TextAlign.center),
            Text('$_bio', style: AppText.subtitle2, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            const Divider(
              color: AppColors.darkblue,
              thickness: 2,
              height: 20,
              indent: 30,
              endIndent: 30,),
        
          
            TextButton(onPressed: () {
              //navigates to edit profile page from edit_profile_page.dart
              Navigator.of(context).pushNamed(AppRoutes.edit_profile);
              print('Edit clicked');
            }, 
            style: TextButton.styleFrom(
              textStyle: AppText.header2,
              foregroundColor: Colors.white,
            ),
            
            child: const Text('Edit Profile')),
        
              Divider(
              color: AppColors.darkblue,
              thickness: 2,
              height: 20,
              indent: 30,
              endIndent: 30,),
        
            TextButton(onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                        builder: (context) => FriendsListPage(),
                ),
              );
              print('Friends List Clicked');
            }, 
            style: TextButton.styleFrom(
              textStyle: AppText.header2,
              foregroundColor: Colors.white,
            ),
            
            child: Text('Friends')),

            const Divider(
              color: AppColors.darkblue,
              thickness: 2,
              height: 20,
              indent: 30,
              endIndent: 30,),
        
        
            TextButton(onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.customize_AI);
              print('customize AI clicked');
            }, 
            style: TextButton.styleFrom(
              textStyle: AppText.header2,
              foregroundColor: Colors.white,
            ),
            
            child: const Text('Customize AI')),
        
            const Divider(
              color: AppColors.darkblue,
              thickness: 2,
              height: 20,
              indent: 30,
              endIndent: 30,),
              
              TextButton(onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.notifications_page);
            },
                style: TextButton.styleFrom(
                  textStyle: AppText.header2,
                  foregroundColor: Colors.white,
                ),

                child: const Text('Notifications')),

            Divider(
              color: AppColors.darkblue,
              thickness: 2,
              height: 20,
              indent: 30,
              endIndent: 30,),  


            TextButton(onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.Settings);
              print('settings clicked');
            }, 
            style: TextButton.styleFrom(
              textStyle: AppText.header2,
              foregroundColor: Colors.white,
            ),
            
            child: const Text('Settings')),
        
            const Divider(
              color: AppColors.darkblue,
              thickness: 2,
              height: 20,
              indent: 30,
              endIndent: 30,),
          //Jessica's Contribution for App's Tutorial
          // Tutorial button that opens the bottom sheet
            ExpansionTile(
  title: Text(
    'Tutorials',
    style: AppText.header2.copyWith(color: Colors.white),
    textAlign: TextAlign.center,
  ),
  tilePadding: const EdgeInsets.only(left: 25),
  children: <Widget>[
    const Divider(
      color: AppColors.darkblue,
      thickness: 2,
      height: 20,
      indent: 30,
      endIndent: 30,
    ),
    ...[
      {'icon': 'assets/svg/Paper.svg', 'text': 'Newsfeed', 'width': 24.0, 'height': 24.0,'function': TutorialManager.showNewsfeedTutorial,  'index': 0},
      {'icon': 'assets/svg/Pin_alt.svg', 'text': 'Map', 'width': 24.0, 'height': 24.0, 'function': TutorialManager.showMapTutorial, 'index': 1},
      {'icon': 'assets/svg/Home.svg', 'text': 'Homepage', 'width': 22.0, 'height': 22.0,'function': TutorialManager.showHomeMainPageTutorial, 'index': 2},
      {'icon': 'assets/svg/Ai Bot.svg', 'text': 'Chatbot', 'width': 30.0, 'height': 30.0,/*'function': TutorialManager.showChatbotTutorial, 'route': '/chat'*/}, // Slightly larger to match other icons
      {'icon': 'assets/svg/User_cicrle.svg', 'text': 'Profile', 'width': 24.0, 'height': 24.0, /*'function': TutorialManager.showProfileTutorial, 'route': '/profile'*/},
    ].map((item) => ListTile(
      onTap: () {
      // First navigate to the appropriate screen.
      if (item['index'] != null) {
      Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MainPage(initialPage: item['index'] as int)),
      ModalRoute.withName('/main')
      );
      }
      if (item['function'] != null) {
        (item['function'] as Function(BuildContext))(context);
  }
},
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
         // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              item['icon'] as String,
              width: item['width'] as double,
              height: item['height'] as double,
            ),
           const SizedBox(width: 20), // Space between the icon and the text
            Expanded(
              child: Text(
                item['text'] as String,
                style: AppText.subtitle1.copyWith(color: Colors.white),
              ),
            ),
            // ... other widgets ...
          ],
        ),
      ),
    )).toList(),
  ],
),



            const Divider(
              color: AppColors.darkblue,
              thickness: 2,
              height: 20,
              indent: 30,
              endIndent: 30,),


            
            TextButton(onPressed: _logout, 
            style: TextButton.styleFrom(
              textStyle: AppText.header2,
              foregroundColor: Colors.white,
            ),
            
            child: const Text('Log out')),

            
            const Divider(
              color: AppColors.darkblue,
              thickness: 2,
              height: 20,
              indent: 30,
              endIndent: 30,),


          ],
        );
      },
    ),
  );
}
}


