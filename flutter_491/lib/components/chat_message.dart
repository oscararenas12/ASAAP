//import 'package:flutter/material.dart';
//import 'package:flutter_491/styles/app_text.dart';
//
//class ChatMessage extends StatelessWidget {
//  const ChatMessage({super.key, required this.text, required this.sender});
//
//  final String text;
//  final String sender;
//
//  @override
//  Widget build(BuildContext context) {
//    return Row(
//      children: [
//        Container(
//          margin: const EdgeInsets.only(right: 16.0),
//          child: CircleAvatar(child: Text(sender[0])),
//        ),
//
//        Expanded(
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//              Text(sender, style: AppText.subtitle1),
//              Container(
//                margin: const EdgeInsets.only(top: 5.0),
//                child: Text(text),
//              )
//            ],
//          ))
//        
//      ],
//    );
//  }
//}