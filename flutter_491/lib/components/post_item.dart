import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';

//THIS PAGE IS FOR STYLING THE NEWSFEED

class PostItem extends StatelessWidget{

  final String heading;

  const PostItem({super.key, required this.heading});

  @override
  Widget build(BuildContext context){
    return Padding(
                  //fix
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              //shark image
              Image.asset('assets/temp/User Icon.png',
              height: 50,
              width: 50,
              ),
              SizedBox(
                width: 20,
              ),
              Text(heading, style: AppText.header1,),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Image.asset('assets/temp/csulb campus.jpg'),
          SizedBox(
            height: 12,
          ),
          Text("This is the fucking news asjdhasdhadhaskdhaskdakdhakdk", 
          style: AppText.subtitle1,),
        ],
      ),
    );

  }

}