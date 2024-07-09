import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'backend_service.dart';
import 'main.dart';

class RegisterScreen extends StatelessWidget {
  final AuthService authService;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RegisterScreen({required this.authService});

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  bool _isEmailValid(String email) {
    // Email validation
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email) && email.length >= 5;
  }

  bool _isPasswordValid(String password) {
    // Password must be at least 8 characters long, contain at least one letter and one number
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
      appBar: AppBar(
        title: Center(child: Text('')),
        backgroundColor: Colors.transparent,
        elevation: 15,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SizedBox(
              width: 300,
              height: 500,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue[50],
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'example@email.com',
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.transparent,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[100]!),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[900]!),
                        ),
                      ),
                      controller: emailController,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.transparent,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[100]!),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[900]!),
                        ),
                      ),
                      controller: passwordController,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        filled: true,
                        fillColor: Colors.transparent,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[100]!),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[900]!),
                        ),
                      ),
                      controller: confirmPasswordController,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        // Get email and passwords from text fields
                        String email = emailController.text;
                        String password = passwordController.text;
                        String confirmPassword = confirmPasswordController.text;

                        if (!_isEmailValid(email)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Invalid email format')),
                          );
                          return;
                        }

                        if (!_isPasswordValid(password)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Password must be at least 8 characters long and contain at least one letter and one number')),
                          );
                          return;
                        }

                        if (password != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Passwords do not match')),
                          );
                          return;
                        }

                        try {
                          var response = await authService.register(email, password);

                          if (response != null) {
                            print('Response body: $response');
                            var responseBody = jsonDecode(response);

                            if (responseBody.containsKey('message') && responseBody['message'] == 'User registered successfully') {
                              print('User registered successfully');
                              Navigator.pushReplacementNamed(context, '/login');
                            } else {
                              throw Exception('Invalid response from server');
                            }
                          } else {
                            throw Exception('Failed to register');
                          }
                        } catch (error) {
                          print(error);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Registration failed: $error')),
                          );
                        }
                      },
                      child: Text('Register'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue[900]),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
