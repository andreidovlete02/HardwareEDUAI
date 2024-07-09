import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'quizzes.dart';
import 'quiz_results_page.dart';

class SingleChoiceQuiz extends StatefulWidget {
  final List<QuizQuestion> questions;
  final int quizId;

  SingleChoiceQuiz({required this.questions, required this.quizId});

  @override
  _SingleChoiceQuizState createState() => _SingleChoiceQuizState();
}

class _SingleChoiceQuizState extends State<SingleChoiceQuiz> {
  int _currentIndex = 0;
  List<int?> _selectedChoices = [];
  late Timer _timer;
  int _timeRemaining = 30;

  @override
  void initState() {
    super.initState();
    _selectedChoices = List.filled(widget.questions.length, null);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _handleTimeout();
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _timeRemaining = 30;
    });
  }

  void _handleTimeout() {
    if (_selectedChoices[_currentIndex] == null) {
      _selectedChoices[_currentIndex] = -1; // Mark as unanswered
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _resetTimer();
      });
    } else {
      _showResults();
    }
  }

  Future<void> _showResults() async {
    _timer.cancel();
    int score = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      print('Question ${i + 1}: ${widget.questions[i].question}');
      print('Selected choice: ${_selectedChoices[i]}');

      if (widget.questions[i].type == QuestionType.answerBased) {
        if (_selectedChoices[i] != null && _selectedChoices[i].toString().toLowerCase() == widget.questions[i].correctAnswer!.toLowerCase()) {
          score++;
          print('Answer-based: Correct');
        } else {
          print('Answer-based: Incorrect');
        }
      } else if (widget.questions[i].type == QuestionType.singleChoice) {
        if (_selectedChoices[i] != null && widget.questions[i].correctOptions!.contains(widget.questions[i].options[_selectedChoices[i]!])) {
          score++;
          print('Single-choice: Correct');
        } else {
          print('Single-choice: Incorrect');
        }
      } else if (widget.questions[i].type == QuestionType.multipleChoice) {
        List<int> selectedAnswers = _selectedChoices[i] as List<int>;
        Set<String> correctAnswers = widget.questions[i].correctOptions!.map((e) => e).toSet();
        Set<String> userAnswers = selectedAnswers.map((idx) => widget.questions[i].options[idx]).toSet();
        if (userAnswers.containsAll(correctAnswers) && correctAnswers.containsAll(userAnswers)) {
          score++;
          print('Multiple-choice: Correct');
        } else {
          print('Multiple-choice: Incorrect');
        }
      }
    }

    print('Final score: $score');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId != null) {
      try {
        await _sendQuizGrade(widget.quizId, userId, score);
      } catch (e) {
        print('Failed to send quiz grade: $e');
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultsPage(
          score: score,
          totalQuestions: widget.questions.length,
          questions: widget.questions,
          selectedChoices: _selectedChoices,
        ),
      ),
    );
  }



  Future<void> _sendQuizGrade(int quizId, String userId, int score) async {
    final body = jsonEncode({
      'quiz_id': quizId,
      'user_id': userId,
      'score': score,
    });
    print('Sending quiz grade: $body');

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/grade_quiz'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 201) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to send quiz grade');
      }
    } catch (e) {
      print('Error sending quiz grade: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Single Choice Quiz',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentIndex + 1}/${widget.questions.length}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.lightBlue),
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.red),
                    SizedBox(width: 5),
                    Text(
                      '$_timeRemaining s',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.questions[_currentIndex].question,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.lightBlue),
              ),
            ),
            SizedBox(height: 20),
            ...widget.questions[_currentIndex].options.asMap().entries.map((entry) {
              int idx = entry.key;
              String option = entry.value;
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.lightBlue),
                ),
                child: RadioListTile<int>(
                  title: Text(option, style: TextStyle(color: Colors.lightBlue)),
                  value: idx,
                  groupValue: _selectedChoices[_currentIndex],
                  activeColor: Colors.lightBlue,
                  onChanged: (value) {
                    setState(() {
                      _selectedChoices[_currentIndex] = value;
                    });
                  },
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _nextQuestion,
                child: Text(
                  _currentIndex == widget.questions.length - 1 ? 'Finish Quiz' : 'Next Question',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
