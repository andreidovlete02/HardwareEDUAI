import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'backend_service.dart';
import 'homepage.dart';
import 'courses.dart';
import 'quizzes.dart';
import 'stored_responses.dart';
import 'profile.dart';
import 'achievement.dart';
import 'register.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => MyHomePage(title: 'Login'),
      '/homepage': (context) => HomePage(),
      '/courses': (context) => CoursesPage(),
      '/quizzes': (context) => QuizzesPage(),
      '/stored_responses': (context) => StoredResponsesPage(),
      '/profile': (context) => ProfilePage(),
      '/achievements': (context) => AchievementsPage(),
    },
  ));
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final String title;
  final AuthService authService = AuthService();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
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
              height: 400,
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
                      'Login',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue[900],
                        fontFamily: 'Archivo',
                      ),
                    ),
                    SizedBox(height: 20),
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextField(
                        decoration: InputDecoration(
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
                        style: TextStyle(fontFamily: 'Archivo'),
                        controller: usernameController,
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextField(
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
                        style: TextStyle(fontFamily: 'Archivo'),
                        controller: passwordController,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        String username = usernameController.text;
                        String password = passwordController.text;

                        if (username.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Email cannot be blank')),
                          );
                          return;
                        }

                        if (password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Password cannot be blank')),
                          );
                          return;
                        }

                        try {
                          var response = await authService.login(username, password);

                          if (response != null) {
                            print('Response body: $response');
                            var responseBody = jsonDecode(response);

                            if (responseBody.containsKey('userID')) {
                              String userID = responseBody['userID'].toString();
                              // Debug
                              print('UserID: $userID');
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString('userID', userID);
                              prefs.setString('email', username);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Logged in successfully')),
                              );
                              Navigator.pushReplacementNamed(context, '/homepage');
                            } else {
                              throw Exception('Invalid response from server');
                            }
                          } else {
                            throw Exception('Failed to login');
                          }
                        } catch (error) {
                          print(error);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Login failed. Check your credentials')),
                          );
                        }
                      },
                      child: Text('Login'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.lightBlue[800]),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                    SizedBox(height: 20), 
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen(authService: authService)),
                        );
                      },
                      child: Text("Don't have an account? Sign up"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                        foregroundColor: MaterialStateProperty.all(Colors.black),
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
