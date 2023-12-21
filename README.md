# ReiLife:

An mHealth Flutter project.

## Getting Started

Step 1: follow this tutorial on setting up Flutter and an editor: https://docs.flutter.dev/get-started/install 

Step 2: create a Firebase account using your [Google account](https://firebase.google.com/_d/signin?continue=https%3A%2F%2Ffirebase.google.com%2F%3Fgad_source%3D1%26gclid%3DCjwKCAiA-P-rBhBEEiwAQEXhH8j_MvM6HBU3U6-wnui5gVv7rAP5RaurnILUfYogCBMDqu6RM_PsFBoC1X4QAvD_BwE%26gclsrc%3Daw.ds&prompt=select_account)

Step 3: Set up [Flutterfire CLI](https://firebase.flutter.dev/docs/cli/?gclid=Cj0KCQiAj_CrBhD-ARIsAIiMxT9ssAjBnXvTHfhDygV_ZngMfzcRgEH8zEtf2poqmDtpy3AMJHKm7r4aArzlEALw_wcB&gclsrc=aw.ds) to connect Flutter app to the firebase in multiple platforms

Step 4: Configure firbase in [Flutter app](https://firebase.google.com/docs/flutter/setup?platform=ios)

Step 5:Create a [Flutter Firebase project](https://console.firebase.google.com/u/0/?fb_gclid=CjwKCAiA-P-rBhBEEiwAQEXhH8j_MvM6HBU3U6-wnui5gVv7rAP5RaurnILUfYogCBMDqu6RM_PsFBoC1X4QAvD_BwE&_gl=1*72g9gv*_ga*NjgwMTYwNDYzLjE2ODkwMzQyMDk.*_ga_CW55HF8NVT*MTcwMjkzMTE3My4yMi4xLjE3MDI5MzI2MjAuNDguMC4w) and follow the steps

Step 6 create [Firestore database](https://www.youtube.com/watch?v=2yNyiW_41H8)

## Adding Firebase Cloud Messaging listners:
To enable Flutter app to listen to any changes performed on the cloud Firestore DB (storing new data in particular), you need to add Firebase Cloud Messaging (FCM) functions that listen to these changes and send notifications accordingly. you can use Firebase Cloud Messaging (FCM) in combination with Firestore triggers set up in Firebase Cloud Functions. Here's how you can achieve this:

1. Setup Firebase in Your Flutter App\
Ensure Firebase is integrated into your Flutter app. This includes adding `firebase_core` and `firebase_messaging` dependencies in your pubspec.yaml.

    1.1. Add Firebase Dependencies\
    In your `pubspec.yaml`, include the following dependencies:
    ```
    dependencies:
      firebase_core: latest_version
      firebase_messaging: latest_version 
      ```
  
    1.2. Initialize Firebase\
    In your main.dart, initialize Firebase:

    ```
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      runApp(MyApp());
    }
    ```

2. Add Firebase Cloud Functions\
Use Firebase Cloud Functions to trigger a notification when new data is added to Firestore.

    2.1. Install Firebase CLI: Make sure you have Node.js installed, then install Firebase CLI via npm:

    ```
    npm install -g firebase-tools
    ```
    2.2. Initialize Cloud Functions\
    In your Firebase project directory, initialize Cloud Functions:

    ```
    firebase init functions
    ```

  

3. Create a Firestore Trigger\
In the functions directory of your Firebase project, create a trigger in `index.js`:

    ```
      const functions = require('firebase-functions');
      const admin = require('firebase-admin');
      admin.initializeApp();

      exports.sendNotificationOnNewData = functions.firestore
            .document('your_collection/{docId}')
            .onCreate((snap, context) => {
                // Construct your notification message
                const message = {
                    notification: {
                        title: 'New Data Added',
                        body: 'New data has been added to Firestore.'
                    },
                    topic: 'your_topic'
                };

                // Send a message to devices subscribed to the specified topic
                return admin.messaging().send(message);
            });
    ```

    Replace `your_collection/{docId}` with the path to your Firestore collection and `your_topic` with your chosen topic.

4. Deploy Your Cloud Function\
Deploy your function to Firebase:

    ```
    firebase deploy --only functions
    ```

5. Configure FCM in Flutter

      5.1. Request Permission (iOS):\
      For iOS, request notification permissions:
      
      ```
      FirebaseMessaging.instance.requestPermission();
      ```
    
      5.2. Subscribe to the Topic:\
      Subscribe to the same topic specified in your Cloud Function:
      ```
      FirebaseMessaging.instance.subscribeToTopic('your_topic');
      ```
      5.3. Handle Incoming Notifications:\
      Set up listeners in your Flutter app to handle incoming notifications:

      ```
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          // Handle your notification here
      });

      ```

 6. Test Your Setup\
 Add new data to your Firestore collection and ensure your Flutter app receives the notification.

**Note:**

Do not miss allowing your local firbase admin to read an write to the cloud Firestore by setting `allow read, write` to `true`. To do that, Firestore rules should look like the following:
```
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
``` 


