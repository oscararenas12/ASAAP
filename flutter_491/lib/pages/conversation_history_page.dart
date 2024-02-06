import 'package:flutter/material.dart';
import 'package:flutter_491/styles/app_colors.dart'; // Make sure to import your AppColors class

class ConversationsPage extends StatefulWidget {
  final VoidCallback onClose;

  const ConversationsPage({Key? key, required this.onClose}) : super(key: key);

  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  List<String> conversations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a Conversation"),
        backgroundColor: AppColors.darkblue, // Set the AppBar color
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
              // For example, closing the overlay after selecting a conversation
              widget.onClose();
            },
          );
        },
      ),
    );
  }
}
