import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notificationpractice/api/firebase_api.dart';
import 'package:notificationpractice/firebase_options.dart';
import 'package:notificationpractice/pages/home_page.dart';
import 'package:notificationpractice/pages/question_widget.dart';
import 'package:notificationpractice/pages/surveypage.dart';
import 'package:notificationpractice/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

        else if (settings.name == SurveyPage.route) {
            // Ensure the right type of arguments are passed
            final surveyArguments = settings.arguments as List<Question>;
            return MaterialPageRoute(
              builder: (context) => SurveyPage(questions: surveyArguments),
            );
    
    
    }
        // Handle other routes if needed
        return MaterialPageRoute(builder: (context) => Scaffold());
      },
    );
  }
}

class QuestionnaireScreen extends StatefulWidget {
  static const route = '/notification_screen';
  final List<dynamic>? questionsArray;

  QuestionnaireScreen({Key? key, this.questionsArray}) : super(key: key);

  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}


  class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  FirestoreService firestoreService = FirestoreService();
  List<Question>? questions;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

 _fetchQuestions() async {
    // Use widget.questionsArray to access the data passed to QuestionnaireScreen
    if (widget.questionsArray != null) {
      print('questions are');
      print(widget.questionsArray);
      setState(() {
        questions = widget.questionsArray!
            .map((q) => Question.fromMap(q as Map<String, dynamic>))
            .toList();
      });
    } else {
      DocumentSnapshot docSnapshot = await firestoreService.getQuestionnaireData();
      if (docSnapshot.exists) {
        List<dynamic> questionsArray = docSnapshot.get('questions');
        setState(() {
          questions = questionsArray
              .map((q) => Question.fromMap(q as Map<String, dynamic>))
              .toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return SurveyPage(questions: questions!);
  }
}
