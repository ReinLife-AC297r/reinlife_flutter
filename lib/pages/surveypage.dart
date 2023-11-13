import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notificationpractice/pages/home_page.dart';
import './question_widget.dart';
import '../services/firestore.dart'; // assuming your FireService class is in this file
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SurveyPage extends StatefulWidget {
  final List<Question> questions;
  static const route = '/survey_page';

  SurveyPage({required this.questions});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final PageController _pageController = PageController();
  final FirestoreService _firestoreService = FirestoreService();
  final List<dynamic> _responses = []; // Use a List to store responses for checkin1

  void _handleResponse(int index) {
    // Add the current question's response to the responses list
    _responses.add(widget.questions[index].response);

    if (index < widget.questions.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Save all answers at once when the survey is completed
      _saveAllResponses();
    }
  }

  void _saveAllResponses() async {
    // Obtain the device token
    String deviceToken = await FirebaseMessaging.instance.getToken() ?? 'unknown_device';
    // Hash the device token using SHA-1
    var bytes = utf8.encode(deviceToken); // data being hashed
    var hashedToken = sha1.convert(bytes).toString();

    String currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // Get the current timestamp
    Timestamp currentTimestamp = Timestamp.fromDate(DateTime.now()); // For Firestore timestamp

    Map<String, dynamic> dataToSave = {
      'answers': _responses,
      'timestamp': currentTimestamp, // Adding the timestamp here
    };

    // Use the device token as the userId and current date as the documentId
    _firestoreService.saveAnswers(hashedToken, currentTime, dataToSave).then((_) {
      // Handle successful save
      // Navigate to the home page
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()), // Replace with your home page widget
            (_) => false, // This will remove all the routes below the HomePage from the stack
      );
    }).catchError((error) {
      // Handle any errors here
      // Show an error message or take appropriate action
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.questions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(child: QuestionWidget(
                  question: widget.questions[index],
                  onAnswered: (response) {
                    // Update the response in the question object
                    setState(() {
                      widget.questions[index].response = response;
                    });
                  },
                )),
                ElevatedButton(
                  onPressed: () => _handleResponse(index),
                  child: Text(index < widget.questions.length - 1 ? 'Next' : 'Submit'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
