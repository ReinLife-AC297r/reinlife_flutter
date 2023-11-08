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

exports.sendPushNotification = functions.firestore
    .document("Questionnaires/{qid}")
    .onCreate(async (snapshot, context) => {
      try {
        const msgData = snapshot.data();
        const usernames = msgData.usernames;
        // Fetch tokens for only the specified usernames
        const tokensSnapshot = await db.collection("Users")
            .where("username", "in", usernames)
            .get();

        // Collect the tokens
        const tokens = [];
        tokensSnapshot.forEach((doc) => {
          const userTokens = doc.data().token;
          if (Array.isArray(userTokens)) {
            tokens.push(...userTokens);
          } else {
            tokens.push(userTokens);
          }
        });
        if (tokens.length) {
          const multicastMessage = {
            notification: {
              title: "New activity for you",
              body: "You have a new questionnaire to fill out.",
            },
            data: {
              click_action: "FLUTTER_NOTIFICATION_CLICK",
              body: JSON.stringify(msgData),
            },
            tokens: tokens, // an array of tokens
          };
          const response = await admin.messaging()
              .sendEachForMulticast(multicastMessage);
          console.log("Successfully sent messages:", response.successCount);
          return {success: true};
        } else {
          console.log("No tokens found.");
          return {success: false, reason: "No tokens found."};
        }
      } catch (error) {
        console.error("Error encountered:", error);
        return {error: error.code};
      }
    });
