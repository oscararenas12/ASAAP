import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_491/components/consts.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:flutter_491/styles/app_colors.dart';


//
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY, 
    baseOption:HttpSetup(
      receiveTimeout: const Duration(
        seconds: 5,
      )
    ),
    enableLog: true, 
  );




//chat page users
  final ChatUser _currentUser = ChatUser(id: '1', firstName: "erick", lastName: 'garcia');

  final ChatUser _gptUser = ChatUser(id: '2', firstName: "Chat", lastName: 'GPT');

  List<ChatMessage> _messages = <ChatMessage> [];
  List<ChatUser> _typingUsers = <ChatUser>[];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(title: "chatbox"),
      

      body: DashChat(
        currentUser: _currentUser, 
        typingUsers: _typingUsers,
        messageOptions: const MessageOptions(
          currentUserContainerColor: AppColors.darkblue,
          

          containerColor: Colors.white,
          textColor: Colors.white,
        ),
        onSend: (ChatMessage m){
          getChatResponse(m);

      }, messages: _messages),

    );
  }

  Future<void> getChatResponse(ChatMessage m) async{
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptUser);
    });
    
    List<Messages> _messagesHistory = _messages.reversed.map((m) {
      if (m.user == _currentUser){
        return Messages(role: Role.user, content: m.text);
      } else {
        return Messages(role: Role.assistant, content: m.text); 
      }
    }).toList();

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(), 
      messages: List.from(_messagesHistory),
      maxToken: 200,
    );
    
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices){
      if (element.message != null){
        setState(() {
          _messages.insert(
            0, ChatMessage(
              user: _gptUser, 
              createdAt: DateTime.now(), 
              text: element.message!.content
              ),
              );       
          });
      }
    }
      setState(() {
      _typingUsers.remove(_gptUser);
    });

  }
}

