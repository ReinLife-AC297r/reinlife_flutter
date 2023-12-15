import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notificationpractice/pages/questionnaire.dart';
import '../api/firebase_api.dart';
import '../services/firestore.dart';
import 'package:notificationpractice/pages/message_page.dart';
import 'package:intl/intl.dart';

class NotificationHistoryScreen extends StatefulWidget {
  @override
  _NotificationHistoryScreenState createState() => _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String? deviceToken;

  @override
  void initState() {
    super.initState();
    _initializeDeviceToken();
  }

  void _initializeDeviceToken() async {
    deviceToken = await FirebaseMessaging.instance.getToken();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification History'),
      ),
      body: deviceToken == null
          ? CircularProgressIndicator()
          : StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getNotificationHistory(deviceToken!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              // Extract the data from the snapshot
              var notificationSnapshot = notifications[index];
              var notificationData = notificationSnapshot.data() as Map<String, dynamic>; // Cast the data to the correct type
              var nTitle = notificationData['nTitle'] ?? 'No title'; // Fetch the nTitle field
              var message = notificationData['message']; // Fetch the message field
              var time = notificationData['time']; // Fetch the time field
              String formattedTime = time != null ? formatFirestoreTimestamp(time) : 'Unknown time';
              var  nId = notificationData['nId'];
              var nType = notificationData['nType'];

              if (nType == 'questionnaire') {
                return Card(
                  child: ListTile(
                    title: Text(nTitle),
                    subtitle: Text(formattedTime), // Display the formatted time
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Use your method to fetch the questionnaire document based on nId
                      // Let's assume you have a function getQuestionnaireDoc(nId) that returns the doc
                      _firestoreService.getQuestionnaireDoc(nId).then((questionnaireDoc) {
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
                    },
                  ),
                  margin: EdgeInsets.all(8.0),
                );
              } else {
                // If nTitle is not 'new questionnaire!', display the title, message, and time
                return Card(
                  child: ListTile(
                    title: Text(nTitle),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Text(message ?? 'No message'), // Display the message
                        SizedBox(height: 4.0),
                        Text(formattedTime), // Display the formatted time
                      ],
                    ),
                   onTap: () {
                    navigatorKey.currentState?.pushNamed(
                    MessagePage.route, // Replace with the actual route name of your messages page
                    arguments: {
                      'message': message,
                      'time': formattedTime,
                      
                    },);
                   } 
                  ),
                  margin: EdgeInsets.all(8.0),
                );
              }
            },


          );
        },
      ),
    );
  }


String formatFirestoreTimestamp(Timestamp timestamp) {
   
    // Create a DateTime object from seconds and nanoseconds
    
    int seconds = timestamp.seconds ?? 0;
    int nanoseconds = timestamp.nanoseconds ?? 0; // Handle the case where '_nanoseconds' might be null
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000).add(Duration(microseconds: nanoseconds ~/ 1000));
    
    // Format the DateTime object to a string
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
    return formattedDate;
    
}

}