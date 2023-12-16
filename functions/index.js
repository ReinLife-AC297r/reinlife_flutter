// Import Firebase functions and admin SDK modules
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const serviceAccount = require("./service.json");

// Initialize Firebase Admin SDK with service account credentials
// for privileged operations
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Configure Firestore for local emulation if running on the Firebase Emulator
if (process.env.FUNCTIONS_EMULATOR) {
  admin.firestore().settings({
    host: "localhost:8080",
    ssl: false,
  });
}

// Reference to the Firestore database
const db = admin.firestore();

// Cloud Function: sendUserNotification
// This function triggers on the creation of a new document in
// the specified Firestore path
exports.sendUserNotification = functions.firestore
    .document("Users/{userId}/notification record/{notificationId}")
    .onCreate(async (snapshot, context) => {
      try {
        // Extract notification data from the created document
        const notificationData = snapshot.data();
        // Extract the userId from the context parameters
        const userId = context.params.userId;

        // Fetch the user's document from Firestore to get their token
        const userDoc = await db.collection("Users").doc(userId).get();
        const userToken = userDoc.data().token;

        // Check if the user's token exists
        if (userToken) {
          // Define the message structure for FCM
          const message = {
            notification: {
              title: notificationData.nTitle || "New Notification",
              body: notificationData.message || "You have a new notification.",
            },
            data: {
              click_action: "FLUTTER_NOTIFICATION_CLICK",
              body: JSON.stringify(notificationData),
            },
            token: userToken, // Target specific user with their token
          };

          // Send the notification message using FCM
          const response = await admin.messaging().send(message);
          console.log("Successfully sent message:", response);
          return {success: true}; // Indicate successful sending
        } else {
          // Handle case where the user token is not found
          console.log(`No token found for user ${userId}.`);
          return {success: false, reason: `No token found for user ${userId}.`};
        }
      } catch (error) {
        // Log and return any errors encountered during execution
        console.error("Error sending notification:", error);
        return {error: error.code, success: false};
      }
    });
