import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAvatar extends StatelessWidget {
  final double size;

  const UserAvatar({Key? key, this.size = 50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user != null ? user.uid : ''; // Fetching the user ID from Firebase Auth

    // You can implement the logic to fetch the user's avatar based on the userId
    return CircleAvatar(
      radius: size,
      backgroundImage: NetworkImage('URL_TO_USER_AVATAR/$userId'), // Replace with actual URL
    );
  }
}