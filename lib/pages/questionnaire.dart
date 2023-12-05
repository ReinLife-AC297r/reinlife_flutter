import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notificationpractice/pages/question_widget.dart';
import 'package:notificationpractice/pages/surveypage.dart';

import '../services/firestore.dart';

class QuestionnaireScreen extends StatefulWidget {
  static const route = '/questionnaire_screen';
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
    }
    // else {
    //   DocumentSnapshot docSnapshot = await firestoreService.getQuestionnaireData();
    //   if (docSnapshot.exists) {
    //     List<dynamic> questionsArray = docSnapshot.get('questions');
    //     setState(() {
    //       questions = questionsArray
    //           .map((q) => Question.fromMap(q as Map<String, dynamic>))
    //           .toList();
    //     });
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (questions == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return SurveyPage(questions: questions!);
  }
}
