import 'package:flutter/material.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/pages/edit_profile_page.dart';
import 'package:flutter_491/pages/home_page.dart';
import 'package:flutter_491/pages/login_page.dart';
import 'package:flutter_491/pages/main_page.dart';
import 'package:flutter_491/pages/news_page.dart';
import 'package:flutter_491/pages/themenotifier.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttermoji/fluttermojiController.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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

  /* Jessica line 30 & 31: Ensures Firebase is initialized*/
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(FluttermojiController());

  //Nhat: themenotifier for darkmode, make dark mode change automatically
    runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
        brightness: Provider.of<ThemeNotifier>(context).isDarkMode
            ? Brightness.dark
            : Brightness.light,
        scaffoldBackgroundColor: Provider.of<ThemeNotifier>(context).isDarkMode
            ? AppColors.black
            : AppColors.background,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.pages,
    );
  }
}