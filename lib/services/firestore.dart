import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirestoreService{
  //get collection of notes
  final CollectionReference information =
      FirebaseFirestore.instance.collection('Experiment Information');

  // final CollectionReference questionnaireDocument =
  //   FirebaseFirestore.instance.collection('Questionnaires');

  final CollectionReference users =
    FirebaseFirestore.instance.collection('Users');

  // Fetch the first document from 'Experimental Information' (not real-time)
  Future<DocumentSnapshot> getFirstExperimentalInfo() async {
    QuerySnapshot snapshot = await information.limit(1).get();
    return snapshot.docs.first;
  }


  // Future<DocumentSnapshot> getQuestionnaireData() async {
  //   return await FirebaseFirestore.instance.collection('Questionnaires').doc('Questionnaire1auto').get();
  // }
  Future<Map<String, dynamic>?> getQuestionnaireDoc(int nId) async {
    try {

      // Query the 'Questionnaires' collection for documents where 'questionnaireId' matches 'nId'
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Questionnaires')
          .where('questionnaireId', isEqualTo: nId)
          .limit(1) // Assuming 'nId' is unique and there should only be one matching document
          .get();


      if (querySnapshot.docs.isNotEmpty) {
        // Convert the DocumentSnapshot to a Map and return
        DocumentSnapshot questionnaireDoc = querySnapshot.docs.first;
        return questionnaireDoc.data() as Map<String, dynamic>?;
      } else {
        print('No questionnaire found for the given nId.');
        return null;
      }
    } catch (e) {
      print('Error fetching questionnaire document: $e');
      return null;
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getNotificationHistory(String userId) {
    return _firestore.collection('Users').doc(userId).collection('notification record').snapshots();
  }

  Future<void> addTokenToUser() async {
    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      if (deviceToken == null) {
        deviceToken = 'unknown_device';
      }

      await _firestore.collection('Users').doc(deviceToken).set({
        'token': deviceToken
      }, SetOptions(merge: true));
      print("Token added to Firestore: $deviceToken"); // For debugging
    } catch (e) {
      print("Error adding token to Firestore: $e");
      // Handle the error appropriately
    }
  }

  //
  // Future<void> saveAnswers(String userId, String documentId, Map<String, dynamic> answers) async {
  //   DocumentReference documentRef = _firestore
  //       .collection('Users')
  //       .doc(userId)
  //       .collection('user answers')
  //       .doc(documentId);
  //
  //   return documentRef.set(answers, SetOptions(merge: true)).then((value) {
  //     print("Answers Saved");
  //   }).catchError((error) {
  //     print("Failed to save answers: $error");
  //   });
  // }
  Future<void> saveAnswers(String userId, String documentId, Map<String, dynamic> answers) async {
    // Reference to the 'Users' collection
    CollectionReference usersRef = _firestore.collection('Users');
    // Obtain the device token
    String deviceToken = await FirebaseMessaging.instance.getToken() ?? 'unknown_device';
    // Reference to the specific user's document
    DocumentReference userDocRef = usersRef.doc(userId);

    // Reference to the 'user answers' subcollection within the user's document
    DocumentReference documentRef = userDocRef.collection('user answers').doc(documentId);

    // Data to update in the user's document
    Map<String, dynamic> userData = {
      'token': deviceToken // Replace 'test value' with the actual data you want to store
    };

    // Start a batch write
    WriteBatch batch = _firestore.batch();

    // Set the answers in the 'user answers' document
    batch.set(documentRef, answers, SetOptions(merge: true));

    // Update the test field in the user's document
    batch.set(userDocRef, userData, SetOptions(merge: true));

    // Commit the batch write
    try {
      await batch.commit();
      print("Answers and user data saved");
    } catch (error) {
      print("Failed to save data: $error");
    }
  }


}



// //create
  // Future<void> addNote(String note){
  //   return notes.add({
  //     'note': note,
  //     'timestamp': Timestamp.now(),
  //   });
  // }
  // Future<void> addNoteWithSliderValue(String note, double? sliderValue) {
  //   return notes.add({
  //     'note': note,
  //     'sliderValue': sliderValue,
  //     'timestamp': Timestamp.now(),
  //   });
  // }

  // Future<void> updateNote(String docID, String newNote){
  //   return notes.doc(docID).update({
  //     'note': newNote,
  //     'timestamp': Timestamp.now(),
  //   });
  // }

  // Future<void> updateValue(String docID, double value){
  //   return notes.doc(docID).update({
  //     'sliderValue': value,
  //     'timestamp': Timestamp.now(),
  //   });
  // }

  // //read
  // Stream<QuerySnapshot> getNotesStream() {
  //   final notesStream =
  //       //notes.orderBy('timestamp', descending: true).snapshots();
  //       notes.snapshots();
  //   return notesStream;
  // }

  // Future<void> deleteNote(String docID){
  //   return notes.doc(docID).delete();
  // }
