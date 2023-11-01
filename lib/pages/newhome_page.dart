import 'package:flutter/material.dart';
import 'package:notificationpractice/pages/notifcation_page.dart';
import 'package:notificationpractice/pages/survey_page.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  double sliderValue1 = 5.0;
  double sliderValue2 = 5.0;
  double sliderValue3 = 5.0;

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
      body: SafeArea(
        top: true,
        child: ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          children: [
            _buildContainer(Icons.bed_outlined, " S l e e p         ", sliderValue1, (newValue) {
              setState(() => sliderValue1 = newValue);
            }),
            _buildContainer(Icons.food_bank, " E a t i n g        ", sliderValue2, (newValue) {
              setState(() => sliderValue2 = newValue);
            }),
            _buildContainer(Icons.water_drop, " H y d r a t i o n ", sliderValue3, (newValue) {
              setState(() => sliderValue3 = newValue);
            }),

            ElevatedButton(

              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NotificationPage(),
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
      ),
    );
  }

  Widget _buildContainer(IconData icon, String label, double sliderValue, ValueChanged<double> onChanged) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[200],
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon, color: Colors.grey, size: 24),
          Text(label, style: TextStyle(color: Colors.black)),
          Flexible(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(80, 0, 0, 0),
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
        ],
      ),
    );
  }
}

