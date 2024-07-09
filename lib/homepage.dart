import 'package:flutter/material.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'talktoai.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _funFact = "Loading fun fact..."; 
  String _architectureDefinition = "Loading definition..."; 

  final Color _selectedItemColor = Colors.lightBlue;
  final Color _unselectedItemColor = Colors.lightBlue.withOpacity(0.5);
  final Duration _animationDuration = Duration(milliseconds: 200);
  final String apiKey = '';

  @override
  void initState() {
    super.initState();
    _fetchFunFactAndDefinition();
  }

  Future<void> _fetchFunFactAndDefinition() async {
    String funFactPrompt = "Tell me a very short fun fact about computer architecture.";
    String definitionPrompt = "Provide a very short definition of a computer architecture related term.";

    List<Future<String>> fetchTasks = [
      _getAIResponse(funFactPrompt),
      _getAIResponse(definitionPrompt),
    ];

    try {
      List<String> results = await Future.wait(fetchTasks);
      setState(() {
        _funFact = results[0];
        _architectureDefinition = results[1];
      });
    } catch (e) {
      print('Error occurred while getting responses from AI: $e');
    }
  }

  Future<String> _getAIResponse(String message) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'user', 'content': message}
      ],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final aiResponse = responseBody['choices'][0]['message']['content'];
        return aiResponse;
      } else {
        print('Failed to get response from AI. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return 'Failed to get response from AI.';
      }
    } catch (e) {
      print('Error occurred while getting response from AI: $e');
      return 'Error occurred while getting response from AI.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'images/background.jpg',
                  fit: BoxFit.cover,
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Computer Architecture Fun Fact
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Fun Fact:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      _funFact,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Quick Knowledge:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      _architectureDefinition,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // AI Companion Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TalkToAI()),
                            );
                          },
                          child: Text('Your AI Companion'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlue.withOpacity(0.2),
        selectedItemColor: _selectedItemColor,
        unselectedItemColor: _unselectedItemColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          _buildBottomNavigationBarItem(Icons.home, 'Homepage', 0),
          _buildBottomNavigationBarItem(Icons.school, 'Courses', 1),
          _buildBottomNavigationBarItem(Icons.quiz, 'Quizzes', 2),
          _buildBottomNavigationBarItem(Icons.recommend, 'AI Responses', 3),
          _buildBottomNavigationBarItem(Icons.emoji_events, 'Achievements', 4),
          _buildBottomNavigationBarItem(Icons.person, 'Profile', 5),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: _animationDuration,
        decoration: BoxDecoration(
          color: _selectedIndex == index ? _selectedItemColor.withOpacity(0.5) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(8),
        child: Icon(icon),
      ),
      label: label,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigator
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, '/courses');
        break;
      case 2:
        Navigator.pushNamed(context, '/quizzes');
        break;
      case 3:
        Navigator.pushNamed(context, '/stored_responses');
        break;
      case 4:
        Navigator.pushNamed(context, '/achievements');
        break;
      case 5:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }
}
