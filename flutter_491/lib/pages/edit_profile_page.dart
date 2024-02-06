import 'package:flutter/material.dart';
import 'package:flutter_491/components/app_textfield.dart';
import 'package:flutter_491/components/post_item.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:flutter_491/components/user_avatar.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(title: 'Edit Profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
        
            children: [
        
              //STACK Allows widets and objects on top of each other
              Stack(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FluttermojiCircleAvatar(
                      backgroundColor: Colors.blueGrey[100],
                      
                      radius: 100,
                    ),

                    
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, right: 50),
                    child: Container(
                      
                      //alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        color: AppColors.darkblue,
                        borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => UserAvatar())),
                        icon: Icon(Icons.edit,
                        size: 28,),
                      ),
                    ),
                  ),
                
                ],
              ),


        
              SizedBox(
                height: 40,
              ),
        
              AppTextField(hint: 'First Name',
              
              ),
        
              SizedBox(
                height: 16,
              ),
        
              AppTextField(hint: 'Last Name'),
              SizedBox(
                height: 16,
              ),
          
              AppTextField(hint: 'Bio'),

              SizedBox(
                height: 30,
              ),

              SizedBox(
                
                child: ElevatedButton(onPressed: () {
                  print('Saved changed clicked');
                
                },
            
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkblue,
                  foregroundColor: Colors.white,
                  
                ),                
            
                child: Text('Save Changes')),
              ),















          
            ],
          ),
        ),
      ),

    );
  }
}

