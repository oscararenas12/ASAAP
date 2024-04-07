import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_491/components/user_avatar.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/config/user_data.dart';
import 'package:flutter_491/pages/profile_page.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:flutter_491/pages/change_password_page.dart';
import 'package:flutter_491/pages/main_page.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String _firstName = '';
  String _lastName = '';
  String _bio = '';

  @override
  void initState() {
    super.initState();
    // Fetch user data from Firestore
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userData.exists) {
          setState(() {
            _firstName = userData['firstName'] ?? '';
            _lastName = userData['lastName'] ?? '';
            _bio = userData['bio'] ?? '';

            // If 'bio' field doesn't exist, add it with an empty string value
            if (!_bio.isNotEmpty) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({'bio': ''});
              _bio = ''; // Update local variable
            }
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _saveChanges() async {
    try {
      await UserData.updateUserDetails(_firstName, _lastName, _bio);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes saved successfully')),
      );
    } catch (e) {
      print('Error saving changes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes')),
      );
    }
  }

  void _restartPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  void _changePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
    ).then((success) {
      if (success != null && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
      }
    });
  }

Future<void> showDeleteAccountDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      // Use a Builder widget to get a valid context
      return Builder(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Delete Account',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            content: Text('Are you sure you want to delete your account?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog

                  // Navigate to the login page
                  Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                  // Delete user account
                  await deleteUserAccount();


                },
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> deleteUserAccount() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Reference to the user's document in Firestore
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Delete user's document from Firestore
      await userDocRef.delete();

      // Delete user account
      await user.delete();
      print('User account and associated document have been deleted');
    } else {
      print('No user is currently signed in');
    }
  } catch (e) {
    // Handle exceptions
    print('Error deleting user account: $e');
  }
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      FluttermojiCircleAvatar(
                        backgroundColor: Colors.blueGrey[100],
                        radius: 80,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.darkblue,
                              borderRadius: BorderRadius.circular(20)),
                          child: IconButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserAvatar())),
                            icon: Icon(
                              Icons.edit,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40),
              _buildProfileTextField(
                  label: 'First Name',
                  hintText: _firstName,
                  onChanged: (value) {
                    setState(() {
                      _firstName = value;
                    });
                  }),
              SizedBox(height: 16),
              _buildProfileTextField(
                  label: 'Last Name',
                  hintText: _lastName,
                  onChanged: (value) {
                    setState(() {
                      _lastName = value;
                    });
                  }),
              SizedBox(height: 16),
              _buildProfileTextField(
                  label: 'Bio',
                  hintText: _bio,
                  maxLines: 3,
                  onChanged: (value) {
                    setState(() {
                      _bio = value;
                    });
                  }),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _saveChanges();
                    _restartPage();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.darkblue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text('Save Changes'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _changePassword(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.darkblue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text('Change Password'),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  showDeleteAccountDialog(context);
                },
                child: Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTextField({
    required String label,
    required String hintText,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
