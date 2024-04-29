import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_491/styles/app_colors.dart';

class ConversationsPage extends StatefulWidget {
  final VoidCallback onClose;

  const ConversationsPage({Key? key, required this.onClose}) : super(key: key);

  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  List<String> conversations = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  void _loadConversations() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Corrected path to match Firestore rules
        var snapshot = await _firestore.collection('users/${user.uid}/conversations')
            .orderBy('__name__')
            .get();
        var loadedConversations = snapshot.docs
            .map((doc) => doc.data()['name'].toString())
            .toList();
        setState(() {
          conversations = loadedConversations;
        });
      } catch (e) {
        print("Failed to load conversations: $e");
      }
    } else {
      print("User is not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a Conversation"),
        backgroundColor: AppColors.darkblue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: widget.onClose,
        ),
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(conversations[index]),
            onTap: () {
              // Implement the onTap logic here
              widget.onClose();
            },
          );
        },
      ),
    );
  }
}
