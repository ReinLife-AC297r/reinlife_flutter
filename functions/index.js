const functions = require("firebase-functions");
const admin = require("firebase-admin");
const serviceAccount = require("./service.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

if (process.env.FUNCTIONS_EMULATOR) {
  admin.firestore().settings({
    host: "localhost:8080",
    ssl: false,
  });
}
const db = admin.firestore();

exports.sendUserNotification = functions.firestore
    .document("Users/{userId}/notification record/{notificationId}")
    .onCreate(async (snapshot, context) => {
      try {
        const notificationData = snapshot.data();
        const userId = context.params.userId;

        // Get the user"s token using userId
        const userDoc = await db.collection("Users").doc(userId).get();

        const userToken = userDoc.data().token;

        // Check if there is a token
        if (userToken) {
          const message = {
            notification: {
              title: notificationData.nTitle || "New Notification",
              body: notificationData.message || "You have a new notification.",
            },
            data: {
              click_action: "FLUTTER_NOTIFICATION_CLICK",
              body: JSON.stringify(notificationData),
            },
            token: userToken, // individual token
          };

          const response = await admin.messaging().send(message);
          console.log("Successfully sent message:", response);
          return {success: true};
        } else {
          console.log(`No token found for user ${userId}.`);
          return {success: false, reason: `No token found for user ${userId}.`};
        }
      } catch (error) {
        console.error("Error sending notification:", error);
        return {error: error.code, success: false};
      }
    });
