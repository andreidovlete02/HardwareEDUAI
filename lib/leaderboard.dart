import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://127.0.0.1:5000';

class LeaderboardPage extends StatefulWidget {
  final String title;
  final int quizId;

  const LeaderboardPage({
    Key? key,
    required this.title,
    required this.quizId,
  }) : super(key: key);

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  Future<List<Map<String, dynamic>>> _fetchLeaderboard() async {
    final response = await http.get(Uri.parse('$baseUrl/leaderboard/${widget.quizId}'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['leaderboard']);
    } else {
      throw Exception('Failed to load leaderboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          '${widget.title} - Leaderboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchLeaderboard(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available.'));
            } else {
              return Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var entry = snapshot.data![index];
                    late Color cardColor;

                    if (index == 0) {
                      cardColor = Colors.amber; // Gold for first place
                    } else if (index == 1) {
                      cardColor = Colors.grey[400]!; // Silver for second place
                    } else if (index == 2) {
                      cardColor = Colors.orange[300]!; // Copper for third place
                    } else {
                      cardColor = Colors.white; // Default white color for other places
                    }

                    return Card(
                      color: cardColor,
                      elevation: 4,
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                          'User: ${entry['email']}',
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                          'Score: ${entry['score']}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
