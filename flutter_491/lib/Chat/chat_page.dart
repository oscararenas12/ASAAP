import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'dart:convert';
import '../components/consts.dart';
import 'conversation_history_page.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:flutter_491/styles/app_colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 5),
    ),
    enableLog: true,
  );

  ChatUser? _currentUser; // Changed to nullable to manage uninitialized state
  final ChatUser _gptUser = ChatUser(id: '2', firstName: "AI");
  List<ChatMessage> _messages = [];
  final List<ChatUser> _typingUsers = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isConversationsPageVisible = false;
  int conversationCount = 0;
  String?
      currentConversationId; // Add this line to hold the current conversation ID

  @override
  void initState() {
    super.initState();
    _initializeCurrentUser();
    _loadChatHistory();
    _loadConversationCount();
  }

  void _initializeCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _currentUser = ChatUser(
          id: user.uid,
          firstName: userData['firstName'],
          lastName: userData['lastName'],
        );
      });
    } else {
      setState(() {});
    }
    await _clearChatHistory();
  }

  Future<void> _loadConversationCount() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('utils')
        .doc('conversationCounter')
        .get();
    setState(() {
      conversationCount = snapshot.data()?['count'] ?? 0;
    });
  }

  Future<void> _incrementConversationCount() async {
    await FirebaseFirestore.instance
        .collection('utils')
        .doc('conversationCounter')
        .set({'count': FieldValue.increment(1)}, SetOptions(merge: true));
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

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = jsonEncode(_messages.map((m) => m.toJson()).toList());
    await prefs.setString('chat_history', messagesJson);
  }

  Future<void> _clearChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_history');
    setState(() {
      _messages = [];
    });
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptUser);
    });

    await Future.delayed(const Duration(seconds: 1));

    List<Messages> _messagesHistory = _messages.reversed.map((m) {
      return Messages(
          role: m.user == _currentUser ? Role.user : Role.assistant,
          content: m.text);
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

  Future<void> _saveMessageToFirestore(ChatMessage message) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Check if a new conversation needs to be started
    if (currentConversationId == null) {
      String conversationName = 'Conversation ${conversationCount + 1}';
      DocumentReference conversationDoc = await FirebaseFirestore.instance
          .collection('users/${user.uid}/conversations')
          .add({
        'name': conversationName,
        'createdAt': message.createdAt.toIso8601String(),
      });

      currentConversationId = conversationDoc.id;
      _incrementConversationCount();
    }

    // Save the message under the current conversation ID
    await FirebaseFirestore.instance
        .collection(
            'users/${user.uid}/conversations/$currentConversationId/messages')
        .add({
      'text': message.text,
      'createdAt': message.createdAt.toIso8601String(),
      'userId': message.user.id,
      'userName': '${message.user.firstName} ${message.user.lastName}',
    });
  }

  @override
  void dispose() {
    currentConversationId =
        null; // Reset conversation ID when chat page is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      // Check if _currentUser is initialized
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Show loading indicator
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Toolbar(
                title: 'AI Assistant',
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.list),
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
                  currentUser: _currentUser!, // Now safely use _currentUser!
                  onSend: (ChatMessage m) {
                    _saveMessageToFirestore(m);
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
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _isConversationsPageVisible
                ? MediaQuery.of(context).size.width * 0.2
                : MediaQuery.of(context).size.width,
            top: 0,
            bottom: 0,
            right: _isConversationsPageVisible
                ? -MediaQuery.of(context).size.width * 0.2
                : 0,
            child: Material(
              elevation: 4.0,
              child: ConversationsPage(
                onClose: () {
                  setState(() {
                    _isConversationsPageVisible = false;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
