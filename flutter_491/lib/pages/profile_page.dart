import 'package:flutter/material.dart';
import 'package:flutter_491/components/user_avatar.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
        
          children: [
            
            SizedBox(
              height: 24,
            ),
            //UserAvatar from user_avatar.dart
          UserAvatar(
            size: 200,
            ),
        
            SizedBox(
              height: 24,
            ),
            Text('Erick Garcia', style: AppText.header1,),
            Text('Student Bio', style: AppText.header2,),
        
            SizedBox(
              height: 12,
            ),

        
          //
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

            TextButton(onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.login);
              print('Logout clicked');
            }, 
            style: TextButton.styleFrom(
              textStyle: AppText.header2,
              foregroundColor: Colors.white,
            ),
            
            child: Text('Log out')),        
        
        
          ],
        ),
      ),
    );
  }
}