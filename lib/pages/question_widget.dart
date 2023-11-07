import 'package:flutter/material.dart';

class Question {
  final String questionId;
  final String questionText;
  final String questionType;
  final int? maxValue;
  final int? minValue;
  final List<String>? options;
  dynamic response; // Added to store user's response

  Question({
    required this.questionId,
    required this.questionText,
    required this.questionType,
    this.maxValue,
    this.minValue,
    this.options,
    this.response,
  });

  Question.fromMap(Map<String, dynamic> map)
      : questionId = map['questionId'],
        questionText = map['questionText'],
        questionType = map['questionType'],
        maxValue = map['maxValue'],
        minValue = map['minValue'],
        options = (map['options'] as List?)?.cast<String>();
}

class QuestionWidget extends StatefulWidget {
  final Question question;
  final Function(dynamic response) onAnswered;

  QuestionWidget({
    required this.question,
    required this.onAnswered,
  });

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  dynamic _currentResponse;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text('Question ${widget.question.questionId}'),
        ),
        Expanded(child: _buildQuestionContent()),
      ],
    );
  }

  Widget _buildQuestionContent() {
    switch (widget.question.questionType) {
      case 'Open Text':
        return TextField(
          decoration: InputDecoration(labelText: widget.question.questionText),
          onChanged: (value) {
            _currentResponse = value;
            widget.onAnswered(value);
          },
        );
      case 'Rating Scale':
      // Initialize _currentResponse if it's not already set
        _currentResponse ??= widget.question.minValue?.toDouble() ?? 1.0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.question.questionText), // Display the question text
            Slider(
              value: _currentResponse,
              min: widget.question.minValue?.toDouble() ?? 1,
              max: widget.question.maxValue?.toDouble() ?? 5,
              divisions: (widget.question.maxValue ?? 5) - (widget.question.minValue ?? 1),
              onChanged: (value) {
                setState(() {
                  _currentResponse = value;
                });
                widget.onAnswered(value);
              },
            ),
          ],
        );

      case 'Multiple Choice':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.question.questionText), // Display the question text
            DropdownButton<String>(
              value: _currentResponse, // this needs to be managed in the state for DropdownButton
              hint: Text('Select an option'), // Hint text for the DropdownButton
              items: widget.question.options!.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _currentResponse = newValue;
                });
                widget.onAnswered(newValue);
              },
            ),
          ],
        );

      default:
        return SizedBox.shrink();
    }
  }
}
