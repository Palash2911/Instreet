import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/providers/notificationProvider.dart';
import 'package:instreet/providers/reviewProvider.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'constants/constants.dart';
import 'constants/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseNotification().initNotification();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // FirebaseMessaging.instance.subscribeToTopic('users');
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => StallProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ReviewProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        theme: instreetTheme,
        navigatorKey: navigatorKey,
        routes: approutes,
      ),
    );
  }
}
