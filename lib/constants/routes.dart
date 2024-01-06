import 'package:flutter/material.dart';
import 'package:instreet/views/screens/bottomnav/bottomNav.dart';
import 'package:instreet/views/screens/onboarding/editProfile.dart';
import 'package:instreet/views/screens/onboarding/login.dart';
import 'package:instreet/views/screens/onboarding/permission.dart';
import 'package:instreet/views/screens/onboarding/register.dart';
import 'package:instreet/views/screens/onboarding/splashScreen.dart';
import 'package:instreet/views/screens/postscreens/Categories.dart';

var approutes = <String, WidgetBuilder>{
   // Inital Route
  '/': (context) => const SplashScreen(),

  // Onboarding Routes
  PermissionScreen.routeName: (context) => const PermissionScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),

  //bottom nav
  BottomNav.routeName: (context) => const BottomNav(),

  // Other Routes
  Categories.routeName:(context)=> const Categories(),
  EditProfileScreen.routeName: (context) => const EditProfileScreen(),
};
