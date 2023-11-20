import 'package:flutter/material.dart';
import 'package:instreet/views/screens/onboarding/login.dart';
import 'package:instreet/views/screens/onboarding/permission.dart';
import 'package:instreet/views/screens/onboarding/register.dart';
import 'package:instreet/views/screens/onboarding/splashScreen.dart';

var approutes = <String, WidgetBuilder>{
   // Inital Route
  '/': (context) => const SplashScreen(),

  // Onboarding Routes
  PermissionScreen.routeName: (context) => PermissionScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
};
