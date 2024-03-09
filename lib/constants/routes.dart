import 'package:flutter/material.dart';
import 'package:instreet/views/screens/bottomnav/BottomNav.dart';
import 'package:instreet/views/screens/otherscreens/ContactAboutScreen.dart';
import 'package:instreet/views/screens/otherscreens/EditProfile.dart';
import 'package:instreet/views/screens/onboarding/Login.dart';
import 'package:instreet/views/screens/otherscreens/Permission.dart';
import 'package:instreet/views/screens/onboarding/Register.dart';
import 'package:instreet/views/screens/otherscreens/SplashScreen.dart';
import 'package:instreet/views/screens/otherscreens/Categories.dart';
import 'package:instreet/views/screens/stallscreen/StallScreen.dart';

var approutes = <String, WidgetBuilder>{
  // Inital Route
  '/': (context) => const SplashScreen(),

  // Onboarding Routes
  PermissionScreen.routeName: (context) => const PermissionScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),

  //bottom nav
  BottomNav.routeName: (context) => BottomNav(),

  // Other Routes
  EditProfileScreen.routeName: (context) => const EditProfileScreen(),
  StallScreen.routeName: (context) => const StallScreen(),
  ContactUs.routeName: (context) => const ContactUs(),
  AboutUs.routeName: (context) => const AboutUs(),
};
