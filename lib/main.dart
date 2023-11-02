import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notificationpractice/api/firebase_api.dart';
import 'package:notificationpractice/firebase_options.dart';
import 'package:notificationpractice/pages/home_page.dart';
import 'package:notificationpractice/pages/newhome_page.dart';
import 'package:notificationpractice/pages/notifcation_page.dart';
import 'package:notificationpractice/pages/question_widget.dart';
import 'package:notificationpractice/pages/survey_page.dart';
import 'package:notificationpractice/pages/surveypage.dart';
import 'package:notificationpractice/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final navigatorKey = GlobalKey<NavigatorState>();

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
        if (settings.name == '/notification_screen') {
          return MaterialPageRoute(
            builder: (context) => QuestionnaireScreen(),
          );
        }
        // Handle other routes if needed
        return MaterialPageRoute(builder: (context) => Scaffold());
      },
    );
  }
}

class QuestionnaireScreen extends StatefulWidget {
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  List<Question>? questions;
  FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  _fetchQuestions() async {
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

  @override
  Widget build(BuildContext context) {
    if (questions == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return SurveyPage(questions: questions!);
  }
}