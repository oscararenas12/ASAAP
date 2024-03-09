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
  // Show a dialog to confirm account deletion
  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController passwordController = TextEditingController(); // Controller for password input field

      return AlertDialog(
        title: Text("Confirm Account Deletion"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Please enter your password to confirm account deletion:"),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cancel account deletion
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              String password = passwordController.text.trim();
              if (password.isNotEmpty) {
                // Re-authenticate the user
                bool success = await _reauthenticate(password);
                if (success) {
                  // User re-authenticated successfully, proceed with account deletion
                  deleteUserAccount();
                } else {
                  // Re-authentication failed, display an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to re-authenticate. Please try again.')),
                  );
                }
              } else {
                // Display error message if password is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter your password')),
                );
              }
            },
            child: Text("Delete"),
          ),
        ],
      );
    },
  );
}

Future<bool> _reauthenticate(String password) async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // No user is currently signed in
      return false;
    }

    // Prompt the user to re-enter their password for re-authentication
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    // Re-authenticate the user
    await user.reauthenticateWithCredential(credential);

    // Re-authentication succeeded
    return true;
  } catch (e) {
    // Re-authentication failed
    print('Error re-authenticating user: $e');
    return false;
  }
}


Future<void> deleteUserAccount() async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Delete the user's document from Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

      // Delete the user's account from Firebase Authentication
      await user.delete();

      print('User account and data deleted successfully');
    } else {
      print('No user is currently signed in');
    }
  } catch (e) {
    print('Error deleting user account: $e');
    // Handle the error here
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