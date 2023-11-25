import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../pages/surveypage.dart';
import '../main.dart';
import 'package:notificationpractice/pages/message_page.dart';
import 'package:intl/intl.dart';
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

  final String? dataPayload = message.data['body'];
  if (dataPayload != null && dataPayload.isNotEmpty) {
    final dynamic decodedBody = json.decode(dataPayload);
    
    if (decodedBody['nType'] == 'message') {
      final timeformat = formatFirestoreTimestamp(decodedBody['time']);
      // Navigate to the messages page with message and time
      final String messageText = decodedBody['message'];
      final String time = timeformat; // Assuming 'time' is a field in the notification
    
      navigatorKey.currentState?.pushNamed(
        MessagePage.route, // Replace with the actual route name of your messages page
        arguments: {
          'message': messageText,
          'time': time,
        },
      );
    } else if (decodedBody['nType'] == 'questionnaire') {
      // Fetch the questionnaire document by the nId
      final  nId = decodedBody['nId'];
      // Use your method to fetch the questionnaire document based on nId
      // Let's assume you have a function getQuestionnaireDoc(nId) that returns the doc
      getQuestionnaireDoc(nId).then((questionnaireDoc) {
        if (questionnaireDoc != null && questionnaireDoc['questions'] is List) {
          final List<dynamic> questionsArray = questionnaireDoc['questions'];
          // Navigate to the questionnaire page with the fetched questions
          navigatorKey.currentState?.pushNamed(
            QuestionnaireScreen.route, // Replace with the actual route name of your questionnaire page
            arguments: questionsArray,
          );
        } else {
          print('The fetched document does not contain a List of questions');
        }
      }).catchError((error) {
        print('Error fetching questionnaire document: $error');
      });
    } else {
      print('Unknown notification type');
    }
  } else {
    print('The payload data is null or empty');
  }
}

String formatFirestoreTimestamp(Map<String, dynamic> timestamp) {
  if (timestamp.containsKey('_seconds')) {
    // Create a DateTime object from seconds and nanoseconds
    int seconds = timestamp['_seconds'];
    int nanoseconds = timestamp['_nanoseconds'] ?? 0; // Handle the case where '_nanoseconds' might be null
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000).add(Duration(microseconds: nanoseconds ~/ 1000));

    // Format the DateTime object to a string
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
    return formattedDate;
  } else {
    return 'Invalid timestamp';
  }
}
Future<Map<String, dynamic>?> getQuestionnaireDoc(int nId) async {
  try {

    // Query the 'Questionnaires' collection for documents where 'questionnaireId' matches 'nId'
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Questionnaires')
        .where('questionnaireId', isEqualTo: nId)
        .limit(1) // Assuming 'nId' is unique and there should only be one matching document
        .get();

   
    if (querySnapshot.docs.isNotEmpty) {
      // Convert the DocumentSnapshot to a Map and return
      DocumentSnapshot questionnaireDoc = querySnapshot.docs.first;
      return questionnaireDoc.data() as Map<String, dynamic>?;
    } else {
      print('No questionnaire found for the given nId.');
      return null;
    }
  } catch (e) {
    print('Error fetching questionnaire document: $e');
    return null;
  }
}


/*
void handleMessage(RemoteMessage? message) {
  if (message == null) return;
  print('A new onMessageOpenedApp event was published!');

  // Ensure that dataPayload is not null and is not empty
  final String? dataPayload = message.data['body'];
  
  // check whether the notification type is a questionnaire or an regular notification
  if (dataPayload != null && dataPayload.isNotEmpty) {
    final dynamic decodedBody = json.decode(dataPayload);
    // check the notification type: message or questionnaire
    if (decodedBody['nType'] == 'message'){
      // extract the data from the decodedBody
      // tranfer the user to the message page
    }
  else{
    // retrieve the document from the questionnaires collection using the matching nId
    // questinnaireDoc =
    // If decodedBody['questions'] is a List, then we assume it's a list of questions
    if (questinnaireDoc is Map<String, dynamic> && questinnaireDoc['questions'] is List) {
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
  }

  } else {
    print('The payload data is null or empty');
  }
}
*/

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
    // iOS Initialization settings
    const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      // Add any specific settings you need here
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      //onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    // Android Initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_launcher');

    // Initialization settings for both platforms
    const InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    

    await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
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
    provisional:false,
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
    
    String? token1 = await FirebaseMessaging.instance.getAPNSToken();
    if (token1 != null) {
      print('apns token is $token1');
      // Handle the token (e.g., send it to your server)
       }
       
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
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional:false,
    );
  
    _configureFirebaseListeners();
    //FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    initLocalNotifications();
    initPushNotifications();
    
  }



void _configureFirebaseListeners() {
  FirebaseMessaging.instance.onTokenRefresh.listen(_saveTokenToDatabase);
  FirebaseMessaging.instance.getAPNSToken().then((String? token) {
    if (token != null) {
      print('APNS Token: $token');
      // Save the token to your backend or wherever it's needed
    }
  });
}


void _saveTokenToDatabase(String token) async {
  // Save the token to your backend or wherever it's needed
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
}




