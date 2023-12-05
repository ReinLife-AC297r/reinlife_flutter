import 'package:flutter/material.dart';
import 'package:notificationpractice/pages/notificationhistory.dart';
import '../services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key); // <-- fixed this line

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();

  //text controller
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[500],
        title: FutureBuilder<DocumentSnapshot>(
          future: firestoreService.getFirstExperimentalInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              return Text(data['title']);
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            // Return a widget for the waiting state
            return CircularProgressIndicator();
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: firestoreService.getFirstExperimentalInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description: ${data['Description']}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.0),
                  Text('Duration: ${data['duration']}', style: TextStyle(fontSize: 16.0)),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      firestoreService.addTokenToUser();
                    },
                    child: Text('Register User'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                     onPressed: () {
                       //   Navigator.pushNamed(context, '/notification_screen');
                       // },
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) => NotificationHistoryScreen()),
                       );
                     },
                    child: Text('Click to see notification history'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          // Return a widget for the waiting state
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}