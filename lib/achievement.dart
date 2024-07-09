
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://127.0.0.1:5000';

class AchievementsPage extends StatelessWidget {
  Future<Map<String, dynamic>> fetchAchievements(String userID) async {
    final response = await http.get(Uri.parse('$baseUrl/achievements/$userID'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load achievements');
    }
  }

  Future<Map<String, dynamic>> getUserAchievements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';

    final achievements = await fetchAchievements(userID);

    return {
      'quizCount': achievements['quizCount'],
      'feedbackCount': achievements['feedbackCount'],
      'profileModified': achievements['profileModified'],
      'aiResponseCount': achievements['aiResponseCount'],
      'achievements': achievements['achievements'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getUserAchievements(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final userAchievements = snapshot.data!;
        final achievements = userAchievements['achievements'];

        final achievementsList = [
          {
            'title': 'First Quiz Done',
            'description': 'Completed your first quiz',
            'icon': Icons.check,
            'completed': userAchievements['quizCount'] >= 1,
          },
          {
            'title': 'AI Response Received',
            'description': 'Received a response from the AI',
            'icon': Icons.smart_toy,
            'completed': userAchievements['aiResponseCount'] >= 1,
          },
          {
            'title': 'Customize your profile',
            'description': 'Edited your profile',
            'icon': Icons.edit,
            'completed': userAchievements['profileModified'] >= 1,
          },
          {
            'title': 'First Sent Feedback',
            'description': 'Sent your first feedback',
            'icon': Icons.feedback,
            'completed': userAchievements['feedbackCount'] >= 1,
          },
          {
            'title': '3 Quizzes Done',
            'description': 'Completed 3 quizzes',
            'icon': Icons.format_list_numbered,
            'completed': userAchievements['quizCount'] >= 3,
          },
          {
            'title': '3 AI Responses',
            'description': 'Received 3 responses from the AI',
            'icon': Icons.smart_toy,
            'completed': userAchievements['aiResponseCount'] >= 3,
          },
          {
            'title': '10 Quizzes Done',
            'description': 'Completed 10 quizzes',
            'icon': Icons.quiz,
            'completed': userAchievements['quizCount'] >= 10,
          },
          {
            'title': 'All Quizzes Done',
            'description': 'Completed all 14 quizzes',
            'icon': Icons.star,
            'completed': userAchievements['quizCount'] >= 14,
          },
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Achievements',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.lightBlue,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: achievementsList.length,
                  itemBuilder: (context, index) {
                    final achievement = achievementsList[index];
                    final isCompleted = achievement['completed'] as bool;

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Icon(
                          achievement['icon'] as IconData,
                          color: isCompleted ? Colors.lightBlue : Colors.grey,
                        ),
                        title: Text(
                          achievement['title'] as String,
                          style: TextStyle(
                            color: isCompleted ? Colors.black : Colors.grey,
                          ),
                        ),
                        subtitle: Text(
                          achievement['description'] as String,
                          style: TextStyle(
                            color: isCompleted ? Colors.black : Colors.grey,
                          ),
                        ),
                        trailing: Icon(
                          isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                          color: isCompleted ? Colors.green : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[50],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      'Quizzes Completed: ${userAchievements['quizCount']} 📘',
                      style: TextStyle(color: Colors.lightBlue, fontSize: 18),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'AI Responses: ${userAchievements['aiResponseCount']} 🤖',
                      style: TextStyle(color: Colors.lightBlue, fontSize: 18),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Profile Edited: ${userAchievements['profileModified']} ✏️',
                      style: TextStyle(color: Colors.lightBlue, fontSize: 18),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Feedback Sent: ${userAchievements['feedbackCount']} 📨',
                      style: TextStyle(color: Colors.lightBlue, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
