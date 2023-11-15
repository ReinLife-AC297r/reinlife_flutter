import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<DocumentSnapshot> getQuestionnaireData() async {
    return await FirebaseFirestore.instance.collection('Questionnaires').doc('Questionnaire1auto').get();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

    // Reference to the specific user's document
    DocumentReference userDocRef = usersRef.doc(userId);

    // Reference to the 'user answers' subcollection within the user's document
    DocumentReference documentRef = userDocRef.collection('user answers').doc(documentId);

    // Data to update in the user's document
    Map<String, dynamic> userData = {
      'test': 'test value' // Replace 'test value' with the actual data you want to store
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
