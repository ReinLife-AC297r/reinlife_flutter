import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../api/firebase_api.dart';
import '../firebase_options.dart';
import '../pages/home_page.dart';
import '../pages/newhome_page.dart';
import '../pages/notifcation_page.dart';
import '../pages/survey_page.dart';

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
      home: HomePageWidget(),
      navigatorKey: navigatorKey,
      routes:{
        '/notification_screen':(context) => const SurveypageWidget(),
      }
    );
  }
}

