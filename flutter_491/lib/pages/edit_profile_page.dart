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
import 'package:flutter_491/config/user_data.dart';

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
    MaterialPageRoute(builder: (context) => ProfilePage()),
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

void _deleteAccount() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Delete your Account?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'If you select Delete, we will delete your account on our server. Your app data will also be deleted and you won\'t be able to retrieve it.',
            ),
            SizedBox(height: 20),
            Text(
              'Since this is a security-sensitive operation, you will be asked to login again before your account can be deleted.',
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            onPressed: () {
              // Call the delete account function
              _deleteUserAccount();
            },
          ),
        ],
      );
    },
  );
}

Future<void> _deleteUserAccount() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Delete user's document from Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
      
      // Delete user account
      await user.delete();

      // Navigate to the login page
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    } else {
      print('No user is currently signed in');
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == "requires-recent-login") {
      await _reauthenticateAndDelete();
    } else {
      // Handle other Firebase exceptions
      print('Firebase Auth Exception: $e');
    }
  } catch (e) {
    // Handle general exception
    print('Error deleting user account: $e');
  }
}

Future<void> _reauthenticateAndDelete() async {
  try {
    final providerData = FirebaseAuth.instance.currentUser?.providerData.first;

    if (GoogleAuthProvider().providerId == providerData!.providerId) {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithProvider(GoogleAuthProvider());
    } else {
      // Handle other providers if necessary
    }

    await FirebaseAuth.instance.currentUser?.delete();
  } catch (e) {
    // Handle exceptions
    print('Error reauthenticating and deleting user account: $e');
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
                    primary: AppColors.darkblue,
                    onPrimary: Colors.white,
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
                  primary: AppColors.darkblue,
                  onPrimary: Colors.white,
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
                  _deleteAccount();
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