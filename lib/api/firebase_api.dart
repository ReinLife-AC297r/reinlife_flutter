import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notificationpractice/pages/questionnaire.dart';
import '../pages/surveypage.dart';
import '../main.dart';
import 'package:notificationpractice/pages/message_page.dart';
import 'package:intl/intl.dart';

// Define a global navigation key for navigating the user to the desired page when the notification is clicked
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class FirebaseApi {
  // Define a notification channel for Android devices
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  // Initialize the FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Handle incoming messages
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    final String? dataPayload = message.data['body'];
    if (dataPayload != null && dataPayload.isNotEmpty) {
      final dynamic decodedBody = json.decode(dataPayload);
      
      if (decodedBody['nType'] == 'message') {
        final timeformat = formatFirestoreTimestamp(decodedBody['time']);
        final String messageText = decodedBody['message'];
        final String time = timeformat;
        
        navigatorKey.currentState?.pushNamed(
          MessagePage.route,
          arguments: {
            'message': messageText,
            'time': time,
          },
        );
      } else if (decodedBody['nType'] == 'questionnaire') {
        final nId = decodedBody['nId'];
        getQuestionnaireDoc(nId).then((questionnaireDoc) {
          if (questionnaireDoc != null && questionnaireDoc['questions'] is List) {
            final List<dynamic> questionsArray = questionnaireDoc['questions'];
            navigatorKey.currentState?.pushNamed(
              QuestionnaireScreen.route,
              arguments: questionsArray,
            );
          }
        }).catchError((error) {});
      }
    }
  }

  // Format Firestore timestamp to a readable format
  String formatFirestoreTimestamp(Map<String, dynamic> timestamp) {
    if (timestamp.containsKey('_seconds')) {
      int seconds = timestamp['_seconds'];
      int nanoseconds = timestamp['_nanoseconds'] ?? 0;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000).add(Duration(microseconds: nanoseconds ~/ 1000));
      String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
      return formattedDate;
    } else {
      return 'Invalid timestamp';
    }
  }

  // Fetch questionnaire document from Firestore
  Future<Map<String, dynamic>?> getQuestionnaireDoc(int nId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Questionnaires')
          .where('questionnaireId', isEqualTo: nId)
          .limit(1)
          .get();
     
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot questionnaireDoc = querySnapshot.docs.first;
        return questionnaireDoc.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Handle background messages
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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
            channelDescription: channel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    }
  }

  // Initialize local notifications
  Future initLocalNotifications() async {
    const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          final message = RemoteMessage.fromMap(jsonDecode(payload));
          handleMessage(message); // Call your navigation logic here
        }
      },
    );  

    final platform = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(channel);
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );   
  }
  
  // Initialize push notifications settings
  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    _firebaseMessaging.getToken().then((token) {
      if (token != null) {
        saveToken(token);
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
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
              channelDescription: channel.description,
              icon: '@drawable/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.toMap()),
        );
      }
    });
  }

  // Save the Firebase Messaging token to Firestore
  Future<void> saveToken(String? token) async {
    if (token != null) {
      print('token is: $token');
      try {
        await _firestore.collection('Users').doc('caZSPlKe5eUPEkxqwkjp').set({
          'token': token,
        }, SetOptions(merge: true));
      } catch (e) {}
    }
  }

  // Initialize all notifications settings
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    initLocalNotifications();
    initPushNotifications();
  }
}
