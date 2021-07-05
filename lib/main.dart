import 'package:flutter/material.dart';
import 'package:flutter_firebase_todo_app/screens/sign_in_screen.dart';
import 'package:flutter_firebase_todo_app/utils/custom_colors.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: CustomColors.firebaseOrange,
        bottomAppBarColor: CustomColors.firebaseNavy,
        appBarTheme: AppBarTheme(
            backgroundColor: CustomColors.firebaseOrange, centerTitle: true),
        scaffoldBackgroundColor: CustomColors.firebaseNavy,
        primaryColor: CustomColors.firebaseOrange,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: CustomColors.firebaseOrange),
      ),
      home: SignInScreen(),
    );
  }
}
