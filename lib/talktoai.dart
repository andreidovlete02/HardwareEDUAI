import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TalkToAI extends StatefulWidget {
  @override
  _TalkToAIState createState() => _TalkToAIState();
}

class _TalkToAIState extends State<TalkToAI> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  final String apiKey = '';
  String email = "User";
  bool isLoading = false;
  late AnimationController _loadingController;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? 'User';
    });
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your AI Companion',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: <Widget>[
          _buildQuickQuestions(),
          Divider(height: 1.0),
          Flexible(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(8.0),
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          if (isLoading) _buildLoadingIndicator(),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return FadeTransition(
      opacity: _loadingController,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(width: 8.0),
            Text("AI is thinking..."),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              spreadRadius: 2.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration: InputDecoration.collapsed(
                    hintText: "Send a message",
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              color: Colors.lightBlue,
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickQuestions() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          _buildQuickQuestionButton("🖥️ What is the function of the CPU in a computer?"),
          SizedBox(height: 16.0),
          _buildQuickQuestionButton("💾 Explain the difference between RAM and ROM."),
          SizedBox(height: 16.0),
          _buildQuickQuestionButton("🔧 What is a motherboard?"),
        ],
      ),
    );
  }

  Widget _buildQuickQuestionButton(String question) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          _handleSubmitted(question);
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                question,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isUserMessage: true,
      email: email,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
      isLoading = true;
      message.animationController.forward();
      _loadingController.forward();
    });

    _sendMessageToAI(text);
  }

  Future<void> _sendMessageToAI(String message) async {
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
        await Future.delayed(Duration(seconds: 3));
        _receiveAIResponse(aiResponse);
      } else {
        print('Failed to get response from AI. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        _receiveAIResponse('Failed to get response from AI.');
      }
    } catch (e) {
      print('Error occurred while getting response from AI: $e');
      _receiveAIResponse('Error occurred while getting response from AI.');
    }
  }

  void _receiveAIResponse(String response) {
    ChatMessage message = ChatMessage(
      text: response,
      isUserMessage: false,
      email: email,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
      isLoading = false;
      message.animationController.forward();
      _loadingController.reverse();
    });
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  final String email;
  final AnimationController animationController;

  const ChatMessage({required this.text, required this.isUserMessage, required this.email, required this.animationController});

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: isUserMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (isUserMessage) ...[
              CircleAvatar(
                child: Text(email[0]),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      email,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[100],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'AI',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[100],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              CircleAvatar(
                child: Text('AI'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
