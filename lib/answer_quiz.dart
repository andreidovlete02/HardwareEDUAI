import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'quizzes.dart';
import 'quiz_results_page.dart';

class AnswerQuiz extends StatefulWidget {
  final List<QuizQuestion> questions;
  final int quizId;

  AnswerQuiz({required this.questions, required this.quizId});

  @override
  _AnswerQuizState createState() => _AnswerQuizState();
}

class _AnswerQuizState extends State<AnswerQuiz> {
  int _currentIndex = 0;
  List<String> _answers = [];
  final TextEditingController _controller = TextEditingController();
  late Timer _timer;
  int _timeRemaining = 30;

  @override
  void initState() {
    super.initState();
    _answers = List.filled(widget.questions.length, '');
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
    if (_answers[_currentIndex].isEmpty) {
      _answers[_currentIndex] = 'No answer'; // Mark as unanswered
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _controller.clear();
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
      if (_answers[i].toLowerCase() == widget.questions[i].correctAnswer!.toLowerCase()) {
        score++;
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId != null) {
      await _sendQuizGrade(widget.quizId, userId, score);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultsPage(
          score: score,
          totalQuestions: widget.questions.length,
          questions: widget.questions,
          selectedChoices: _answers,
        ),
      ),
    );
  }

  Future<void> _sendQuizGrade(int quizId, String userId, int score) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/grade_quiz'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'quiz_id': quizId, 'user_id': userId, 'score': score}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to send quiz grade');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Single word answer-based Quiz',
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
            TextField(
              controller: _controller,
              onChanged: (value) {
                _answers[_currentIndex] = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your Answer',
                labelStyle: TextStyle(color: Colors.lightBlue),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue),
                ),
              ),
            ),
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
