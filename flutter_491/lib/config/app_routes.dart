import 'package:flutter_491/pages/chat_page.dart';
import 'package:flutter_491/pages/edit_profile_page.dart';
import 'package:flutter_491/pages/home_page.dart';
import 'package:flutter_491/pages/login_page.dart';
import 'package:flutter_491/pages/main_page.dart';
import 'package:flutter_491/pages/map_page.dart';
import 'package:flutter_491/pages/news_page.dart';
import 'package:flutter_491/pages/settings_page.dart';
import 'package:flutter_491/pages/signup_page.dart';

class AppRoutes{

  static final pages = {
        login:(context) => LoginPage(),
        home:(context) => HomePage(),
        news:(context) => NewsPage(),
        main:(context) => MainPage(),
        signup:(context) => SignUpPage(),

        //home_page navigator
        edit_profile:(context) => EditProfilePage(),
        Settings:(context) => SettingsPage(),
        map:(context) => MapPage(),

        chat:(context) => ChatPage(),

  };




  static const login = '/';
  static const home = '/home';
  static const news = '/news';
  static const main = '/main';
  static const edit_profile = '/edit_profile';
  static const map = '/map';
  static const chat = '/chat';
  static const Settings = '/Settings';
  static const signup = '/signup';
}