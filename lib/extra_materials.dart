import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExtraMaterialPage extends StatefulWidget {
  @override
  _ExtraMaterialPageState createState() => _ExtraMaterialPageState();
}

class _ExtraMaterialPageState extends State<ExtraMaterialPage> {
  final String apiKey = '';
  String? _selectedChapter;
  String? _chapterDetails;
  bool _isLoading = false;

  final List<String> chapters = [
    '📘 Introduction to Computer Architecture',
    '🖥️ Overview of Computer Systems',
    '🕰️ Evolution of Computer Architecture',
    '🔤 Basic Terminology in Computer Architecture',
    '🔢 Digital Logic and Microarchitecture',
    '🔗 Boolean Algebra and Logic Gates',
    '🔄 Combinational and Sequential Circuits',
    '🧩 Microarchitecture Basics',
    '📜 Instruction Set Architecture (ISA)',
    '⚙️ Types of ISAs: RISC vs. CISC',
    '💻 Assembly Language Programming',
    '📐 ISA Design Principles',
    '🛠️ Processor Design',
    '🔧 Data Path and Control Unit Design',
    '🚀 Pipelining and Pipeline Hazards',
    '🌀 Superscalar and VLIW Architectures',
    '📚 Memory Hierarchy',
    '💾 Memory Technology and Organization',
    '📂 Virtual Memory and Paging',
    '💽 Input/Output and Storage Systems',
    '🔌 I/O Devices and Interfaces',
    '📀 Storage Systems and Technologies',
    '🔀 Parallelism and Multicore Processors',
    '🤹 Parallel Programming Concepts',
    '🧠 Multicore and Manycore Architectures',
    '🔄 Synchronization and Concurrency',
    '🔬 Advanced Processor Architectures',
    '📊 Flynn Taxonomy',
    '🎮 Vector Processors and GPUs',
    '🌐 Heterogeneous Computing',
    '🔮 Emerging Trends and Technologies',
    '🔭 Quantum Computing Basics',
    '🧠 Neuromorphic Computing',
  ];

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

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      return 'Failed to load chapter details.';
    }
  }

  Future<void> _fetchChapterDetails(String chapter) async {
    setState(() {
      _isLoading = true;
      _chapterDetails = null;
    });

    final details = await _getAIExplanation('Provide a detailed and extended explanation about $chapter');

    setState(() {
      _chapterDetails = details;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Extra Materials'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedChapter,
              hint: Text('Select a chapter'),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.lightBlue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.lightBlue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.lightBlue),
                ),
                filled: true,
                fillColor: Colors.lightBlue[50],
              ),
              items: chapters.map((String chapter) {
                return DropdownMenuItem<String>(
                  value: chapter,
                  child: Text(chapter),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedChapter = newValue;
                });
                if (newValue != null) {
                  _fetchChapterDetails(newValue);
                }
              },
            ),
            SizedBox(height: 20),
            _isLoading
                ? Column(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                ),
                SizedBox(height: 10),
                Text(
                  '🤖 AI is thinking...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            )
                : _chapterDetails != null
                ? Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[50],
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    _chapterDetails!,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            )
                : Center(
              child: Text(
                '📖 Select a chapter to view details.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
