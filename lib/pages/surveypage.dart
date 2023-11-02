import 'package:flutter/material.dart';
import './question_widget.dart';

class SurveyPage extends StatefulWidget {
  final List<Question> questions;

  SurveyPage({required this.questions});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.questions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(child: QuestionWidget(question: widget.questions[index])),
                ElevatedButton(
                  onPressed: () {
                    if (index < widget.questions.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Handle submission or navigation after the last question
                    }
                  },
                  child: Text(index < widget.questions.length - 1 ? 'Next' : 'Submit'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
