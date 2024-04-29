import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttermoji/fluttermojiFunctions.dart';

class FriendProfilePage extends StatelessWidget {
  final String userId;

  const FriendProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('No data available'),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final userName = '${userData['firstName']} ${userData['lastName']}';
          final fluttermojiUrl = userData['fluttermoji'] ?? ''; // Assuming there's a field 'fluttermojiUrl' in your user document

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:25),
             CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey[200],
                      child: SvgPicture.string(
                        FluttermojiFunctions()
                            .decodeFluttermojifromString(fluttermojiUrl ?? ''),
                            fit: BoxFit.contain, // Ensure the SVG fits within the CircleAvatar
                            height: 160, // Specify the height to match the CircleAvatar size
                            width: 160, // Specify the width to match the CircleAvatar size
                          ),
                    ),
                SizedBox(height: 20),
                Text(
                  'Name: $userName',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Email: ${userData['email']}',
                  style: TextStyle(fontSize: 16),
                ),
                // You can display more user information here
              ],
            ),
          );
        },
      ),
    );
  }
}