import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instreet/views/screens/stallscreen/StallScreen.dart';

class FirebaseNotification {
  
  final _firebaseMessaging = FirebaseMessaging.instance;
  final androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notification',
    description: 'Important Notifications',
    importance: Importance.defaultImportance,
  );

  final FlutterLocalNotificationsPlugin _localNotification = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    
    await _firebaseMessaging.requestPermission();

    initPushNotification();

  }

  Future<String?> getToken() async {
    await _firebaseMessaging.requestPermission();

    final fcmToken = await _firebaseMessaging.getToken();
    return fcmToken;
  }

  void handleMessage(RemoteMessage? mssg) {
    if (mssg == null) {
      return;
    }
  }

  void onTokenRefresh() async {
    _firebaseMessaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }
  Future initPushNotification() async {

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        handleMessage(message);
          // final stallId = message.data['stall_id'];
          // if (stallId != null) {
          //   Navigator.pushNamed(context, '/stall-screen', arguments: [stallId, 'user']);
          // }
      }
    });
  

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        displayLocalNotification(message.notification!);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        handleMessage(message);
    });
  }

  void displayLocalNotification(RemoteNotification notification) {
    _localNotification.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannel.id,
          androidChannel.name,
          channelDescription: androidChannel.description,
        ),
      ),
      payload: jsonEncode(notification.toMap()),
    );
    initLocalNotifications();
  }

  Future initLocalNotifications() async {
     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
     const settings = InitializationSettings(android: android);

     await _localNotification.initialize(settings);
     final platform = _localNotification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
     await platform?.createNotificationChannel(androidChannel);
     print("Success");
  }

}