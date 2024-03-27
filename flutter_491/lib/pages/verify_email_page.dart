import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'dart:async';

//updates databases to reflect that the email has been verified
Future<void> updateEmailVerifiedStatus(String userId) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'emailVerified': true});
    print("User email verified status updated successfully.");
  } catch (e) {
    print("Error updating user email verified status: $e");
  }
}

//verify email page class contains functions that facilitate fi
class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
    bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    // Call the sendVerificationEmail function immediately
    sendVerificationEmail();
    // Initiate the email verification check
    checkEmailVerification();
  }

Future<void> checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      isEmailVerified = true;
      updateEmailVerifiedStatus(user.uid).then((_) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.main);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your email has been verified! Welcome!')),
        );
      });
    }
  }
  

  Future<void> sendVerificationEmail() async {
     User? user = FirebaseAuth.instance.currentUser;
    try {
      await user?.sendEmailVerification();
      print("Email verification sent");
    } catch (e) {
      // Handle error
      print('Error sending verification email: $e');
    }
  }


 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: LayoutBuilder( // Use LayoutBuilder to get the parent container size
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(150),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight, // Minimum height to take full screen height
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center the children horizontally
              children: <Widget>[
                Image.asset(
                  'assets/images/image 6.png',
                  height: 200,
                  width: 200,
                ),
                SizedBox(height: 40),
                Text(
                  'Please check your email for the verification link.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    // Re-check email verification
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  ),
                  child: Text('Send Email Again'),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.login);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  ),
                  child: Text('Return to Login Page'),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

}
