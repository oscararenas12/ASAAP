import 'package:flutter/material.dart';
import 'package:flutter_491/components/app_textfield.dart';
import 'package:flutter_491/components/post_item.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:flutter_491/components/user_avatar.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/config/user_data.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

    @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Placeholder values for AI customization
  String _firstName = 'First Name';
  String _lastName = 'Last Name';
  String _bio = 'Edit your BIO';

  // Placeholder image for AI appearance
  String _aiAppearanceImage = 'assets/images/AIpic.png';

 Future<void> _loadUserDetails() async {
    Map<String, String> userDetails = await UserData.getUserDetails(); // Call getUserDetails from UserData
    String firstName = userDetails['firstName'] ?? '';
    String lastName = userDetails['lastName'] ?? '';

    setState(() {
      _firstName = userDetails['firstName'] ?? '';
      _lastName = userDetails['lastName'] ?? '';
    });

 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkblue,
        title: Text(
          'Edit Profile',
          style: AppText.header1,
        ),
      ),
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
                        size: 28,color: const Color.fromARGB(255, 255, 255, 255),),
                      ),
                    ),
                  ),
                
                ],
              ),


        
              SizedBox(
                height: 40,
              ),
        
              TextField(
              onChanged: (value) {
                setState(() {
                  _firstName= value;
                });
              },
              decoration: InputDecoration(
                hintText: _firstName,
                filled: true,
                fillColor: AppColors.darkblue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
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

