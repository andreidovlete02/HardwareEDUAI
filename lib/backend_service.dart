import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:5000';

  Future<String> register(String email, String password) async {
    // Debug
    print('Data sent from Flutter: email=$email, password=$password');

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return response.body;
    } else if (response.statusCode == 409) {
      // Check if email already exists
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('error') &&
          responseBody['error'] == 'Email already exists') {
        throw Exception('Email already exists');
      }
    }
    throw Exception('Failed to register');
  }

  Future<String> login(String email, String password) async {
     print('Data sent from Flutter: email=$email, password=$password');

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to login');
    }
  }
}
