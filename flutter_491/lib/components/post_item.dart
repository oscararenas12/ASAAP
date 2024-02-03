import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';

//THIS PAGE IS FOR STYLING THE NEWSFEED


enum NewsMenu {
  option,
  report,
}

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
              Text(heading, style: AppText.header1,
            
              ),
              
                      
          
        ],
            
          ),
          SizedBox(
            height: 24,
          ),
          Image.asset('assets/temp/csulb campus.jpg'),
          SizedBox(
            height: 16,
          ),
          Text("post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post", 
          style: AppText.subtitle1,
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              
              Icon(Icons.bookmark,
                  size: 22,
                ),

                SizedBox(
                  width: 12,
                ),

              Icon(Icons.share,
                  size: 22,
                ),

            PopupMenuButton<NewsMenu>(

            onSelected: (value) {
              switch (value) {
                case NewsMenu.option:
                  //Navigator.of(context).pushNamed(AppRoutes.'edit_profile');
                  break;
                case NewsMenu.report:
                  print('report');
                  break;
                default:
              }
            },
            icon: Icon(Icons.more_vert_rounded,),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('options'),
                  value: NewsMenu.option,
                ),
                PopupMenuItem(
                  child: Text('report'),
                  value: NewsMenu.report,
                ),
              ];
            },
          ),
            ],

            
          ),

          

            Divider(
              color: AppColors.darkblue,
              thickness: 1,
              height: 10,
              indent: 5,
              endIndent: 5,
            ),

          

        ],
      ),
    );

  }

}