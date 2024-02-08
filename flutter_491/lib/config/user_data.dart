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
    }

    return userDetails;
  }
}