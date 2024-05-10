import 'package:flutter/material.dart';
import 'package:flutter_491/Campus%20Map/map.dart';
import 'package:flutter_491/Campus%20Map/map_polygon.dart';
import 'package:flutter_491/Chat/chat_page.dart';
import 'package:flutter_491/pages/home_page.dart';
import 'package:flutter_491/pages/news_page.dart';
import 'package:flutter_491/pages/profile_page.dart';
import 'package:flutter_491/pages/tutorial_manager.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Jessica's Contribution for App's Tutorial
//Global keys for tutorial
final GlobalKey newsFeedKey = GlobalKey();
  final GlobalKey mapKey = GlobalKey();
  final GlobalKey homeKey = GlobalKey();
  final GlobalKey chatbotKey = GlobalKey();
  final GlobalKey userKey = GlobalKey();

  // Global key to access the MainPageState from other pages.
GlobalKey<_MainPageState> mainPageKey = GlobalKey<_MainPageState>();

class MainPage extends StatefulWidget {
  final int initialPage;
  const MainPage({Key? key, this.initialPage = 2}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {

  late int currentIndex;
  @override
  void initState() {

    super.initState();
    currentIndex = widget.initialPage;
    //Initiates tutorial when main_page is first instantiated when user logs in
    WidgetsBinding.instance.addPostFrameCallback((_) => showTutorialIfFirstTimeHomeMain());
  }

 
//Function calls to show tutorial which is only called when user first lands on main page for the first time
  Future<void> showTutorialIfFirstTimeHomeMain() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   bool hasSeenTutorialHomeMainPage = prefs.getBool('hasSeenTutorialHomeMainPage') ?? false;
   print("Has seen main page tutorial: $hasSeenTutorialHomeMainPage");

   if (!hasSeenTutorialHomeMainPage) {
      await prefs.setBool('hasSeenTutorialHomeMainPage', true);
      print("Showing tutorial");
      TutorialManager.showHomeMainPageTutorial(context);
   }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Container(
              key: newsFeedKey,
              child: SvgPicture.asset('assets/svg/Paper.svg'),
            ),
            label: 'Newsfeed',
          ),
          BottomNavigationBarItem(
            icon: Container(
              key: mapKey,
              child: SvgPicture.asset('assets/svg/Pin_alt.svg'),
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Container(
              key: homeKey,
              child: SvgPicture.asset('assets/svg/Home.svg'),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              key: chatbotKey,
              child: SvgPicture.asset('assets/svg/Ai Bot.svg'),
            ),
            label: 'Bot',
          ),
          BottomNavigationBarItem(
            icon: Container(
              key: userKey,
              child: SvgPicture.asset('assets/svg/User_cicrle.svg'),
            ),
            label: 'User',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: AppColors.darkblue,
      ),
    );
  }

  final pages = [
    NewsPage(), //Index 0
    const CampusMap(), //Index 1
    HomePage(), //Index 2
    const ChatPage(), //Index 3
    const ProfilePage(), //Index 4
  ];
}
