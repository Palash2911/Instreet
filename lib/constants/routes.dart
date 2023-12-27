import 'package:flutter/material.dart';
import 'package:instreet/views/screens/bottomnav/bottomNav.dart';
import 'package:instreet/views/screens/onboarding/login.dart';
import 'package:instreet/views/screens/onboarding/permission.dart';
import 'package:instreet/views/screens/onboarding/register.dart';
import 'package:instreet/views/screens/onboarding/splashScreen.dart';
import 'package:instreet/views/screens/postscreens/Categories.dart';

var approutes = <String, WidgetBuilder>{
   // Inital Route
  '/': (context) => const SplashScreen(),
  // '/': (context) => const BottomNav(),

  // Onboarding Routes
  PermissionScreen.routeName: (context) => PermissionScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),

  //bottom nav
  BottomNav.routeName: (context) => BottomNav(),

  // Categories Route
  Categories.routeName:(context)=>Categories(),

};
