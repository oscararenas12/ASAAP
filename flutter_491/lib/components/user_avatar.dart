import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:fluttermoji/fluttermojiCustomizer.dart';
import 'package:fluttermoji/fluttermojiSaveWidget.dart';
import 'package:fluttermoji/fluttermojiThemeData.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserAvatar extends StatefulWidget {
  final double size;
  const UserAvatar({Key? key, this.size = 50}) : super(key: key);

  @override
  _UserAvatarState createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });

    // Save image to Firestore and update user document
    if (_imageFile != null) {
      await _updateUserProfileImage(_imageFile!);
    }
  }

Future<void> _updateUserProfileImage(File imageFile) async {
  try {
    // Get current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('profile_images/${user.uid}');
      final UploadTask uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload to complete
      await uploadTask.whenComplete(() {});

      // Get download URL of uploaded image
      final String imageUrl = await storageRef.getDownloadURL();

      // Update user document in Firestore with image URL
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'profileImageUrl': imageUrl,
      });

      print('Profile image updated successfully');
    } else {
      print('No user is currently signed in');
    }
  } catch (e) {
    print('Error updating profile image: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: Toolbar(title: "Customize Your Profile"),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: _imageFile != null
                      ? CircleAvatar(
                          radius: 100,
                          backgroundImage: FileImage(_imageFile!),
                        )
                      : FluttermojiCircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.grey[200],
                        ),
                ),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Change Profile Picture'),
              ),
              SizedBox(
                width: min(600, _width * 0.85),
                child: Row(
                  children: [
                    Text(
                      "Customize:",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Spacer(),
                    FluttermojiSaveWidget(),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                child: FluttermojiCustomizer(
                  scaffoldWidth: min(600, _width * 0.85),
                  autosave: false,
                  theme: FluttermojiThemeData(
                      boxDecoration: BoxDecoration(
                          boxShadow: [BoxShadow(color: Colors.transparent)])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}