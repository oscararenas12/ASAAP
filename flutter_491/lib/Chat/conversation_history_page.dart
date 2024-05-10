import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_491/styles/app_colors.dart';

import 'conversation_details_page.dart';

class ConversationsPage extends StatefulWidget {
  final VoidCallback onClose;

  const ConversationsPage({Key? key, required this.onClose}) : super(key: key);

  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  List<Map<String, dynamic>> conversations = [];  // To store conversations with additional details like ID
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
        var snapshot = await FirebaseFirestore.instance
            .collection('users/${user.uid}/conversations')
            .orderBy('createdAt', descending: true)
            .get();
        var loadedConversations = snapshot.docs
            .map((doc) => {
          'id': doc.id, // Store the document ID
          'name': doc.data()['name'].toString() // Store the conversation name
        })
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
          var conversation = conversations[index];
          return ListTile(
            title: Text(conversation['name']),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ConversationDetailsPage(
                  conversationId: conversation['id'],
                  conversationName: conversation['name'],
                ),
              ));
            },
          );
        },
      ),
    );
  }
}
