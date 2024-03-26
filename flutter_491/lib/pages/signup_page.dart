// signup_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'calendar_backend.dart';

Future<void> sendVerificationEmail(BuildContext context) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null && !user.emailVerified) {
    try {
      await user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification email sent. Please check your inbox.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send verification email. Try again later.'),
        ),
      );
      print(e); // For debugging purposes
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Email is already verified or user is not logged in.'),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _createAccount() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save additional user information to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'bio': _bioController.text.trim(),
        'emailVerified': false,
        // Add other fields as needed
      });

      print("Account created: ${userCredential.user!.email}");

      //Send Verification Email
      await sendVerificationEmail(context);
      // Create a calendar for the user
      try {
        await createUserCalendar(userCredential.user!.uid);
        print("CalendarID created");
      } catch (e) {
        print("Failed to create user calendar: $e");
        // Handle calendar creation failure
      }

      Navigator.of(context).pushNamed(AppRoutes.login);
    } on FirebaseAuthException catch (e) {
      print("Failed to create account: ${e.message}");
      // Handle errors based on the FirebaseAuthException code.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkblue,
        title: Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white, // Set text color to white
            fontWeight: FontWeight.bold, // Set text bold
          ),
        ),
        // Add a back button to the AppBar
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white, // Set icon color to white
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(
                AppRoutes.login); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                prefixIcon: Icon(Icons.person),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                prefixIcon: Icon(Icons.person),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.black,
                  ),
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _createAccount,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.darkblue, // Set text color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Set button border radius
                ),
              ),
              child: Text(
                'Create Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Set text bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
