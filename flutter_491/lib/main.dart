import 'package:flutter/material.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/pages/edit_profile_page.dart';
import 'package:flutter_491/pages/home_page.dart';
import 'package:flutter_491/pages/login_page.dart';
import 'package:flutter_491/pages/main_page.dart';
import 'package:flutter_491/pages/news_page.dart';
import 'package:flutter_491/styles/app_colors.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget  {
  
  @override
  Widget build(BuildContext context){
    //root of all widgets
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Urbanist',
        scaffoldBackgroundColor: AppColors.background,
        brightness: Brightness.dark,
      
      
      ),
      

      initialRoute: AppRoutes.login,

      //page navigation routes
      routes: AppRoutes.pages,

    );
  }

  
}




