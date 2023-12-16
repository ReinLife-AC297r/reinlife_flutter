import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notificationpractice/api/firebase_api.dart';
import 'package:notificationpractice/firebase_options.dart';
import 'package:notificationpractice/pages/home_page.dart';
import 'package:notificationpractice/pages/question_widget.dart';
import 'package:notificationpractice/pages/questionnaire.dart';
import 'package:notificationpractice/pages/surveypage.dart';
import 'package:notificationpractice/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notificationpractice/pages/message_page.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

// Main entry point of the Flutter application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures that Flutter bindings are initialized.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Initialize Firebase with default settings.
  await FirebaseApi().initNotifications(); // Initialize the notifications through FirebaseApi.
  runApp(MyApp()); // Run the app with MyApp as the root widget.
}

// MyApp class - Stateless widget that defines the structure and behavior of the app.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MaterialApp is the top-level widget that controls how the app looks and feels.
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner from the UI.
      home: HomePage(), // Sets HomePage as the default opening page.
      navigatorKey: navigatorKey, // Sets the global navigation key.
      onGenerateRoute: (settings) {
        // Logic to handle routing based on the route settings.
        if (settings.name == QuestionnaireScreen.route) {
          final questionsArray = settings.arguments as List<dynamic>?;
          // Navigate to the QuestionnaireScreen with questionsArray as arguments.
          return MaterialPageRoute(
            builder: (context) => QuestionnaireScreen(questionsArray: questionsArray),
          );
        } else if (settings.name == MessagePage.route) {
          // Handle navigation to MessagePage.
          final data = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => MessagePage(
              message: data['message'] as String,
              time: data['time'], // Replace with actual time format.
            ),
          );
        }
        // Default route if none of the conditions above are met.
        return MaterialPageRoute(builder: (context) => Scaffold());
      },
    );
  }

  // Function to format Firestore Timestamp into a readable string format.
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Convert Firestore Timestamp to DateTime.
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateTime); // Format DateTime into a string.
    return formattedDate;
  }
}
