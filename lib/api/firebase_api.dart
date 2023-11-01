
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notificationpractice/main.dart';

class FirebaseApi{
  // create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async{
    //request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();
    // fetch the FCM token for this device
    final fCMToken =await _firebaseMessaging.getToken();
    //print the token (normally send to the server)
    print('Token: $fCMToken');

    // initialize further settings for push noti
    initPushNotifications();
  }
  //function to handle received messages
  void handleMessage(RemoteMessage? message){
    // if the message is null, do noting
    if (message == null) return;

    // navigate to a new screen when message is received and user taps notification
    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments:message
    );
  }

  //function to initialize foreground and backfround settings
  Future initPushNotifications() async{
    // handle notifications if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    // attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}



// import 'dart:convert';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import '../page/notification_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// //final navigatorKey = GlobalKey<NavigatorState>();
// final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
//
// Future<void> handleBackgroundMessage(RemoteMessage? message) async {
//   //if (message == null) return;
//
//   //print(message?.notification?.title);
//   navigatorKey.currentState?.pushNamed(
//     '/notification_screen',
//     arguments: message,
//   );
// }
//
// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;
//
//   final androidChannel = const AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: 'This channel is used for important notifications',
//     importance: Importance.defaultImportance,
//   );
//   final _localNotifications = FlutterLocalNotificationsPlugin();
//
//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;
//
//     navigatorKey.currentState?.pushNamed(
//       NotificationScreen.route,
//       arguments: message,
//     );
//   }
//
//   Future initLocalNotifications() async {
//     const iOS = IOSInitializationSettings();
//     const android = AndroidInitializationSettings('@drawable/ic_launcher');
//     const settings = InitializationSettings(android: android, iOS: iOS);
//
//     await _localNotifications.initialize(
//       settings,
//       onSelectNotification: (payload) {
//         print('Received payload: $payload');
//         final message = RemoteMessage.fromMap(jsonDecode(payload!));
//         handleMessage(message);
//       },
//     );
//     final platform = _localNotifications.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//     await platform?.createNotificationChannel(androidChannel);
//   }
//
//   Future initPushNotifications() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//
//     FirebaseMessaging.onMessage.listen((message) {
//       final notification = message.notification;
//       if (notification == null) return;
//       _localNotifications.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             androidChannel.id,
//             androidChannel.name,
//             channelDescription: androidChannel.description,
//             icon: '@drawable/ic_launcher',
//           ),
//         ),
//         payload: jsonEncode(message.toMap()),
//       );
//     });
//   }
//
//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission();
//     print("before token");
//     final fCMToken = await _firebaseMessaging.getToken();
//     print('Token:$fCMToken');
//     //FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//     initPushNotifications();
//     initLocalNotifications();
//   }
// }
