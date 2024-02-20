import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  static Future<Map<String, String>> getUserDetails() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String? uid = _auth.currentUser?.uid;
    Map<String, String> userDetails = {};

    if (uid != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      userDetails['firstName'] = userSnapshot['firstName'];
      userDetails['lastName'] = userSnapshot['lastName'];
      userDetails['bio'] = userSnapshot['bio'];
    }

    return userDetails;
  }

  static Future<void> updateUserDetails(String firstName, String lastName, String bio) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      String? uid = _auth.currentUser?.uid;

      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'firstName': firstName,
          'lastName': lastName,
          'bio': bio,
        });
      }
    } catch (e) {
      print('Error updating user details: $e');
      throw e; // Rethrow the exception to handle it in the UI if necessary
    }
  }
}