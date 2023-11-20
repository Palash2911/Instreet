import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/views/screens/onboarding/login.dart';
import 'package:instreet/views/screens/onboarding/permission.dart';
import 'package:provider/provider.dart';

import 'constants/routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyApp());
}

@pragma("vm:entry-point")
Future<void> backgroundHandler(RemoteMessage mssg) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => Auth(),
        ),
        // ChangeNotifierProvider(
        //   create: (BuildContext context) => UserProvider(),
        // ),
        // ChangeNotifierProvider(
        //   create: (BuildContext context) => EntryProvider(),
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        navigatorKey: navigatorKey,
        routes: approutes,
      ),
    );
  }
}
