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
import 'package:flutter/material.dart';

 
//final navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      navigatorKey: navigatorKey,
      onGenerateRoute: (settings) {
         if (settings.name == QuestionnaireScreen.route) {
          final questionsArray = settings.arguments as List<dynamic>?;
          // Make sure that questionsArray is not null before passing it to the screen
          return MaterialPageRoute(
            builder: (context) => QuestionnaireScreen(questionsArray: questionsArray),
          );
         }

    //     else if (settings.name == SurveyPage.route) {
    //         // Ensure the right type of arguments are passed
    //         final surveyArguments = settings.arguments as List<Question>;
    //         return MaterialPageRoute(
    //           builder: (context) => SurveyPage(questions: surveyArguments),
    //         );
    // }

        else if(settings.name == MessagePage.route){
          final data = settings.arguments as Map<String, dynamic>;
          //final time = formatTimestamp(data['time']) ;
           return MaterialPageRoute(
             builder: (context) => MessagePage(
             message: data['message'] as String,
             time: data['time'], // Replace with actual time
             ),);
        }
        // Handle other routes if needed
        return MaterialPageRoute(builder: (context) => Scaffold());
      },
    );
  }

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate(); // Convert to DateTime
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateTime); // Format date
  return formattedDate;
}

}
