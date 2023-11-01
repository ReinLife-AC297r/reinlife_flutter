import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notificationpractice/api/firebase_api.dart';
import 'package:notificationpractice/firebase_options.dart';
import 'package:notificationpractice/pages/home_page.dart';
import 'package:notificationpractice/pages/newhome_page.dart';
import 'package:notificationpractice/pages/notifcation_page.dart';
import 'package:notificationpractice/pages/survey_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      navigatorKey: navigatorKey,
      routes:{
        '/notification_screen':(context) => const SurveypageWidget(),
      }
    );
  }
}

