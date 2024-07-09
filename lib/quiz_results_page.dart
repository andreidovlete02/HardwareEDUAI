import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'quizzes.dart';
import 'ai_response.dart';

class QuizResultsPage extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<QuizQuestion> questions;
  final List<dynamic> selectedChoices;
  final String apiKey = '';

  const QuizResultsPage({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.questions,
    required this.selectedChoices,
  }) : super(key: key);

  Future<String> _getAIExplanation(String message) async {
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

  Future<void> _sendQuizAnswersToAI(BuildContext context) async {
    List<Map<String, String>> wrongAnswers = [];
    List<Map<String, String>> explanations = [];
    for (int i = 0; i < questions.length; i++) {
      bool isCorrect = false;
      String selectedAnswer = '';
      String correctAnswer = '';

      if (questions[i].type == QuestionType.answerBased) {
        isCorrect = selectedChoices[i].toString().toLowerCase() ==
            questions[i].correctAnswer!.toLowerCase();
        selectedAnswer = selectedChoices[i];
        correctAnswer = questions[i].correctAnswer!;
      } else if (questions[i].type == QuestionType.singleChoice) {
        isCorrect = selectedChoices[i] != null &&
            questions[i].correctOptions!.contains(questions[i].options[selectedChoices[i]!]);
        selectedAnswer = selectedChoices[i] == null ? "Didn't select an answer" : questions[i].options[selectedChoices[i]!];
        correctAnswer = questions[i].correctOptions!.join(', ');
      } else {
        Set<int> selectedAnswers = selectedChoices[i] as Set<int>;
        Set<String> correctAnswers = questions[i].correctOptions!.map((e) => e).toSet();
        Set<String> userAnswers = selectedAnswers.map((idx) => questions[i].options[idx]).toSet();
        isCorrect = userAnswers.containsAll(correctAnswers) && correctAnswers.containsAll(userAnswers);
        selectedAnswer = selectedAnswers.isEmpty ? "Didn't select an answer" : selectedAnswers.map((idx) => questions[i].options[idx]).join(', ');
        correctAnswer = questions[i].correctOptions!.join(', ');
      }

      if (!isCorrect) {
        wrongAnswers.add({
          'question': questions[i].question,
          'selected_answer': selectedAnswer,
          'correct_answer': correctAnswer
        });
        final message = '''
          The question is: "${questions[i].question}"
          The selected answer was: "$selectedAnswer", which is incorrect.
          The correct answer is: "$correctAnswer".
          Explain why the selected answer is wrong.
          Which chapter should I read again from the following:
          Introduction to Computer Architecture
          Overview of Computer Systems
          Evolution of Computer Architecture
          Basic Terminology and Concepts
          Digital Logic and Microarchitecture
          Boolean Algebra and Logic Gates
          Combinational and Sequential Circuits
          Microarchitecture Basics
          Instruction Set Architecture (ISA)
          Types of ISAs: RISC vs. CISC
          Assembly Language Programming
          ISA Design Principles
          Processor Design
          Data Path and Control Unit Design
          Pipelining and Pipeline Hazards
          Superscalar and VLIW Architectures
          Memory Hierarchy
          Memory Technology and Organization
          Virtual Memory and Paging
          Input/Output and Storage Systems
          I/O Devices and Interfaces
          Storage Systems and Technologies
          Parallelism and Multicore Processors
          Parallel Programming Concepts
          Multicore and Manycore Architectures
          Synchronization and Concurrency
          Advanced Processor Architectures
          Flynn Taxonomy
          Vector Processors and GPUs
          Heterogeneous Computing
          Emerging Trends and Technologies
          Quantum Computing Basics
          Neuromorphic Computing
        ''';
        final aiResponse = await _getAIExplanation(message);
        explanations.add({
          'question': questions[i].question,
          'selected_answer': selectedAnswer,
          'aiResponse': aiResponse,
        });
      }
    }

    if (explanations.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AIResponsePage(explanations: explanations),
        ),
      );
    } else {
      _receiveAIResponse(context, 'No incorrect answers', 'All answers were correct. No explanations needed.');
    }
  }

  void _receiveAIResponse(BuildContext context, String question, String aiResponse) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AIResponsePage(explanations: [
          {'question': question, 'aiResponse': aiResponse}
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your score: $score out of $totalQuestions', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  bool isCorrect = false;
                  String selectedAnswer = '';
                  String correctAnswer = '';

                  if (questions[index].type == QuestionType.answerBased) {
                    isCorrect = selectedChoices[index].toString().toLowerCase() ==
                        questions[index].correctAnswer!.toLowerCase();
                    selectedAnswer = selectedChoices[index] == null ? "Didn't select an answer" : selectedChoices[index].toString();
                    correctAnswer = questions[index].correctAnswer!;
                  } else if (questions[index].type == QuestionType.singleChoice) {
                    isCorrect = selectedChoices[index] != null &&
                        questions[index].correctOptions!.contains(questions[index].options[selectedChoices[index]!]);
                    selectedAnswer = selectedChoices[index] == null ? "Didn't select an answer" : questions[index].options[selectedChoices[index]!];
                    correctAnswer = questions[index].correctOptions!.join(', ');
                  } else if (questions[index].type == QuestionType.multipleChoice) {
                    Set<int> selectedAnswers = selectedChoices[index] is Set<int>
                        ? selectedChoices[index]
                        : Set<int>.from(selectedChoices[index] as List<int>);
                    Set<String> correctAnswers = questions[index].correctOptions!.map((e) => e).toSet();
                    Set<String> userAnswers = selectedAnswers.map((idx) => questions[index].options[idx]).toSet();
                    isCorrect = userAnswers.containsAll(correctAnswers) && correctAnswers.containsAll(userAnswers);
                    selectedAnswer = selectedAnswers.isEmpty ? "Didn't select an answer" : selectedAnswers.map((idx) => questions[index].options[idx]).join(', ');
                    correctAnswer = questions[index].correctOptions!.join(', ');
                  }

                  return Card(
                    color: isCorrect ? Colors.green[100] : Colors.red[100],
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questions[index].question,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text('Your answer: $selectedAnswer'),
                          if (!isCorrect)
                            Text('Correct answer: $correctAnswer', style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/quizzes'));
                  },
                  child: Text('Back to Quizzes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _sendQuizAnswersToAI(context),
                  child: Text('Get Explanations from AI'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
