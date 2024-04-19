import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_491/components/consts.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'conversation_history_page.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
        receiveTimeout: const Duration(
          seconds: 5,
        )
    ),
    enableLog: true,
  );

  //chat page users
  late ChatUser _currentUser = ChatUser(
      id: '1', firstName: "erick", lastName: 'garcia');
  final ChatUser _gptUser = ChatUser(id: '2', firstName: "AI");
  List<ChatMessage> _messages = <ChatMessage>[];
  final List<ChatUser> _typingUsers = <ChatUser>[];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isConversationsPageVisible = false;


  @override
  void initState() {
    super.initState();
    _initializeCurrentUser();
    _loadChatHistory();
  }

  void _initializeCurrentUser() async {
    User? user = _auth.currentUser;
    // Optionally, you can retrieve additional user information from Firestore if needed
    DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

    setState(() {
      // Create a ChatUser with the current user's information
      _currentUser = ChatUser(
        id: user.uid,
        firstName: userData['firstName'],
        lastName: userData['lastName'],
        // You can include other attributes such as the user's avatar, if you have it
      );
    });

    // Clear the chat history as soon as the user is initialized
    await _clearChatHistory();
  }


  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString('chat_history') ?? '[]';
    final messagesList = jsonDecode(messagesJson) as List;
    final loadedMessages = messagesList
        .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = loadedMessages.reversed.toList();
    });
  }

  Future<void> _clearChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_history');

    setState(() {
      _messages = [];
    });
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = jsonEncode(_messages.map((m) => m.toJson()).toList());
    await prefs.setString('chat_history', messagesJson);
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptUser);
    });

    await Future.delayed(const Duration(seconds: 1));

    List<Messages> _messagesHistory = _messages.reversed.map((m) {
      if (m.user == _currentUser) {
        return Messages(role: Role.user, content: m.text);
      } else {
        return Messages(role: Role.assistant, content: m.text);
      }
    }).toList();

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: _messagesHistory,
      maxToken: 200,
    );

    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        ChatMessage newMessage = ChatMessage(
          user: _gptUser,
          createdAt: DateTime.now(),
          text: element.message!.content,
        );
        setState(() {
          _messages.insert(0, newMessage);
        });

        // Save to Firestore
        _saveMessageToFirestore(newMessage);
      }
    }
    setState(() {
      _typingUsers.remove(_gptUser);
    });
    await _saveChatHistory();
  }

  void _saveMessageToFirestore(ChatMessage message) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users/${user.uid}/conversations')
          .add({
        'text': message.text,
        'createdAt': message.createdAt.toIso8601String(),
        'userId': message.user.id,
        'userName': '${message.user.firstName!} ${message.user.lastName ?? ''}',
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Toolbar(
                title: 'AI Assistant',
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.list), // The menu hamburger icon
                    onPressed: () {
                      setState(() {
                        _isConversationsPageVisible =
                        !_isConversationsPageVisible;
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: DashChat(
                  currentUser: _currentUser,
                  onSend: (ChatMessage m) {
                    // Save the user's message to Firestore
                    _saveMessageToFirestore(m);
                    // Get a response from the chatbot
                    getChatResponse(m);
                  },
                  messages: _messages,
                  messageOptions: const MessageOptions(
                    currentUserContainerColor: AppColors.darkblue,
                    currentUserTextColor: Colors.white,
                    containerColor: Colors.white,
                    textColor: AppColors.darkblue,
                    showOtherUsersAvatar: false,
                    showCurrentUserAvatar: true,
                  ),
                ),
              ),
            ],
          ),
          // ConversationsPage overlay
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _isConversationsPageVisible ? MediaQuery.of(context).size.width * 0.2 : MediaQuery.of(context).size.width, // Adjusted for more coverage
            top: 0,
            bottom: 0,
            right: _isConversationsPageVisible ? -MediaQuery.of(context).size.width * 0.2 : 0, // Adjust if you're controlling width from both sides
            child: Material(
              elevation: 4.0,
              child: ConversationsPage(
                onClose: () {
                  setState(() {
                    _isConversationsPageVisible = false;
                  });
                },
              ), // Your ConversationsPage content
            ),
          ),
        ],
      ),
    );
  }
}
