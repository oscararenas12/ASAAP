import 'package:flutter_491/Campus%20Map/current_location.dart';
import 'package:flutter_491/Campus%20Map/map_polyline.dart';
import 'package:flutter_491/Campus%20Map/search_map.dart';
import 'package:flutter_491/pages/agenda.dart';
import 'package:flutter_491/pages/chat_page.dart';
import 'package:flutter_491/pages/edit_profile_page.dart';
import 'package:flutter_491/pages/goal.dart';
import 'package:flutter_491/pages/home_page.dart';
import 'package:flutter_491/pages/login_page.dart';
import 'package:flutter_491/pages/main_page.dart';
import 'package:flutter_491/pages/map_page.dart';
import 'package:flutter_491/pages/news_page.dart';
import 'package:flutter_491/pages/notifications_page.dart';
import 'package:flutter_491/pages/settings_page.dart';
import 'package:flutter_491/pages/signup_page.dart';
import 'package:flutter_491/pages/customizeAI.dart';
import 'package:flutter_491/pages/storage_page.dart';
import 'package:flutter_491/pages/profile_page.dart';

class AppRoutes{

  static final pages = {
        login:(context) => LoginPage(),
        home:(context) => HomePage(),
        news:(context) => NewsPage(),
        main:(context) => MainPage(),
        signup:(context) => SignUpPage(),
        Settings:(context) => SettingsPage(),
        customize_AI:(context) => CustomizeAIPage(),
        storage_page:(context) => StoragePage(),
        agenda:(context) => AgendaPage(),
        goal:(context) => GoalPage(),
        profile:(context) => ProfilePage(),

        //home_page navigator
        edit_profile:(context) => EditProfilePage(),
        //map:(context) => MapPage(),
        chat:(context) => ChatPage(),
        notifications_page:(context) => NotificationPage(),

      //map navigator
        searchmap:(context) => SearchPlaces(),
        userlocation:(context) => CurrentLocation(),
        directionpolyine:(context) => MapPolyline(),





  };




  static const login = '/';
  static const home = '/home';
  static const news = '/news';
  static const main = '/main';
  static const edit_profile = '/edit_profile';
  static const map = '/map';
  static const chat = '/chat';
  static const Settings = '/Settings';
  static const notifications_page = '/notifications_page';
  static const signup = '/signup';
  static const customize_AI = '/customize_AI';
  static const storage_page = '/storage_page';
  static const agenda = '/agenda';
  static const goal = '/goal';
  static const profile = '/profile';


//map routes
  static const searchmap = '/search_map';
  static const userlocation = '/user_location';
  static const directionpolyine = '/direction_polyline';





}