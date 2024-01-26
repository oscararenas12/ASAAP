import 'package:flutter/material.dart';
import 'package:flutter_491/pages/home_page.dart';
import 'package:flutter_491/pages/map_page.dart';
import 'package:flutter_491/pages/news_page.dart';
import 'package:flutter_491/pages/profile_page.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';


//Statefulwidget for interaction and dynamic response
class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int currentIndex = 0;
  @override
  Widget build(BuildContext context){

    return Scaffold(

      //gets index nav bar pages
      body: pages[currentIndex],

      //NAVIGATION BAR ICONS
      bottomNavigationBar: BottomNavigationBar(
        items: [

                                  // adding label is manditory
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/Paper.svg'), label: 'Newsfeed'),
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/Pin_alt.svg'), label: 'Map'),
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/Home.svg'), label: 'Home'),
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/Ai Bot.svg'), label: 'Bot'),
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/User_cicrle.svg'), label: 'User'),


        ],

      //dynamic button navigation, nav bar
      currentIndex: currentIndex ,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },

        //fixed nav bar color
        type: BottomNavigationBarType.fixed,

        //hide navigation bar 'label'
        showSelectedLabels: false,
        showUnselectedLabels: false,

        backgroundColor: AppColors.darkblue
      
      ),



    );
  }

//nav bar pages
  final pages = [
    NewsPage(),
    MapPage(),
    HomePage(),
    Center(child: Text('CHATBOX')),
    ProfilePage(),
  ];



}