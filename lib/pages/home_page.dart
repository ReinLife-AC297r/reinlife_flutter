import 'package:flutter/material.dart';
import '../pages/survey_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double sleepValue = 0.5;
  double eatingValue = 0.5;
  double hydrationValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[500],
        title: Text("Our App"),
      ),
      body: ListView(
        children: [
          Container(
            height: 100,
            width: 100,
            child: Row(
              children: [
                Icon(Icons.bed),
                Text(" S L E E P"),
                Slider(
                  value: sleepValue,
                  onChanged: (value) {
                    setState(() {
                      sleepValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            width: 100,
            child: Row(
              children: [
                Icon(Icons.food_bank),
                Text(" E A T I N G"),
                Slider(
                  value: eatingValue,
                  onChanged: (value) {
                    setState(() {
                      eatingValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            width: 100,
            child: Row(
              children: [
                Icon(Icons.water_drop_outlined),
                Text(" H Y D R A T I O N"),
                Slider(
                  value: hydrationValue,
                  onChanged: (value) {
                    setState(() {
                      hydrationValue = value;
                    });
                  },
                ),
              ],
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
          ),
        ],
      ),
    );
  }
}
