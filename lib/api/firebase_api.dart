import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../pages/surveypage.dart';
import '../main.dart';

// Define a global navigation key for navigating the user to the desired page when the notification is clicked
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Create a local notifications channel



// Define a top-level named handler which background/terminated messages will call.

class FirebaseApi{
  // create an instance of Firebase Messaging
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:'This channel is used for important notifications.', // description
  importance: Importance.high,
);

// Initialize the FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final _firebaseMessaging = FirebaseMessaging.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

void handleMessage(RemoteMessage? message) {
  if (message == null) return;
  print('A new onMessageOpenedApp event was published!');

  // Ensure that dataPayload is not null and is not empty
  final String? dataPayload = message.data['body'];
  if (dataPayload != null && dataPayload.isNotEmpty) {
    final dynamic decodedBody = json.decode(dataPayload);

    // If decodedBody['questions'] is a List, then we assume it's a list of questions
    if (decodedBody is Map<String, dynamic> && decodedBody['questions'] is List) {
      final List<dynamic> questionsArray = decodedBody['questions'];
      //print('questions list is: $questionsArray');

      navigatorKey.currentState?.pushNamed(
        QuestionnaireScreen.route,
        arguments: questionsArray,
      );
    } else {
      // Handle the case where the decoded data is not as expected
      print('The decoded message body does not contain a List of questions');
    }
  } else {
    print('The payload data is null or empty');
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  
  print("Handling a background message: ${message.messageId}");
  final notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          "",
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription:channel.description,
              icon: '@drawable/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.toMap()),
        );
      }
}


  // function to initialize notifications
  Future initLocalNotifications() async{
    const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_launcher'),
    ),
    onSelectNotification: (String? payload) async {
      print('Received payload: $payload');
        final message = RemoteMessage.fromMap(jsonDecode(payload!));
        handleMessage(message); // Call your navigation logic here
    },
  );  

    final platform = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(channel);
    //await Firebase.initializeApp();   
    // For iOS
    await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
    
     // Set the onSelectNotification callback for when a notification is tapped
  
    // initialize further settings for push notification
     
  }
  

  //function to initialize foreground and backfround settings
  Future initPushNotifications() async{
  

    
    // handle notifications if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    // attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    _firebaseMessaging.getToken().then((token) {
      saveToken(token);
    });
    // To handle foreground messages and add them to the notification bar
    FirebaseMessaging.onMessage.listen(( message) {
      print('on message listener!!!!');
      final notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          "",
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription:channel.description,
              icon: '@drawable/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.toMap()),
        );
      }
    });
    
  }

   Future<void> saveToken(var token) async {
    try {
      await _firestore.collection('Users').doc('caZSPlKe5eUPEkxqwkjp').set({
        'token': token,
      }, SetOptions(merge: true));
      print('Token saved: $token');
    } catch (e) {
      print('Error saving token: $e');
    }
    print('token is: $token');
  }

Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
     
    //FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    initLocalNotifications();
    initPushNotifications();
    
  }

}




