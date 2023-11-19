import 'package:flutter/material.dart';
import 'package:instreet/views/screens/onboarding/login.dart';
import 'package:instreet/views/screens/onboarding/permission.dart';
import 'package:instreet/views/screens/onboarding/register.dart';

var approutes = <String, WidgetBuilder>{
   // Inital Route
  '/': (context) => const PermissionScreen(),

  // Onboarding Routes
  LoginScreen.routeName: (context) => LoginScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
};
