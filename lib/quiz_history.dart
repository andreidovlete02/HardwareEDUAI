import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://127.0.0.1:5000';

class QuizHistoryPage extends StatefulWidget {
  final int quizId;
  final String title;

  QuizHistoryPage({required this.quizId, required this.title});

  @override
  _QuizHistoryPageState createState() => _QuizHistoryPageState();
}

class _QuizHistoryPageState extends State<QuizHistoryPage> {
  List<dynamic> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuizHistory();
  }

  Future<void> _fetchQuizHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/get_quiz_history?user_id=$userId&quiz_id=${widget.quizId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _history = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch quiz history')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz History'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _history.isEmpty
            ? Center(child: Text('No history found'))
            : ListView.builder(
          itemCount: _history.length,
          itemBuilder: (context, index) {
            final historyItem = _history[index];
            return Card(
              color: Colors.lightBlue[50],
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text('Attempt ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Score: ${historyItem['score']} / 5'),
                trailing: Text('Date: ${historyItem['date']}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
