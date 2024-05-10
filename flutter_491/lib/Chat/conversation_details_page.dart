import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ConversationDetailsPage extends StatefulWidget {
  final String conversationId;
  final String conversationName;

  const ConversationDetailsPage({
    Key? key,
    required this.conversationId,
    required this.conversationName,
  }) : super(key: key);

  @override
  _ConversationDetailsPageState createState() => _ConversationDetailsPageState();
}

class _ConversationDetailsPageState extends State<ConversationDetailsPage> {
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users/${FirebaseAuth.instance.currentUser?.uid}/conversations/${widget.conversationId}/messages')
          .orderBy('createdAt', descending: true)
          .get();

      var loadedMessages = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['user'] is! Map<String, dynamic>) {
          // Log error or handle it according to your app's needs
          print("User data is not in the expected format: ${data['user']}");
          // Assuming a default or handling the error
          data['user'] = {'id': 'unknown', 'firstName': 'Chat', 'lastName': 'History'};
        }

        return ChatMessage.fromJson({
          'id': doc.id,
          'text': data['text'],
          'user': data['user'], // Ensuring this is a Map<String, dynamic>
          'createdAt': DateTime.parse(data['createdAt']),
        });
      }).toList();

      setState(() {
        messages = loadedMessages;
      });
    } catch (e) {
      print('Failed to load messages: $e');
      // Optionally handle the error more gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    // Your existing build method
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversationName),
        backgroundColor: AppColors.darkblue,
      ),
      body: DashChat(
        readOnly: true,
        messages: messages,
        currentUser: ChatUser(id: 'dummy-id'),
        messageOptions: MessageOptions(
          currentUserContainerColor: AppColors.darkblue,
          currentUserTextColor: Colors.white,
          containerColor: Colors.white,
          textColor: AppColors.darkblue,
          showOtherUsersAvatar: false,
          showCurrentUserAvatar: false,
        ),
        onSend: (ChatMessage message) {  },
      ),
    );
  }
}
