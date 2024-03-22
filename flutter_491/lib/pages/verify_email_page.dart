import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'dart:async';

import 'package:flutter_491/pages/main_page.dart';

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
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Initiate the email verification check
    checkEmailVerification();
  }

  Future<void> checkEmailVerification() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser; // Re-fetch the user

    if (user != null && !user.emailVerified) {
      await sendVerificationEmail();
      // Start a periodic timer to check for verification
      timer = Timer.periodic(Duration(seconds: 3), (timer) async {
        await checkEmailVerified();
      });
    } else {
      setState(() {
        isEmailVerified = true;
        updateEmailVerifiedStatus(user!.uid);
      });
    }
  }

  Future<void> checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;
    
    if (user != null && user.emailVerified) {
      setState(() async {
        isEmailVerified = true;
        await updateEmailVerifiedStatus(user!.uid);
      });
      timer?.cancel(); // Stop the timer if the email is verified
    }
  }

  Future<void> sendVerificationEmail() async {
     User? user = FirebaseAuth.instance.currentUser;
    try {
      await user?.sendEmailVerification();
    } catch (e) {
      // Handle error
      print('Error sending verification email: $e');
    }
  }

  @override
  void dispose() {
    timer?.cancel(); // Ensure the timer is canceled to avoid memory leaks
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: isEmailVerified
          ? MainPage() // Redirect to HomePage if verified
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Please check your email for the verification link.'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await checkEmailVerification(); // Re-check email verification
                  },
                  child: Text('Refresh'),
                ),
                SizedBox(height: 20), // Add some spacing
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to the login page
                    Navigator.of(context).pushNamed(AppRoutes.login);
                  },
                  child: Text('Back to Login'),
                ),
              ],
            ),
    ),
  );
}

}

