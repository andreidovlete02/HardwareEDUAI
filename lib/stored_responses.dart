import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StoredResponsesPage extends StatefulWidget {
  @override
  _StoredResponsesPageState createState() => _StoredResponsesPageState();
}

class _StoredResponsesPageState extends State<StoredResponsesPage> {
  List<dynamic> _responses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStoredResponses();
  }

  Future<void> _fetchStoredResponses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId != null) {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/get_ai_responses?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _responses = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch responses')),
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

  void _navigateToResponseDetails(Map<String, dynamic> response) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResponseDetailsPage(response: response),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stored AI Explanations',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _responses.isEmpty
          ? Center(child: Text('No responses found'))
          : ListView.builder(
        itemCount: _responses.length,
        itemBuilder: (context, index) {
          final response = _responses[index];
          return Card(
            margin: EdgeInsets.all(12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              leading: Icon(Icons.chat_bubble_outline, color: Colors.lightBlue, size: 30),
              title: Text(
                'AI Generated Report ${index + 1}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '📅 Created At: ${response['created_at']}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.lightBlue),
              onTap: () => _navigateToResponseDetails(response),
            ),
          );
        },
      ),
    );
  }
}

class ResponseDetailsPage extends StatelessWidget {
  final Map<String, dynamic> response;

  const ResponseDetailsPage({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Response Details'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📅 Created At: ${response['created_at']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.lightBlue),
              ),
              SizedBox(height: 20),
              ...response['explanations'].map<Widget>((explanation) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '❓ Question:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        explanation['question'],
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '🤖 AI Response:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        explanation['aiResponse'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
