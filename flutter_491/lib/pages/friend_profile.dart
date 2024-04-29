import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttermoji/fluttermojiFunctions.dart';
import 'package:intl/intl.dart';

class Message {
  final String sender;
  final String text;

  Message({required this.sender, required this.text, required timestamp});
}

class FriendProfilePage extends StatelessWidget {
  final String userId;

  const FriendProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Profile and Message
      child: Scaffold(
        appBar: AppBar(
          title: Text('Friend Profile'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Profile'),
              Tab(text: 'Profile Comments'), // New tab for messaging
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Profile tab content
            FutureBuilder<DocumentSnapshot>(
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
                final fluttermojiUrl = userData['fluttermoji'] ?? '';
                final bio = userData['bio'] ?? '';

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.grey[200],
                          child: SvgPicture.string(
                            FluttermojiFunctions().decodeFluttermojifromString(fluttermojiUrl ?? ''),
                            fit: BoxFit.contain,
                            height: 160,
                            width: 160,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          userName,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Email: ${userData['email']}',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Bio: $bio',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Message tab content
            MessageChat(userId: userId), // Pass userId to MessageChat
          ],
        ),
      ),
    );
  }
}

class MessageChat extends StatefulWidget {
  final String userId;

  const MessageChat({Key? key, required this.userId}) : super(key: key);

  @override
  _MessageChatState createState() => _MessageChatState();
}

class _MessageChatState extends State<MessageChat> {
  final TextEditingController _messageController = TextEditingController();
  late Stream<QuerySnapshot> _messagesStream; // Stream to listen for new messages

  @override
  void initState() {
    super.initState();
    // Initialize the stream to listen for new messages in the chat
    _messagesStream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId) // Use the passed userId as the recipient's ID
        .collection('messages')
        .orderBy('timestamp', descending: true) // Order messages by timestamp
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _messagesStream,
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
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No messages available'),
                );
              }

              // Extract messages from the snapshot
              final List<Message> messages = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Message(sender: data['sender'], text: data['text'], timestamp: data['timestamp']);
              }).toList();

              return ListView.builder(
                reverse: true, // Reverse the list to display newest messages at the bottom
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(message.sender).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListTile(
                          title: Text('Loading...'),
                          subtitle: Text(message.text),
                        );
                      }
                      if (snapshot.hasError) {
                        return ListTile(
                          title: Text('Error: ${snapshot.error}'),
                          subtitle: Text(message.text),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return ListTile(
                          title: Text('Unknown'),
                          subtitle: Text(message.text),
                        );
                      }

                      final senderData = snapshot.data!.data() as Map<String, dynamic>;
                      final senderName = '${senderData['firstName']} ${senderData['lastName']}';

                      return ListTile(
                        title: Text(
                          senderName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message.text),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    _sendMessage(_messageController.text);
                    _messageController.clear();
                  }
                },
                child: Text('Send'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _sendMessage(String text) async {
    // Get the current user ID
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Handle the case where the user is not authenticated
      return;
    }
    String senderId = currentUser.uid;

    // Use the passed userId as the recipient's ID
    String recipientId = widget.userId; // Access userId from widget

    // Update the sender's database with the message
    await FirebaseFirestore.instance.collection('users').doc(senderId).collection('messages').add({
      'sender': senderId,
      'recipient': recipientId,
      'text': text,
      'timestamp': Timestamp.now(),
    });

    // Update the recipient's database with the message
    await FirebaseFirestore.instance.collection('users').doc(recipientId).collection('messages').add({
      'sender': senderId,
      'recipient': recipientId,
      'text': text,
      'timestamp': Timestamp.now(),
    });
  }
}