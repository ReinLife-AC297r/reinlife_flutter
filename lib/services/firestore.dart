import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  //get collection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  //create
  Future<void> addNote(String note){
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }
  Future<void> addNoteWithSliderValue(String note, double? sliderValue) {
    return notes.add({
      'note': note,
      'sliderValue': sliderValue,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> updateNote(String docID, String newNote){
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> updateValue(String docID, double value){
    return notes.doc(docID).update({
      'sliderValue': value,
      'timestamp': Timestamp.now(),
    });
  }

  //read
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        //notes.orderBy('timestamp', descending: true).snapshots();
        notes.snapshots();
    return notesStream;
  }

  Future<void> deleteNote(String docID){
    return notes.doc(docID).delete();
  }
}