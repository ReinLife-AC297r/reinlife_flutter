import 'package:flutter/material.dart';
import '../pages/survey_page.dart';
import '../services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();

  //text controller
  final TextEditingController textController = TextEditingController();


  void openNoteBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions:[
          ElevatedButton(onPressed: (){
            // add a new note
            firestoreService.addNote(textController.text);
            textController.clear();
            Navigator.pop(context);
          },
              child: Text("Add"))
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[500],
        title: Text("Our App"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child:Icon(Icons.add),
      ),
    );
  }
}
