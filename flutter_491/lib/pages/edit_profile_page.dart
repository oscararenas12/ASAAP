import 'package:flutter/material.dart';
import 'package:flutter_491/components/app_textfield.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:flutter_491/components/user_avatar.dart';
import 'package:flutter_491/styles/app_colors.dart';

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
        
                  //edit use avatar
                  //makes edit icon stand out
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UserAvatar(
                      size:150,
                    ),
                  ),
        
                  //edit icon
                  Positioned(
                    bottom: 1, 
                    right: 0, 
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.darkblue,
                        borderRadius: BorderRadius.all(Radius.circular(6))
                        ),
                      child: Icon(Icons.edit,
                      size: 20,
                      ))
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

