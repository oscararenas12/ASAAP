import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_491/components/user_avatar.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:flutter_491/config/user_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

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

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: Toolbar(title: 'Profile'),
    body: FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(UserData.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No data available'));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        _firstName = data['firstName'] ?? '';
        _lastName = data['lastName'] ?? '';
        _bio = data['bio'] ?? '';

        return ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(height: 25),
            FluttermojiCircleAvatar(
              backgroundColor: Colors.blueGrey[100],
              radius: 100,
            ),
            SizedBox(height: 15),
            Text('$_firstName $_lastName', style: AppText.header1, textAlign: TextAlign.center),
            Text('$_bio', style: AppText.header2, textAlign: TextAlign.center),
            SizedBox(height: 20),
            Divider(
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
            
            child: Text('Edit Profile')),
        
        
            Divider(
              color: AppColors.darkblue,
              thickness: 1,
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
            
            child: Text('Customize AI')),
        
            Divider(
              color: AppColors.darkblue,
              thickness: 1,
              height: 20,
              indent: 30,
              endIndent: 30,),
        
          
            TextButton(onPressed: () {
              print('saved clicked');
            }, 
            style: TextButton.styleFrom(
              textStyle: AppText.header2,
              foregroundColor: Colors.white,
            ),
            
            child: Text('Saved')),
        
            Divider(
              color: AppColors.darkblue,
              thickness: 1,
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

                child: Text('Notifications')),

            Divider(
              color: AppColors.darkblue,
              thickness: 1,
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
            
            child: Text('Settings')),
        
            Divider(
              color: AppColors.darkblue,
              thickness: 1,
              height: 20,
              indent: 30,
              endIndent: 30,),
        
          
            TextButton(onPressed: () {
              print('Tutorial clicked');
            }, 
            style: TextButton.styleFrom(
              textStyle: AppText.header2,
              foregroundColor: Colors.white,
            ),
            
            child: Text('Tutorial')),

            Divider(
              color: AppColors.darkblue,
              thickness: 1,
              height: 20,
              indent: 30,
              endIndent: 30,),
            
            TextButton(onPressed: _logout, 
            style: TextButton.styleFrom(
              textStyle: AppText.header2,
              foregroundColor: Colors.white,
            ),
            
            child: Text('Log out')),






               ],
        );
      },
    ),
  );
}
    //return Scaffold(
    //  
    //  body: SingleChildScrollView(
    //    child: Column(
    //    
    //      children: [
    //        
    //        SizedBox(
    //          height: 24,
    //        ),
    //        //UserAvatar from user_avatar.dart
    //      UserAvatar(
    //        size: 200,
    //        ),
    //    
    //        SizedBox(
    //          height: 24,
    //        ),
    //        Text('Erick Garcia', style: AppText.header1,),
    //        Text('Student Bio', style: AppText.header2,),
    //    
    //        SizedBox(
    //          height: 12,
    //        ),
//
    //    
    //      //
    //        Divider(
    //          color: AppColors.darkblue,
    //          thickness: 2,
    //          height: 20,
    //          indent: 30,
    //          endIndent: 30,),
    //    
    //      
    //        TextButton(onPressed: () {
    //          //navigates to edit profile page from edit_profile_page.dart
    //          Navigator.of(context).pushNamed(AppRoutes.edit_profile);
    //          print('Edit clicked');
    //        }, 
    //        style: TextButton.styleFrom(
    //          textStyle: AppText.header2,
    //          foregroundColor: Colors.white,
    //        ),
    //        
    //        child: Text('Edit Profile')),
    //    
    //    
    //        Divider(
    //          color: AppColors.darkblue,
    //          thickness: 1,
    //          height: 20,
    //          indent: 30,
    //          endIndent: 30,),
    //    
    //      
    //        TextButton(onPressed: () {
    //          Navigator.of(context).pushNamed(AppRoutes.customize_AI);
    //          print('customize AI clicked');
    //        }, 
    //        style: TextButton.styleFrom(
    //          textStyle: AppText.header2,
    //          foregroundColor: Colors.white,
    //        ),
    //        
    //        child: Text('Customize AI')),
    //    
    //        Divider(
    //          color: AppColors.darkblue,
    //          thickness: 1,
    //          height: 20,
    //          indent: 30,
    //          endIndent: 30,),
    //    
    //      
    //        TextButton(onPressed: () {
    //          print('saved clicked');
    //        }, 
    //        style: TextButton.styleFrom(
    //          textStyle: AppText.header2,
    //          foregroundColor: Colors.white,
    //        ),
    //        
    //        child: Text('Saved')),
    //    
    //        Divider(
    //          color: AppColors.darkblue,
    //          thickness: 1,
    //          height: 20,
    //          indent: 30,
    //          endIndent: 30,),
    //          
    //          TextButton(onPressed: () {
    //          Navigator.of(context).pushNamed(AppRoutes.notifications_page);
    //        },
    //            style: TextButton.styleFrom(
    //              textStyle: AppText.header2,
    //              foregroundColor: Colors.white,
    //            ),
//
    //            child: Text('Notifications')),
//
    //        Divider(
    //          color: AppColors.darkblue,
    //          thickness: 1,
    //          height: 20,
    //          indent: 30,
    //          endIndent: 30,),
    //    
    //      
    //        TextButton(onPressed: () {
    //          Navigator.of(context).pushNamed(AppRoutes.Settings);
    //          print('settings clicked');
    //        }, 
    //        style: TextButton.styleFrom(
    //          textStyle: AppText.header2,
    //          foregroundColor: Colors.white,
    //        ),
    //        
    //        child: Text('Settings')),
    //    
    //        Divider(
    //          color: AppColors.darkblue,
    //          thickness: 1,
    //          height: 20,
    //          indent: 30,
    //          endIndent: 30,),
    //    
    //      
    //        TextButton(onPressed: () {
    //          print('Tutorial clicked');
    //        }, 
    //        style: TextButton.styleFrom(
    //          textStyle: AppText.header2,
    //          foregroundColor: Colors.white,
    //        ),
    //        
    //        child: Text('Tutorial')),
//
    //        Divider(
    //          color: AppColors.darkblue,
    //          thickness: 1,
    //          height: 20,
    //          indent: 30,
    //          endIndent: 30,),
//
    //        TextButton(onPressed: () {
    //          Navigator.of(context).pushNamed(AppRoutes.login);
    //          print('Logout clicked');
    //        }, 
    //        style: TextButton.styleFrom(
    //          textStyle: AppText.header2,
    //          foregroundColor: Colors.white,
    //        ),
    //        
    //        child: Text('Log out')),        
    //    
    //    
    //      ],
    //    ),
    //  ),
    //);
  }

