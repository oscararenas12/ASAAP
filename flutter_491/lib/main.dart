import 'package:flutter/material.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/pages/edit_profile_page.dart';
import 'package:flutter_491/pages/home_page.dart';
import 'package:flutter_491/pages/login_page.dart';
import 'package:flutter_491/pages/main_page.dart';
import 'package:flutter_491/pages/news_page.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDHoJM_eZZ0qIn_PDi0omsxPFP5ngVtMvc',
      appId: '1:176736238242:web:014c964d6f1cb5d17975fb',
      messagingSenderId: '176736238242',
      projectId: 'asaapp-491',
      authDomain: 'asaapp-491.firebaseapp.com',
      storageBucket: 'asaapp-491.appspot.com',
      measurementId: 'G-WM0P3PT2PM',
    ),
  );

  /* Jessica line 27 & 28: Ensures Firebase is initialized*/
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static bool isDarkMode = false;

  static void setDarkMode() {
    isDarkMode = true;
  }

  static void setLightMode() {
    isDarkMode = false;
  }

//   // Jessica - Creating Dynamic link
//     MyApp({super.key}) {
//     _initDynamicLinks();
//   }

//   void _initDynamicLinks() async {
//   final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
//   final Uri? deepLink = data?.link;
//   if (deepLink != null) {
//     navigateBasedOnLink(deepLink);
//   }

//   FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
//     final Uri deepLink = dynamicLinkData.link;
//     navigateBasedOnLink(deepLink);
//   }).onError((e) {
//     // Handle errors
//     print('Dynamic Link Failed: $e');
//   });
// }

// void navigateBasedOnLink(Uri deepLink) {
//   if (deepLink.path == '/login') {
//     navigatorKey.currentState?.pushNamed(AppRoutes.login);
//   }
//   // Add other navigation logic based on different paths
// }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          headlineLarge: TextStyle(),
          bodyMedium: TextStyle(),
        ).apply(
          bodyColor: Colors.white, 
          displayColor: Colors.white, 
          
        ),


        fontFamily: 'Urbanist',
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDarkMode ? AppColors.black : AppColors.background,
        useMaterial3: true,

      ),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.pages,
    );
  }
}