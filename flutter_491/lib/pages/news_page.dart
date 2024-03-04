import 'package:flutter/material.dart';
import 'package:flutter_491/components/post_item.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';
import 'package:flutter_svg/flutter_svg.dart';



class NewsPage extends StatelessWidget{

  NewsPage({super.key});
  
  List<String> heading = [];


  @override
  Widget build(BuildContext context){
    mockUsersFromServer();
    return Scaffold(

      appBar: Toolbar(title: 'CSULB News', 
      actions: [
        //press notification icon
        IconButton(
          onPressed: (){
            Navigator.of(context).pushNamed(AppRoutes.notifications_page);
          }, 
          icon: SvgPicture.asset('assets/svg/Bell.svg')
          ),

        ],
      ),

    //body elements

    //use ListView for lists and better performance
      body: ListView.separated(
        itemBuilder: (context, index) {
          return PostItem(heading: heading[index],);
        },
        itemCount: heading.length,
        separatorBuilder: (BuildContext context, int index){
          return SizedBox(
            height: 24,
          );
        },
      ),
    );
  }

  //list view for multiple objects
  mockUsersFromServer(){
    for (var i = 0; i < 100; i++){
      heading.add('News Title $i',);

    }
  }

}