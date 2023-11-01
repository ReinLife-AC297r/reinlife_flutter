import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notificationpractice/pages/notifcation_page.dart';
import 'package:notificationpractice/pages/survey_page.dart';
import '../services/firestore.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final FirestoreService firestoreService = FirestoreService();

  //text controller
  final TextEditingController textController = TextEditingController();

  // void openNoteBox() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       content: TextField(
  //         controller: textController,
  //       ),
  //       actions:[
  //         ElevatedButton(onPressed: (){
  //           // add a new note
  //           firestoreService.addNote(textController.text);
  //           textController.clear();
  //           Navigator.pop(context);
  //         },
  //             child: Text("Add"))
  //       ],
  //     ),
  //   );
  // }
  void openNoteBox() {
    TextEditingController textController = TextEditingController();
    TextEditingController sliderValueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,  // To constrain the AlertDialog size
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Goal',
              ),
            ),
            TextField(
              controller: sliderValueController,
              decoration: InputDecoration(
                labelText: 'Initial Slider Value',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              double? initialValue = double.tryParse(sliderValueController.text);

              if (initialValue != null) {
                // Here you can add the initial value for the slider to your Firestore (or handle it as needed)
                firestoreService.addNoteWithSliderValue(textController.text, initialValue);
              } else {
                  // Handle invalid slider value input, perhaps show a snackbar or toast message
              }


              textController.clear();
              sliderValueController.clear();
              Navigator.pop(context);
            },
            child: Text("Add"),
          )
        ],
      ),
    );
  }

  void updateNoteBox(String docID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions:[
          ElevatedButton(onPressed: (){
            // add a new note
            firestoreService.updateNote(docID,textController.text);
            textController.clear();
            Navigator.pop(context);
          },
              child: Text("Save"))
        ],
      ),
    );
  }


  //Map<String, double> sliderValues = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFCBB189),
        automaticallyImplyLeading: false,
        title: Text(
          'Our App',
          style: TextStyle(
            fontFamily: 'Outfit', // Ensure you have this font in your assets
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getNotesStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List notesList = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: notesList.length,
                    itemBuilder: (context, index) {
                      //get individual doc
                      DocumentSnapshot document = notesList[index];
                      //get note from each doc
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      String noteText = data['note'];
                      String docID = document.id;
                      double sliderValues = data['sliderValue'];
                      // If the slider value for this note hasn't been initialized, set it to a default.
                      // if (!sliderValues.containsKey(docID)) {
                      //   sliderValues[docID] ??= 0.0;
                      // }else{
                      //   slide
                      // }
                      //display as a container with the note text and a slider
                      return _buildContainer(Icons.favorite, noteText, sliderValues, docID, (newValue) {
                        setState(() {
                          // Update the state and eventually you might want to
                          // save the updated value back to Firestore
                          sliderValues = newValue;
                          firestoreService.updateValue(docID, newValue);
                        });
                      });
                    },
                  );
                } else {
                  return const Text("No notes..");
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SurveypageWidget(),
                ),
              );
            },
            child: Text('Go to Survey Page'),
            style: ElevatedButton.styleFrom(
              primary: Colors.amber[600], // Set the background color here
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildContainer(IconData icon, String label, double sliderValue, docID, ValueChanged<double> onChanged) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[200],
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon, color: Colors.grey, size: 24),
          SizedBox(width: 8), // For spacing
          Expanded(
            child: Text(label, style: TextStyle(color: Colors.black)),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
              child: Slider(
                activeColor: Color(0xFF678FC8),
                inactiveColor: Colors.grey,
                min: 0,
                max: 10,
                value: sliderValue,
                onChanged: onChanged,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings), // This is a gear-like icon for settings
            onPressed: () => updateNoteBox(docID),
          ),
          IconButton(
            icon: Icon(Icons.delete), // This is a gear-like icon for settings
            onPressed: () => firestoreService.deleteNote(docID),
          ),
        ],
      ),
    );
  }


}

