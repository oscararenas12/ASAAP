import 'package:flutter/material.dart';
import 'package:flutter_491/components/post_item.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';


//Part of DROP DOWN MENU
enum HomeMenu{
  edit,
  logout,
}


class HomePage extends StatelessWidget{
  HomePage({super.key});
  
  List<String> heading = [];


  @override
  Widget build(BuildContext context){
    mockUsersFromServer();
    return Scaffold(

      //random appbar
      appBar: AppBar(
        backgroundColor: AppColors.darkblue,
        title: Text('Welcome Shark'),


        //POP UP MENU
        actions: [
                //<HOMEMENU>
          PopupMenuButton<HomeMenu>(
            onSelected: (value){
              switch (value){
                case HomeMenu.edit:
                Navigator.of(context).pushNamed(AppRoutes.edit_profile);

                  break;
                case HomeMenu.logout:
                print('logout');
                  break;
                default:
              }
            },
            //menu icon menu
            icon: Icon(Icons.more_vert_rounded),

            //drop down menu options
            itemBuilder: (context){
            return [
              PopupMenuItem(
                child: Text('edit'), 
                value: HomeMenu.edit,
                ),
              PopupMenuItem(
                child: Text('logout'), 
                value: HomeMenu.logout,),

            ];
            },
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
      heading.add('News Title $i');

    }
  }

}