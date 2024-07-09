import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_picker/country_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = 'http://127.0.0.1:5000';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();
  String selectedCountry = 'N/A';
  String email = 'N/A';
  String userId = 'N/A';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userID') ?? 'N/A';
    email = prefs.getString('email') ?? 'N/A';

    final response = await http.get(Uri.parse('$baseUrl/profile/$userId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        usernameController.text = data['username'] ?? 'N/A';
        phoneController.text = data['phone_number'] ?? 'N/A';
        selectedCountry = data['country'] ?? 'N/A';
      });
    } else {
      setState(() {
        usernameController.text = 'N/A';
        phoneController.text = 'N/A';
        selectedCountry = 'N/A';
      });
    }
  }

  Future<void> _saveUserData() async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': usernameController.text,
        'phone_number': phoneController.text,
        'country': selectedCountry,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isEditing = false;
      });
    } else {
    }
  }

  Future<void> _sendFeedback() async {
    final response = await http.post(
      Uri.parse('$baseUrl/feedback'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'feedback': feedbackController.text,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        feedbackController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback sent successfully!')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send feedback')),
      );
    }
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country.name;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your user profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _saveUserData();
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('username');
              prefs.remove('userID');
              prefs.remove('email');
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('profile_picture.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              '$email ✉️',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.grey),
            isEditing
                ? TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
              ),
            )
                : Text(
              '${usernameController.text} 👤',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            isEditing
                ? TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                prefixIcon: Icon(Icons.phone),
              ),
            )
                : ListTile(
              leading: Icon(Icons.phone),
              title: Text(phoneController.text),
            ),
            isEditing
                ? ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Country'),
              trailing: Text(selectedCountry),
              onTap: _selectCountry,
            )
                : ListTile(
              leading: Icon(Icons.location_on),
              title: Text(selectedCountry),
            ),
            SizedBox(height: 20),
            Text(
              'Feedback 📝',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Provide your feedback',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _sendFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: Text('Send Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
