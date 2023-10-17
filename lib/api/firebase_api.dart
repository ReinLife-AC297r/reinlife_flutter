
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notificationpractice/main.dart';

class FirebaseApi{
  // create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async{
    //request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();
    // fetch the FCM token for this device
    final fCMToken =await _firebaseMessaging.getToken();
    //print the token (normally send to the server)
    print('Token: $fCMToken');

    // initialize further settings for push noti
    initPushNotifications();
  }
  //function to handle received messages
  void handleMessage(RemoteMessage? message){
    // if the message is null, do noting
    if (message == null) return;

    // navigate to a new screen when message is received and user taps notification
    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments:message
    );
  }

  //function to initialize foreground and backfround settings
  Future initPushNotifications() async{
    // handle notifications if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    // attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
