import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'leaderboard.dart';
import 'single_choice_quiz.dart';
import 'multiple_choice_quiz.dart';
import 'answer_quiz.dart';
import 'quiz_results_page.dart';
import 'quiz_history.dart';
const String baseUrl = 'http://127.0.0.1:5000';

enum QuestionType { singleChoice, multipleChoice, answerBased }

class QuizQuestion {
  final QuestionType type;
  final String question;
  final List<String> options;
  final Set<String>? correctOptions;
  final String? correctAnswer;

  QuizQuestion({
    required this.type,
    required this.question,
    required this.options,
    this.correctOptions,
    this.correctAnswer,
  });
}

class QuizzesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Quizzes',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.lightBlue,
        ),
        body: Padding(
        padding: const EdgeInsets.all(20.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    SizedBox(height: 20),
    Expanded(
    child: ListView(
    children: [
    QuizTile(
    title: 'Quiz 1: Computer Basics',
    id: 1,
    description: 'Difficulty: Easy\nTest your knowledge about computer basics.',
    difficulty: 'Easy',
    questions: [
    QuizQuestion(
    type: QuestionType.singleChoice,
    question: 'Which of the following is a non-volatile memory?',
    options: ['RAM', 'Cache', 'ROM', 'Register'],
    correctOptions: {'ROM'},
    ),
    QuizQuestion(
    type: QuestionType.singleChoice,
    question: 'Which type of memory is typically used for the computer’s main memory?',
    options: ['DRAM', 'SRAM', 'EPROM', 'Flash Memory'],
    correctOptions: {'DRAM'},
    ),
    QuizQuestion(
    type: QuestionType.singleChoice,
    question: 'Which of the following is used to store frequently accessed data to speed up processing?',
    options: ['Cache Memory', 'RAM', 'Hard Drive', 'Optical Drive'],
    correctOptions: {'Cache Memory'},
    ),
    QuizQuestion(
    type: QuestionType.singleChoice,
    question: 'What type of memory is the fastest?',
    options: ['Cache', 'RAM', 'SSD', 'HDD'],
    correctOptions: {'Cache'},
    ),
    QuizQuestion(
    type: QuestionType.singleChoice,
    question: 'Which type of memory is used to store the BIOS settings?',
    options: ['SRAM', 'DRAM', 'ROM', 'Flash Memory'],
    correctOptions: {'Flash Memory'},
    ),
    ],
    ),
    QuizTile(
    title: 'Quiz 2: Computer Architecture',
    id: 2,
    description: 'Difficulty: Easy\nTest your knowledge about computer architecture.',
    difficulty: 'Easy',
    questions: [
    QuizQuestion(
    type: QuestionType.singleChoice,
    question: 'Which architecture uses separate memory for instructions and data?',
    options: ['Harvard Architecture', 'Von Neumann Architecture', 'RISC Architecture', 'CISC Architecture'],
    correctOptions: {'Harvard Architecture'},
    ),
    QuizQuestion(
    type: QuestionType.singleChoice,
    question: 'What does RISC stand for?',
    options: ['Reduced Instruction Set Computer', 'Rapid Instruction Set Computer', 'Reduced Information Set Computer', 'Rapid Information Set Computer'],
    correctOptions: {'Reduced Instruction Set Computer'},
    ),
    QuizQuestion(
    type: QuestionType.singleChoice,
    question: 'Which type of architecture is used by most modern computers?',
    options: ['Harvard Architecture', 'Von Neumann Architecture', 'RISC Architecture', 'CISC Architecture'],
    correctOptions: {'Von Neumann Architecture'},
    ),
    QuizQuestion(
    type: QuestionType.singleChoice,
    question: 'Which processor type typically has a smaller set of instructions?',
    options: ['RISC', 'CISC', 'Both', 'None'],
    correctOptions: {'RISC'},
    ),
    QuizQuestion(
    type: QuestionType.singleChoice,
    question: 'What is the main advantage of RISC architecture?',
    options: ['Simplicity and speed', 'Complexity and flexibility', 'Lower cost', 'Higher memory'],
    correctOptions: {'Simplicity and speed'},
    ),
    ],
    ),
    QuizTile(
    title: 'Quiz 3: Data Transfer',
    id: 3,
    description: 'Difficulty: Easy\nTest your knowledge about data transfer basics.',
    difficulty: 'Easy',
    questions: [
    QuizQuestion(
    type: QuestionType.singleChoice,
    question: 'What is the main purpose of a bus in a computer system?',
    options: ['To transfer data between components', 'To store data', 'To execute instructions', 'To manage power'],
    correctOptions: {'To transfer data between components'},
    ),
    QuizQuestion(
    type: QuestionType.singleChoice,
    question: 'Which type of bus is used to connect the CPU to memory?',
    options: ['Data Bus', 'Address Bus', 'Control Bus', 'Power Bus'],
    correctOptions: {'Address Bus'},
    ),
    QuizQuestion(
    type: QuestionType.singleChoice,
    question: 'What does DMA stand for in computer systems?',
    options: ['Direct Memory Access', 'Data Memory Access', 'Direct Memory Allocation', 'Data Management Access'],
    correctOptions: {'Direct Memory Access'},
    ),
    QuizQuestion(
    type: QuestionType.singleChoice,
    question: 'Which type of bus allows multiple devices to share the same communication path?',
    options: ['Serial Bus', 'Parallel Bus', 'Multiplexed Bus', 'Dedicated Bus'],
    correctOptions: {'Multiplexed Bus'},
    ),
    QuizQuestion(
    type: QuestionType.singleChoice,
    question: 'What is the primary role of the control bus in a computer system?',
    options: ['To carry control signals', 'To carry data signals', 'To carry address signals', 'To carry power signals'],
    correctOptions: {'To carry control signals'},
    ),
    ],
    ),
    QuizTile(
    title: 'Quiz 4: Computer Systems',
    id: 4,
    description: 'Difficulty: Medium\nTest your knowledge about computer systems.',
    difficulty: 'Medium',
    questions: [
    QuizQuestion(
    type: QuestionType.multipleChoice,
    question: 'The Program Counter register contains:',
    options: [
    'the address of the next instruction in memory',
    'the address of data fetched from memory',
    'the result of arithmetic operations performed',
    'the address from where the next instruction to be executed will be fetched',
    ],
    correctOptions: {'the address from where the next instruction to be executed will be fetched'},
    ),
    QuizQuestion(
    type: QuestionType.multipleChoice,
    question: 'The average time required to access a memory location and retrieve its contents is called:',
    options: [
    'latency time',
    'search time',
    'access time',
    'response time',
    ],
    correctOptions: {'access time'},
    ),
    QuizQuestion(
    type: QuestionType.multipleChoice,
    question: 'The type of memory used to increase the processing speed of a computer is:',
    options: [
    'RAM',
    'Cache',
    'BIOS',
    'ROM',
    ],
    correctOptions: {'Cache'},
    ),
    QuizQuestion(
    type: QuestionType.multipleChoice,
    question: 'The sum of -6 and -13 using two\'s complement representation is:',
    options: [
    '11101101',
    '11100001',
    '01010101',
    '10101011',
    ],
    correctOptions: {'11101101'},
    ),
      QuizQuestion(
        type: QuestionType.multipleChoice,
        question: 'The Harvard architecture has:',
        options: [
          'two buses, one for data and one for instructions',
          'two memories, one for data and one for instructions/program',
          'the major disadvantage that the data bus is more occupied than the instruction bus',
        ],
        correctOptions: {
          'two buses, one for data and one for instructions',
          'two memories, one for data and one for instructions/program',
          'the major disadvantage that the data bus is more occupied than the instruction bus',
        },
      ),
    ],
    ),
    QuizTile(
    title: 'Quiz 5: Computer Memory',
    id: 5,
    description: 'Difficulty: Medium\nTest your knowledge about computer memory.',
    difficulty: 'Medium',
    questions: [
    QuizQuestion(
    type: QuestionType.multipleChoice,
    question: 'Which technique helps the processor to run a program concurrently with input/output operations?',
    options: [
    'DMA',
    'program-controlled transfer',
    'none of the above',
    'interrupt-driven transfer',
    ],
    correctOptions: {'DMA'},
    ),
    QuizQuestion(
    type: QuestionType.multipleChoice,
    question: 'What is the largest data transfer unit in the memory of a computer system?',
    options: [
    'word',
    'block',
    'bit',
    'none of the above',
    ],
    correctOptions: {'block'},
    ),
    QuizQuestion(
    type: QuestionType.multipleChoice,
    question: 'For a given number of bits, the number of distinct values that can be represented is:',
    options: [
    'larger for unsigned integers',
    'larger for signed integers',
    'the same for signed and unsigned integers',
    ],
    correctOptions: {'larger for unsigned integers'},
    ),
    QuizQuestion(
    type: QuestionType.multipleChoice,
    question: 'The difference between CISC and RISC processors is:',
    options: [
    'CISC processors have a larger number of instructions',
    'RISC processors are riskier to use',
    'RISC processors execute an instruction in a single cycle',
    ],
      correctOptions: {'CISC processors have a larger number of instructions'},
    ),
      QuizQuestion(
        type: QuestionType.multipleChoice,
        question: 'A hardware interrupt is:',
        options: [
          'a synchronous/asynchronous signal from a peripheral that signals an event that needs to be handled by the processor',
          'the interruption of processor functioning due to a software bug',
          'the interruption of a connection circuit between two or more hardware components',
        ],
        correctOptions: {'a synchronous/asynchronous signal from a peripheral that signals an event that needs to be handled by the processor'},
      ),
    ],
    ),
      QuizTile(
        title: 'Quiz 6: Computer Architecture',
        id: 6,
        description: 'Difficulty: Medium\nTest your knowledge about computer architecture.',
        difficulty: 'Medium',
        questions: [
          QuizQuestion(
            type: QuestionType.multipleChoice,
            question: 'The Harvard architecture has:',
            options: [
              'two buses, one for data and one for instructions',
              'two memories, one for data and one for instructions/program',
              'a major disadvantage that the data bus is more occupied than the program bus',
            ],
            correctOptions: {'two buses, one for data and one for instructions'},
          ),
          QuizQuestion(
            type: QuestionType.multipleChoice,
            question: 'In synchronous buses:',
            options: [
              'transfer cycles are directly correlated with the CPU clock signal',
              'there is no direct connection between the evolution of a transfer cycle and the CPU clock signal',
              'they are constantly synchronized with asynchronous buses',
            ],
            correctOptions: {'transfer cycles are directly correlated with the CPU clock signal'},
          ),
          QuizQuestion(
            type: QuestionType.multipleChoice,
            question: 'A logic gate is:',
            options: [
              'a software program capable of performing a certain (logical) operation on electrical signals',
              'a connector that allows the retrieval of logical values from the user',
              'a hardware device capable of performing a certain (logical) operation on electrical signals',
            ],
            correctOptions: {'a hardware device capable of performing a certain (logical) operation on electrical signals'},
          ),
          QuizQuestion(
            type: QuestionType.multipleChoice,
            question: 'SR-latch memory circuits (S-Set, R-Reset):',
            options: [
              'Store a single binary value',
              'The outputs of the two logic gates used for realization are always complementary',
              'Continuously set and reset the stored numerical values',
            ],
            correctOptions: {'Store a single binary value'},
          ),
          QuizQuestion(
            type: QuestionType.multipleChoice,
            question: 'A combinational circuit:',
            options: [
              'Is a circuit made of logic gates, which has no memory, and its output depends only on the current input, NOT on the previous input or the current state of the circuit',
              'Is an electric circuit where information is combined randomly to obtain random values',
              'Is a circuit that, when transposed into a graph, does not contain cycles',
            ],
            correctOptions: {'Is a circuit made of logic gates, which has no memory, and its output depends only on the current input, NOT on the previous input or the current state of the circuit'},
          ),
        ],
      ),
      QuizTile(
        title: 'Quiz 7: Processor Types',
        id: 7,
        description: 'Difficulty: Medium\nTest your knowledge about processor types.',
        difficulty: 'Medium',
        questions: [
          QuizQuestion(
            type: QuestionType.multipleChoice,
            question: 'RISC processors differ from CISC processors in:',
            options: [
              'having a larger number of registers',
              'having more memory addressing modes',
              'having fewer memory addressing modes',
              'executing arithmetic and logic operations faster',
            ],
            correctOptions: {'having a larger number of registers'},
          ),
          QuizQuestion(
            type: QuestionType.multipleChoice,
            question: 'In the case of a full-adder circuit:',
            options: [
              'sum and carry can never both be 1 simultaneously',
              'the previous carry (carry-in) is considered as an input',
              'two half-adder circuits are used',
              'sum and carry can both be 1 simultaneously',
            ],
            correctOptions: {'the previous carry (carry-in) is considered as an input'},
          ),
          QuizQuestion(
            type: QuestionType.multipleChoice,
            question: 'An SR-latch memory circuit:',
            options: [
              'can be realized only with NAND gates',
              'can store a real value',
              'can store only a Boolean value',
            ],
            correctOptions: {'can store only a Boolean value'},
          ),
          QuizQuestion(
            type: QuestionType.multipleChoice,
            question: 'A microprocessor performs the following functions:',
            options: [
              'information manipulation (instructions, transmitted data, received data)',
              'execution of calculation operations',
              'control and supervision',
              'verifying the semantics of a software program',
            ],
            correctOptions: {
              'information manipulation (instructions, transmitted data, received data)',
              'execution of calculation operations',
              'control and supervision'
            },
          ),
          QuizQuestion(
            type: QuestionType.multipleChoice,
            question: 'The signals of a microprocessor are:',
            options: [
              'interrupt signals',
              'bus arbitration signals',
              'Internet connection verification signals',
            ],
            correctOptions: {'interrupt signals'},
          ),
        ],
      ),
      QuizTile(
        title: 'Quiz 8: Data Transfer',
        id: 8,
        description: 'Difficulty: Medium\nTest your knowledge about data transfer in computer systems.',
        difficulty: 'Medium',
        questions: [
          QuizQuestion(
            type: QuestionType.multipleChoice,
            question: 'In the case of a synchronous bus:',
            options: [
              'the occurrence of an event depends on the occurrence of the previous event',
              'all devices connected to the bus can read the synchronization line',
              'only input devices connected to the bus can read the synchronization line',
            ],
            correctOptions: {'all devices connected to the bus can read the synchronization line'},
          ),
          QuizQuestion(
            type: QuestionType.multipleChoice,
            question: 'In the x86 processor family, the instruction pointer register (IP – Instruction Pointer):',
            options: [
              'contains the address of the first instruction to be executed in a program',
              'cannot be modified or read directly',
              'indicates the displacement address starting from the address contained in the CS register (base address)',
            ],
            correctOptions: {'contains the address of the first instruction to be executed in a program'},
          ),
          QuizQuestion(
            type: QuestionType.multipleChoice,
            question: 'The role of the control unit within the CPU is:',
            options: [
              'Storing program instructions',
              'Decoding program instructions',
              'Performing logical operations',
              'All of the above',
            ],
            correctOptions: {'All of the above'},
          ),
          QuizQuestion(
            type: QuestionType.multipleChoice,
            question: 'Which of the following memory units communicate directly with the CPU?',
            options: [
              'Auxiliary memory',
              'Main memory',
              'Secondary memory',
              'None of the above',
            ],
            correctOptions: {'Main memory'},
          ),
          QuizQuestion(
            type: QuestionType.multipleChoice,
            question: 'A bus in a computer system consists of:',
            options: [
              'A set of parallel lines',
              'Accumulators',
              'Registers',
              'None of the above',
            ],
            correctOptions: {'A set of parallel lines'},
          ),
        ],
      ),
      QuizTile(
        title: 'Quiz 9: Computer Architecture Advanced 1',
        id: 9,
        description: 'Difficulty: Hard\nTest your advanced knowledge about computer architecture.',
        difficulty: 'Hard',
        questions: [
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'Explain the difference between pipelining and parallelism in CPU architectures.',
            options: [],
            correctAnswer: 'Overlap',
          ),
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'Describe the role of the control unit in a CPU.',
            options: [],
            correctAnswer: 'Directs',
          ),
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'What is cache coherence and why is it important in multi-core systems?',
            options: [],
            correctAnswer: 'Consistency',
          ),
        ],
      ),

      QuizTile(
        title: 'Quiz 10: Computer Architecture Advanced 2',
        id: 10,
        description: 'Difficulty: Hard\nTest your advanced knowledge about computer architecture.',
        difficulty: 'Hard',
        questions: [
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'What are the main differences between RISC and CISC architectures?',
            options: [],
            correctAnswer: 'Instructions',
          ),
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'Explain the concept of instruction-level parallelism (ILP).',
            options: [],
            correctAnswer: 'Overlap',
          ),
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'What is speculative execution and how does it improve CPU performance?',
            options: [],
            correctAnswer: 'Guessing',
          ),
        ],
      ),

      QuizTile(
        title: 'Quiz 11: Computer Architecture Advanced 3',
        id: 11,
        description: 'Difficulty: Hard\nTest your advanced knowledge about computer architecture.',
        difficulty: 'Hard',
        questions: [
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'What is the function of a memory management unit (MMU) in a CPU?',
            options: [],
            correctAnswer: 'Translation',
          ),
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'Describe the concept of branch prediction in modern processors.',
            options: [],
            correctAnswer: 'Guessing',
          ),
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'Explain the term "out-of-order execution" and its benefits.',
            options: [],
            correctAnswer: 'Reordering',
          ),
        ],
      ),

      QuizTile(
        title: 'Quiz 12: Computer Architecture Advanced 4',
        id: 12,
        description: 'Difficulty: Hard\nTest your advanced knowledge about computer architecture.',
        difficulty: 'Hard',
        questions: [
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'What is hyper-threading and how does it enhance CPU performance?',
            options: [],
            correctAnswer: 'Parallelization',
          ),
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'Explain the differences between SIMD and MIMD parallelism.',
            options: [],
            correctAnswer: 'Data',
          ),
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'What is the significance of the instruction pipeline in modern CPUs?',
            options: [],
            correctAnswer: 'Throughput',
          ),
        ],
      ),

      QuizTile(
        title: 'Quiz 13: Computer Architecture Advanced 5',
        id: 13,
        description: 'Difficulty: Hard\nTest your advanced knowledge about computer architecture.',
        difficulty: 'Hard',
        questions: [
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'What is a superscalar architecture and how does it differ from a scalar architecture?',
            options: [],
            correctAnswer: 'Multiple',
          ),
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'Describe the concept of virtual memory and its advantages.',
            options: [],
            correctAnswer: 'Illusion',
          ),
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'Explain the role of the arithmetic logic unit (ALU) in a CPU.',
            options: [],
            correctAnswer: 'Calculations',
          ),
        ],
      ),

      QuizTile(
        title: 'Quiz 14: Computer Architecture Advanced 6',
        id: 14,
        description: 'Difficulty: Hard\nTest your advanced knowledge about computer architecture.',
        difficulty: 'Hard',
        questions: [
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'What are the benefits of having a multi-core processor?',
            options: [],
            correctAnswer: 'Parallelism',
          ),
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'Explain the concept of register renaming in the context of avoiding hazards.',
            options: [],
            correctAnswer: 'Avoidance',
          ),
          QuizQuestion(
            type: QuestionType.answerBased,
            question: 'What is the significance of the fetch-decode-execute cycle in CPU operations?',
            options: [],
            correctAnswer: 'Process',
          ),
        ],
      ),
    ],
    ),
    ),
    ],
    ),
        ),
    );
  }
}Future<int> _fetchQuizAttempts(int quizId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userID');

  if (userId == null) {
    return 0;
  }

  final response = await http.get(
    Uri.parse('$baseUrl/get_quiz_attempts?user_id=$userId&quiz_id=$quizId'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['attempts'];
  } else {
    throw Exception('Failed to fetch quiz attempts');
  }
}

class QuizTile extends StatefulWidget {
  final String title;
  final String description;
  final int id;
  final List<QuizQuestion> questions;
  final String difficulty;

  const QuizTile({
    required this.title,
    required this.id,
    required this.description,
    required this.questions,
    required this.difficulty,
  });

  @override
  _QuizTileState createState() => _QuizTileState();
}

class _QuizTileState extends State<QuizTile> {
  int _quizAttempts = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuizAttempts();
  }

  Future<void> _loadQuizAttempts() async {
    try {
      final attempts = await _fetchQuizAttempts(widget.id);
      setState(() {
        _quizAttempts = attempts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getColor(widget.difficulty),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Pay attention!',
                  style: TextStyle(color: Colors.lightBlue),
                ),
                content: Text(
                  'You cannot go back to the previous question and when the time runs out the answer is marked as zero.',
                  style: TextStyle(color: Colors.lightBlue),
                ),
                backgroundColor: Colors.lightBlue[50],
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (widget.questions.first.type == QuestionType.singleChoice) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleChoiceQuiz(questions: widget.questions, quizId: widget.id),
                          ),
                        );
                      } else if (widget.questions.first.type == QuestionType.multipleChoice) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultipleChoiceQuiz(questions: widget.questions, quizId: widget.id),
                          ),
                        );
                      } else if (widget.questions.first.type == QuestionType.answerBased) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnswerQuiz(questions: widget.questions, quizId: widget.id),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Start Quiz',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                widget.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                'You took this quiz $_quizAttempts times',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaderboardPage(quizId: widget.id, title: widget.title),
                        ),
                      );
                    },
                    child: Text('View Leaderboard'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizHistoryPage(quizId: widget.id, title: widget.title),
                        ),
                      );
                    },
                    child: Text('View History'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> _fetchQuizAttempts(int quizId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId == null) {
      return 0;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/get_quiz_attempts?user_id=$userId&quiz_id=$quizId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['attempts'];
    } else {
      throw Exception('Failed to fetch quiz attempts');
    }
  }

  Color _getColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green[100]!;
      case 'Medium':
        return Colors.yellow[100]!;
      case 'Hard':
        return Colors.red[200]!;
      default:
        return Colors.white;
    }
  }
}


