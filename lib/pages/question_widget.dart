import 'package:flutter/material.dart';

class Question {
  final String questionId;
  final String questionText;
  final String questionType;
  final int? maxValue;
  final int? minValue;
  final List<String>? options;

  Question({
    required this.questionId,
    required this.questionText,
    required this.questionType,
    this.maxValue,
    this.minValue,
    this.options,
  });

  Question.fromMap(Map<String, dynamic> map)
      : questionId = map['questionId'],
        questionText = map['questionText'],
        questionType = map['questionType'],
        maxValue = map['maxValue'],
        minValue = map['minValue'],
        options = (map['options'] as List?)?.cast<String>();
}

class QuestionWidget extends StatelessWidget {
  final Question question;

  QuestionWidget({required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text('Question ${question.questionId}'),
        ),
        Expanded(child: _buildQuestionContent()),
      ],
    );
  }


  Widget _buildQuestionContent() {
    switch (question.questionType) {
      case 'Open Text':
        return TextField(decoration: InputDecoration(labelText: question.questionText));
      case 'Rating Scale':
        return Column(
          children: [
            Text(question.questionText),
            Slider(
              value: (question.minValue ?? 1).toDouble(),
              min: (question.minValue ?? 1).toDouble(),
              max: (question.maxValue ?? 5).toDouble(),
              divisions: (question.maxValue! - question.minValue!).toInt(),
              onChanged: (double value) {},
            ),
          ],
        );
      case 'Multiple Choice':
        return DropdownButton<String>(
          hint: Text(question.questionText),
          items: question.options!.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (_) {},
        );
      default:
        return SizedBox.shrink();
    }
  }
}
