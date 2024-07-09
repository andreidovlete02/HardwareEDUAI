import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:path/path.dart' as path;
import 'extra_materials.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HardwareEDU',
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
      ),
      home: CoursesPage(),
    );
  }
}

class CoursesPage extends StatefulWidget {
  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  String? userID;
  bool _isProgressLoaded = false;
  Timer? _progressTimer;
  List<Category> categories = [
    Category(
      name: 'Introduction to Computer Architecture',
      subcategories: [
        Subcategory(
          name: 'Overview of Computer Systems',
          courses: [
            Course(
              title: 'Introduction to Computer Systems',
              description: 'An overview of computer systems.',
              content: '''
        In this course, you will learn about the fundamental components and functions of computer systems. 
        Topics include hardware components such as the CPU, memory, and storage devices, as well as software components including operating systems and applications. 
        You will also explore how these components work together to perform various tasks, and understand the basics of computer architecture, data processing, and system performance.

        Key Topics Covered:
        1. Computer Hardware: Understanding the physical components of a computer system.
        2. Computer Software: Introduction to system software and application software.
        3. Data Storage: Types of storage devices and data management.
        4. Operating Systems: Functions and types of operating systems.
        5. Computer Networks: Basics of networking and communication protocols.
        6. System Performance: Factors affecting the performance of a computer system.

        **Video Summary**
        The video provides a comprehensive introduction to computer systems, explaining the difference between hardware and software, and how they interact to perform tasks. It covers the basic architecture of a computer, including the central processing unit (CPU), memory, input/output devices, and storage. The video also introduces operating systems, their role in managing hardware and software resources, and how they provide a user interface. Networking basics and the importance of security in computer systems are also discussed.

        This comprehensive overview will provide you with a solid foundation in computer systems, preparing you for more advanced topics in the field of computer science.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=qfUZBKDh9BY',
              videoUrl: 'videos/introduction.mp4',
              finalQuestion: 'What is a computer system?',
              correctAnswer: 'A combination of hardware and software that performs tasks.',
            ),
            Course(
              title: 'Evolution of Computer Architecture',
              description: 'History and evolution of computer architecture.',
              content: '''
        This course explores the history and evolution of computer architecture, tracing the development of computers from early mechanical machines to modern digital systems. Topics include:

        1. Early Computers: Understanding the origins and basic components of the first computers.
        2. Vacuum Tubes and Transistors: The transition from vacuum tubes to transistors and its impact on computing.
        3. Integrated Circuits: The introduction and significance of integrated circuits in computer architecture.
        4. Microprocessors: The evolution and importance of microprocessors in modern computing.
        5. Personal Computers: The rise of personal computers and their impact on society.
        6. Modern Architectures: An overview of contemporary computer architectures, including multi-core processors and cloud computing.

        **Video Summary**
        The video provides a comprehensive overview of the evolution of computer architecture, highlighting major milestones such as the transition from vacuum tubes to transistors, the development of integrated circuits, and the advent of microprocessors. It explains how these advancements have led to the powerful and efficient computer systems we use today.

        This course will give you a solid understanding of the key developments in computer architecture, preparing you for more advanced studies in computer science and engineering.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=o6V0zrOcbN4',
              videoUrl: 'videos/evolution.mp4',
              finalQuestion: 'Name a major milestone in computer architecture evolution.',
              correctAnswer: 'Microprocessors',
            ),
            Course(
              title: 'Basic Terminology and Concepts',
              description: 'Introduction to basic terminology and concepts in computer architecture.',
              content: '''
        This course introduces fundamental terminology and concepts essential to understanding computer architecture. Topics include:

        1. Central Processing Unit (CPU): Definition, components, and functions.
        2. Memory: Types of memory (RAM, ROM) and their roles.
        3. Input/Output Devices: Various devices and their functions.
        4. Buses: Data transfer methods within a computer.
        5. Storage: Differences between primary and secondary storage.
        6. Software: System software vs. application software.

        **Video Summary**
        The video provides an overview of basic computer architecture concepts, detailing the functions of the CPU, memory, input/output devices, and the importance of buses for data transfer. It explains the distinction between different types of memory and storage, and the roles of system and application software.

        This foundational knowledge is crucial for anyone beginning their study of computer science and engineering, setting the stage for more advanced topics.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=GRInNLx3Tug',
              videoUrl: 'videos/basic_terminology.mp4',
              finalQuestion: 'Define the term "CPU".',
              correctAnswer: 'Central Processing Unit',
            )
          ],
        ),
      ],
    ),
    Category(
      name: 'Digital Logic and Microarchitecture',
      subcategories: [
        Subcategory(
          name: 'Boolean Algebra and Logic Gates',
          courses: [
            Course(
              title: 'Boolean Algebra',
              description: 'Fundamentals of Boolean algebra.',
              content: '''
        This course covers the essential principles of Boolean algebra, which is crucial for digital logic design and computer science. Topics include:

        1. Boolean Variables: Introduction to binary variables representing true/false values.
        2. Basic Operations: AND, OR, NOT operations and their significance.
        3. Truth Tables: How to construct and interpret truth tables for different logic gates.
        4. Boolean Theorems: Key theorems and laws for simplifying Boolean expressions.
        5. Logic Gates: Implementation of Boolean functions using logic gates like AND, OR, NOT, NAND, NOR, XOR, and XNOR.
        6. Practical Applications: How Boolean algebra is applied in digital circuits, computing, and problem-solving.

        **Video Summary**
        The video provides a concise overview of Boolean algebra, focusing on core concepts such as Boolean variables, fundamental logical operations, and the construction of truth tables. It demonstrates the use of Boolean theorems to simplify expressions and explains the practical applications of Boolean algebra in designing digital circuits.

        This course aims to build a solid foundation in Boolean algebra, preparing you for more advanced topics in digital logic and computer architecture.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=cTjFy18SjRc',
              videoUrl: 'videos/boolean_algebra.mp4',
              finalQuestion: 'What is Boolean algebra used for?',
              correctAnswer: 'Logic',
            ),
            Course(
              title: 'Logic Gates',
              description: 'Introduction to logic gates and their functions.',
              content: '''
        This course provides a comprehensive introduction to logic gates, the fundamental building blocks of digital circuits. Topics include:

        1. Basic Logic Gates: Understanding AND, OR, and NOT gates.
        2. Universal Gates: Introduction to NAND and NOR gates.
        3. Combination Gates: Exploring XOR and XNOR gates.
        4. Truth Tables: How to create and interpret truth tables for each gate.
        5. Boolean Expressions: Representing logic gate functions with Boolean algebra.
        6. Practical Applications: Use of logic gates in designing digital circuits and systems.

        **Video Summary**
        The video explains the basic types of logic gates (AND, OR, NOT) and their functions, along with more complex gates like NAND, NOR, XOR, and XNOR. It covers the creation and interpretation of truth tables, and demonstrates how these gates are used to perform logical operations in digital circuits.

        This course will equip you with essential knowledge of logic gates, preparing you for more advanced studies in digital logic design and computer engineering.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=INEtYZqtjTo',
              videoUrl: 'videos/logic_gates.mp4',
              finalQuestion: 'What is a fundamental building block of digital circuits?',
              correctAnswer: 'Logic gates',
            ),
          ],
        ),
        Subcategory(
          name: 'Combinational and Sequential Circuits',
          courses: [
            Course(
              title: 'Combinational Logic Circuits',
              description: 'Introduction to combinational logic circuits in digital logic.',
              content: '''
        This course covers the basics of combinational logic circuits, essential components in digital systems. Topics include:

        1. Definition: Understanding what combinational logic circuits are.
        2. Basic Gates: Review of AND, OR, NOT, NAND, NOR, XOR, and XNOR gates.
        3. Combinational Circuits: Exploring circuits like adders, subtractors, multiplexers, demultiplexers, encoders, and decoders.
        4. Boolean Algebra: Applying Boolean algebra to design and simplify combinational circuits.
        5. Truth Tables: Creating and using truth tables for circuit design.
        6. Practical Applications: Implementing combinational circuits in real-world digital systems.

        **Video Summary**
        The video introduces combinational logic circuits, explaining their importance in digital systems. It covers various types of logic gates and how they are used to build circuits like adders, multiplexers, and encoders. The video also demonstrates the use of Boolean algebra and truth tables in designing and simplifying these circuits.

        This course aims to provide a solid foundation in combinational logic circuits, preparing you for more advanced topics in digital logic and system design.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=0XsGUFvWz0I&t=2s',
              videoUrl: 'videos/combinational_logic.mp4',
              finalQuestion: 'What is a fundamental component of combinational logic circuits?',
              correctAnswer: 'Gates',
            ),
            Course(
              title: 'Sequential Circuits',
              description: 'Introduction to sequential circuits in digital logic.',
              content: '''
        This course provides an overview of sequential circuits, which are crucial for memory and state retention in digital systems. Topics include:

        1. Definition: Understanding what sequential circuits are and how they differ from combinational circuits.
        2. Flip-Flops: Exploring basic flip-flops (SR, D, JK, T) and their functions.
        3. Registers: Introduction to registers and their uses.
        4. Counters: Types of counters (binary, decade) and their applications.
        5. State Diagrams: Creating and interpreting state diagrams for sequential circuits.
        6. Practical Applications: Implementing sequential circuits in real-world digital systems.

        **Video Summary**
        The video introduces sequential circuits, highlighting their importance in digital systems for tasks that require memory and state retention. It covers the basics of flip-flops, registers, and counters, and explains how to design and analyze these circuits using state diagrams.

        This course will equip you with the essential knowledge of sequential circuits, preparing you for more advanced studies in digital logic and computer engineering.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=AaN72s5WfOM',
              videoUrl: 'videos/sequential_circuits.mp4',
              finalQuestion: 'What is a fundamental component of sequential circuits?',
              correctAnswer: 'Flip flops',
            ),
          ],
        ),
        Subcategory(
          name: 'Microarchitecture Basics',
          courses: [
            Course(
              title: 'Microarchitecture',
              description: 'Introduction to the microarchitecture of computer systems.',
              content: '''
        This course provides an in-depth look at the microarchitecture of computer systems, focusing on the design and implementation of processor architectures. Topics include:

        1. Definition: Understanding what microarchitecture is and its importance in computer systems.
        2. Components: Exploring key components such as the ALU, registers, and control units.
        3. Pipelining: Introduction to pipelining and its role in enhancing processor performance.
        4. Instruction Set Architecture (ISA): The relationship between ISA and microarchitecture.
        5. Memory Hierarchy: Overview of cache, main memory, and their impact on performance.
        6. Performance Optimization: Techniques for optimizing microarchitectural performance.

        **Video Summary**
        The video provides a comprehensive overview of microarchitecture, explaining its fundamental components and how they work together to execute instructions. It covers important concepts like pipelining, the relationship between ISA and microarchitecture, and memory hierarchy, emphasizing their roles in optimizing processor performance.

        This course aims to build a strong foundation in microarchitecture, preparing you for advanced studies in computer architecture and system design.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=Swkij2QO2gA',
              videoUrl: 'videos/microarchitecture.mp4',
              finalQuestion: 'What is a fundamental component of microarchitecture?',
              correctAnswer: 'ALU',
            ),
          ],
        ),
      ],
    ),
    Category(
      name: 'Instruction Set Architecture (ISA)',
      subcategories: [
        Subcategory(
          name: 'Types of ISAs: RISC vs. CISC',
          courses: [
            Course(
              title: 'RISC vs CISC Architecture',
              description: 'Comparison of RISC and CISC architectures in computer organization.',
              content: '''
        This course explores the key differences and characteristics of Reduced Instruction Set Computer (RISC) and Complex Instruction Set Computer (CISC) architectures. Topics include:

        1. Definition: Understanding RISC and CISC architectures and their significance.
        2. Instruction Sets: Differences in instruction set complexity and execution.
        3. Performance: Comparing performance and efficiency between RISC and CISC.
        4. Design Philosophy: Exploring the design philosophies behind RISC and CISC.
        5. Examples: Real-world examples and applications of RISC and CISC processors.
        6. Pros and Cons: Advantages and disadvantages of each architecture.

        **Video Summary**
        The video provides an in-depth comparison of RISC and CISC architectures, discussing their instruction sets, performance, and design philosophies. It highlights the benefits and drawbacks of each architecture and provides examples of where they are used in real-world applications.

        This course aims to provide a thorough understanding of RISC and CISC architectures, preparing you for advanced studies in computer organization and architecture.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=ZW1gb3h-f9k',
              videoUrl: 'videos/risc_cisc.mp4',
              finalQuestion: 'Which architecture uses a simpler instruction set?',
              correctAnswer: 'RISC',
            )

          ],
        ),
        Subcategory(
          name: 'Assembly Language Programming',
          courses: [
            Course(
              title: 'Introduction to Assembly Language',
              description: 'Basics of assembly language programming.',
              content: '''
        This course introduces the fundamental concepts of assembly language programming, essential for understanding low-level computer operations. Topics include:

        1. Definition: Understanding what assembly language is and its purpose.
        2. Syntax: Basic syntax and structure of assembly language instructions.
        3. Instructions: Common assembly instructions and their functions.
        4. Registers: Role and use of registers in assembly language.
        5. Memory Access: Techniques for accessing and manipulating memory.
        6. Examples: Simple programs and examples in assembly language.

        **Video Summary**
        The video provides a comprehensive introduction to assembly language, covering its syntax, common instructions, and the use of registers. It also demonstrates basic techniques for memory access and manipulation, using simple examples to illustrate key concepts.

        This course aims to equip you with a foundational understanding of assembly language programming, preparing you for more advanced studies in computer architecture and low-level programming.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=0nZauIwn-xo',
              videoUrl: 'videos/assembly.mp4',
              finalQuestion: 'What is the primary purpose of assembly language?',
              correctAnswer: 'Low level programming',
            ),
          ],
        ),
        Subcategory(
          name: 'ISA Design Principles',
          courses: [
            Course(
              title: 'Instruction Set Architecture (ISA)',
              description: 'Overview of Instruction Set Architecture in computer organization.',
              content: '''
        This course provides an introduction to Instruction Set Architecture (ISA), a crucial component in computer organization and architecture. Topics include:

        1. Definition: Understanding what ISA is and its role in computer systems.
        2. Components: Key components of ISA, including instruction formats, addressing modes, and data types.
        3. Types of Instructions: Overview of data transfer, arithmetic, logic, control, and input/output instructions.
        4. ISA Design: Principles and factors influencing ISA design.
        5. Examples: Real-world examples of different ISAs such as x86 and ARM.
        6. Performance: How ISA affects the performance and efficiency of computer systems.

        **Video Summary**
        The video explains the concept of Instruction Set Architecture, its components, and types of instructions. It discusses the principles of ISA design and provides examples of different ISAs, highlighting how ISA impacts computer performance.

        This course aims to provide a solid understanding of ISA, preparing you for more advanced studies in computer architecture and system design.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=6fgbLOL7bis',
              videoUrl: 'videos/isa.mp4',
              finalQuestion: 'What does ISA stand for?',
              correctAnswer: 'Instruction Set Architecture',
            )
          ],
        ),
      ],
    ),
    Category(
      name: 'Processor Design',
      subcategories: [
        Subcategory(
          name: 'Data Path and Controller Design',
          courses: [
            Course(
              title: 'Datapath and Controller Design',
              description: 'Introduction to the design of datapaths and controllers in computer systems.',
              content: '''
    This course covers the principles and techniques involved in the design of datapaths and controllers, essential components of computer architecture. Topics include:
    
    1. Definition: Understanding the roles of datapaths and controllers in computer systems.
    2. Components: Key components of datapaths including ALUs, registers, and buses.
    3. Control Unit: Design and functions of control units.
    4. Data Flow: Understanding how data moves through a system.
    5. Design Techniques: Methods for designing efficient datapaths and control units.
    6. Examples: Practical examples and case studies of datapath and controller designs.
    
    **Video Summary** 🎥
    The video delves into the specifics of designing datapaths and controllers, explaining the importance of components such as ALUs, registers, and buses. It covers the design and function of control units and illustrates how data flows through a computer system.
    
    This course aims to provide a thorough understanding of datapath and controller design, preparing you for advanced topics in computer architecture and engineering.
''',
              youtubeUrl: 'https://www.youtube.com/watch?v=U156CywxXA0',
              videoUrl: 'videos/datapath_controller.mp4',
              finalQuestion: 'What is a key component of a datapath?',
              correctAnswer: 'ALU',
            )
          ],
        ),
        Subcategory(
          name: 'Pipelining and Pipeline Hazards',
          courses: [
            Course(
              title: 'CPU Pipelining',
              description: 'Introduction to the concept and implementation of CPU pipelining.',
              content: '''
        This course provides an in-depth look at CPU pipelining, a technique used to improve the performance of computer processors. Topics include:

        1. Definition: Understanding what CPU pipelining is and its significance.
        2. Stages of Pipelining: Detailed explanation of the different stages in a pipeline (fetch, decode, execute, memory access, write back).
        3. Pipeline Hazards: Types of hazards (data, control, structural) and how to handle them.
        4. Performance: How pipelining enhances CPU performance and throughput.
        5. Examples: Real-world examples and applications of pipelining in modern processors.

        **Video Summary**
        The video explains the fundamentals of CPU pipelining, covering the various stages involved in the process, the types of hazards that can occur, and strategies to mitigate these hazards. It emphasizes how pipelining increases the efficiency and speed of CPU operations.

        This course aims to provide a comprehensive understanding of CPU pipelining, preparing you for advanced studies in computer architecture and performance optimization.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=1U4v_2J0Qwk',
              videoUrl: 'videos/cpu_pipelining.mp4',
              finalQuestion: 'What technique improves CPU performance?',
              correctAnswer: 'Pipelining',
            ),
            Course(
              title: 'Pipeline Hazards',
              description: 'Understanding pipeline hazards in CPU architecture.',
              content: '''
        This course explores the different types of hazards that can occur in CPU pipelines and strategies to mitigate them. Topics include:

        1. Definition: Understanding what pipeline hazards are and why they occur.
        2. Structural Hazards: Causes and solutions.
        3. Data Hazards: Types (RAW, WAR, WAW) and mitigation techniques.
        4. Control Hazards: Branch prediction and other strategies to handle control hazards.
        5. Performance Impact: How hazards affect pipeline performance and overall CPU efficiency.
        6. Examples: Real-world examples of hazards in modern CPU pipelines and their resolutions.

        **Video Summary**
        The video provides a detailed explanation of pipeline hazards, including structural, data, and control hazards. It discusses the causes of these hazards and various techniques to mitigate their impact on CPU performance.

        This course aims to provide a comprehensive understanding of pipeline hazards, preparing you for advanced studies in computer architecture and performance optimization.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=t27kbXWP5GY',
              videoUrl: 'videos/pipeline_hazards.mp4',
              finalQuestion: 'What type of hazard does branch prediction mitigate?',
              correctAnswer: 'Control',
            ),
          ],
        ),
        Subcategory(
          name: 'Superscalar and VLIW Architectures',
          courses: [
            Course(
              title: 'Superscalar CPUs',
              description: 'Introduction to superscalar CPUs and their architecture.',
              content: '''
        This course delves into the architecture and functioning of superscalar CPUs, which utilize multiple parallel execution units to enhance performance. Topics include:

        1. Definition: Understanding what superscalar architecture is.
        2. Parallel Execution: How multiple instructions are executed in parallel.
        3. Execution Units: Types of execution units used in superscalar CPUs.
        4. Instruction Dispatch: Techniques for dispatching multiple instructions to different execution units.
        5. Performance: Benefits and challenges of superscalar architecture.
        6. Examples: Real-world examples of superscalar processors.

        **Video Summary**
        The video provides an overview of superscalar CPUs, explaining their ability to execute multiple instructions simultaneously through parallel execution units. It discusses the architecture, benefits, and challenges associated with superscalar design, highlighting real-world examples.

        This course aims to provide a solid understanding of superscalar CPU architecture, preparing you for advanced studies in computer architecture and performance optimization.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=4xhyXVyFMHw',
              videoUrl: 'videos/superscalar_cpu.mp4',
              finalQuestion: 'What type of architecture uses multiple parallel execution units?',
              correctAnswer: 'Superscalar',
            ),
            Course(
              title: 'VLIW Architecture',
              description: 'Introduction to Very Long Instruction Word (VLIW) architecture.',
              content: '''
        This course provides a detailed introduction to VLIW architecture, designed to exploit instruction-level parallelism (ILP). Topics include:

        1. Definition: Understanding what VLIW architecture is and its significance.
        2. Instruction Format: Structure and length of VLIW instructions.
        3. Parallel Execution: Techniques for executing multiple instructions in parallel.
        4. Compiler Role: The importance of the compiler in scheduling instructions.
        5. Performance: Benefits and challenges of VLIW in comparison to other architectures.
        6. Examples: Real-world examples of VLIW processors.

        **Video Summary**
        The video explains the fundamentals of VLIW architecture, including its ability to execute multiple instructions in parallel by leveraging long instruction words. It highlights the role of the compiler in managing instruction scheduling and discusses the performance benefits and complexities associated with VLIW.

        This course aims to provide a comprehensive understanding of VLIW architecture, preparing you for advanced studies in computer architecture and performance optimization.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=E9sK-q31IzU',
              videoUrl: 'videos/vliw_architecture.mp4',
              finalQuestion: 'What does VLIW stand for?',
              correctAnswer: 'Very Long Instruction Word',
            ),
          ],
        ),
      ],
    ),
    Category(
      name: 'Memory Hierarchy',
      subcategories: [
        Subcategory(
          name: 'Memory Technology and Organization',
          courses: [
            Course(
              title: 'Introduction to Memory and organization',
              description: 'Overview of memory systems in computer organization and architecture.',
              content: '''
        This course provides a comprehensive introduction to memory systems in computer architecture. Topics include:

        1. Memory Hierarchy: Understanding the different levels of memory hierarchy.
        2. Types of Memory: Overview of primary and secondary memory (RAM, ROM, cache, hard drives, SSDs).
        3. Memory Operations: Basic operations of memory, including read and write processes.
        4. Cache Memory: Functionality, types, and importance of cache memory.
        5. Virtual Memory: Concepts and implementation of virtual memory.
        6. Performance: How memory affects overall system performance.

        **Video Summary**
        The video covers the fundamental concepts of computer memory, detailing the various types of memory, the memory hierarchy, and the role of cache and virtual memory. It explains how memory operations are performed and how different types of memory contribute to system performance.

        This course aims to equip students with a thorough understanding of memory systems, preparing them for more advanced topics in computer organization and architecture.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=3a47WnQfnlE',
              videoUrl: 'videos/memory.mp4',
              finalQuestion: 'What type of memory is used for quick access by the CPU?',
              correctAnswer: 'Cache',
            ),
          ],
        ),
        Subcategory(
          name: 'Virtual Memory and Paging',
          courses: [
            Course(
              title: 'Virtual Memory and Paging',
              description: 'Understanding virtual memory and paging in computer systems.',
              content: '''
        This course provides an in-depth look at virtual memory, an essential concept in modern computer systems. Topics include:

        1. Definition: Understanding what virtual memory is and its purpose.
        2. Paging: Explanation of how paging works in virtual memory.
        3. Address Translation: The process of translating virtual addresses to physical addresses.
        4. Page Tables: Role and structure of page tables in virtual memory.
        5. Swapping: How swapping is used to manage memory.
        6. Performance: Impact of virtual memory on system performance and efficiency.

        **Video Summary**
        The video explains the concept of virtual memory, including how it allows computers to use more memory than physically available through paging and address translation. It covers the structure and function of page tables and the role of swapping in managing memory resources.

        This course aims to provide a comprehensive understanding of virtual memory, preparing students for advanced topics in computer organization and operating systems.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=2quKyPnUShQ',
              videoUrl: 'videos/virtual_memory.mp4',
              finalQuestion: 'What technique allows a computer to use more memory than physically available?',
              correctAnswer: 'Paging',
            ),
          ],
        ),
      ],
    ),
    Category(
      name: 'Input/Output and Storage Systems',
      subcategories: [
        Subcategory(
          name: 'I/O Devices and Interfaces',
          courses: [
            Course(
              title: 'Input/Output Interface',
              description: 'Understanding input/output interfaces in computer systems.',
              content: '''
        This course covers the fundamentals of input/output (I/O) interfaces, which are essential for communication between a computer and external devices. Topics include:

        1. Definition: Understanding what I/O interfaces are and their purpose.
        2. I/O Ports: Different types of I/O ports and their functions.
        3. I/O Operations: How data is transferred between the CPU and I/O devices.
        4. Addressing: Techniques for addressing I/O devices.
        5. Interrupts: Role of interrupts in I/O operations.
        6. Examples: Real-world examples of I/O interfaces and their applications.

        **Video Summary**
        The video explains the basics of I/O interfaces, including the different types of I/O ports and their functions. It covers how data is transferred between the CPU and I/O devices, the techniques for addressing I/O devices, and the role of interrupts in managing I/O operations.

        This course aims to provide a comprehensive understanding of I/O interfaces, preparing students for advanced topics in computer organization and architecture.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=U1OttjVU0Kw',
              videoUrl: 'videos/input_output.mp4',
              finalQuestion: 'What manages data transfer between CPU and I/O devices?',
              correctAnswer: 'IO interface',
            ),
          ],
        ),
        Subcategory(
          name: 'Storage Systems and Technologies',
          courses: [
            Course(
              title: 'Evolution of Storage Systems',
              description: 'Overview of the evolution of storage systems in computer technology.',
              content: '''
        This course provides a detailed exploration of the evolution of storage systems, from early mechanical devices to modern digital storage solutions. Topics include:

        1. Early Storage: History of early storage devices like punch cards and magnetic drums.
        2. Magnetic Storage: Evolution of magnetic tapes and hard disk drives.
        3. Optical Storage: Development of CDs, DVDs, and Blu-ray discs.
        4. Solid State Storage: Introduction and advancement of solid-state drives (SSDs).
        5. Cloud Storage: Emergence and impact of cloud storage solutions.
        6. Future Trends: Emerging technologies and future directions in storage systems.

        **Video Summary:**
        The video covers the comprehensive history of storage systems, highlighting significant milestones from early mechanical storage devices to the latest advancements in digital storage technology. It discusses the development of magnetic, optical, and solid-state storage, and explores the impact of cloud storage on modern data management.

        This course aims to provide a thorough understanding of the evolution of storage systems, preparing students for advanced studies in computer technology and data management.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=HzjpAh9Eeyg',
              videoUrl: 'videos/evolution_storage.mp4',
              finalQuestion: 'What is the latest major advancement in storage technology?',
              correctAnswer: 'Cloud storage',
            ),
          ],
        ),
        Subcategory(
          name: 'RAID and Storage Solutions',
          courses: [
            Course(
              title: 'RAID and Storage Solutions',
              description: 'Overview of RAID configurations and modern storage solutions.',
              content: '''
        This course provides an in-depth look at RAID (Redundant Array of Independent Disks) configurations and other modern storage solutions. Topics include:

        1. Introduction to RAID: Understanding the basic concept and purpose of RAID.
        2. RAID Levels: Detailed exploration of different RAID levels (RAID 0, RAID 1, RAID 5, RAID 6, RAID 10) and their characteristics.
        3. Benefits and Trade-offs: Advantages and disadvantages of various RAID configurations.
        4. Implementation: How to implement RAID in different storage systems.
        5. Modern Storage Solutions: Overview of contemporary storage technologies like SSDs, NAS, and SAN.
        6. Case Studies: Real-world applications and performance of RAID and modern storage solutions.

        **Video Summary**
        The video explains the fundamental concepts of RAID, covering different RAID levels and their respective benefits and trade-offs. It also discusses modern storage solutions such as SSDs, Network Attached Storage (NAS), and Storage Area Networks (SAN), providing insights into their practical applications and performance.

        This course aims to equip students with a comprehensive understanding of RAID configurations and modern storage solutions, preparing them for advanced studies in data storage and management.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=1h9sHu6jGmY',
              videoUrl: 'videos/raid.mp4',
              finalQuestion: 'What does RAID stand for?',
              correctAnswer: 'Redundant Array of Independent Disks',
            ),
          ],
        ),
      ],
    ),
    Category(
      name: 'Parallelism and Multicore Processors',
      subcategories: [
        Subcategory(
          name: 'Parallel Programming Concepts',
          courses: [
            Course(
              title: 'Parallel Programming Concepts',
              description: 'Introduction to the fundamental concepts of parallel programming.',
              content: '''
        This course provides a comprehensive introduction to parallel programming, a technique used to execute multiple computations simultaneously to improve performance. Topics include:

        1. Definition: Understanding what parallel programming is and its significance.
        2. Models of Parallelism: Overview of different models such as data parallelism, task parallelism, and pipeline parallelism.
        3. Parallel Architectures: Types of parallel architectures including multicore processors, distributed systems, and GPUs.
        4. Synchronization: Techniques for synchronizing parallel tasks to avoid conflicts.
        5. Tools and Libraries: Introduction to tools and libraries used in parallel programming (e.g., OpenMP, MPI, CUDA).
        6. Performance Optimization: Strategies for optimizing the performance of parallel programs.

        **Video Summary:**
        The video covers the basic concepts of parallel programming, explaining the different models and architectures used to achieve parallelism. It discusses synchronization techniques and introduces various tools and libraries that facilitate parallel programming, highlighting strategies for optimizing performance.

        This course aims to provide a solid foundation in parallel programming concepts, preparing students for advanced studies in computer science and high-performance computing.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=lH53yb7ZLAU',
              videoUrl: 'videos/ppc.mp4',
              finalQuestion: 'What technique is used to execute multiple computations simultaneously?',
              correctAnswer: 'Parallel programming',
            ),
          ],
        ),
        Subcategory(
          name: 'Multicore and Manycore Architectures',
          courses: [
            Course(
              title: 'Multicore Processor Architecture',
              description: 'Introduction to the architecture and functioning of multicore processors.',
              content: '''
        This course explores the architecture and operation of multicore processors, which are designed to enhance performance through parallelism. Topics include:

        1. Definition: Understanding what multicore processors are and their significance.
        2. Core Design: Overview of individual core designs and how they work together.
        3. Interconnects: Types and roles of interconnects in multicore processors.
        4. Parallel Processing: Techniques and benefits of parallel processing in multicore systems.
        5. Cache Coherence: Maintaining consistency of cache data across multiple cores.
        6. Performance: Factors affecting the performance and efficiency of multicore processors.

        **Video Summary:**
        The video explains the fundamentals of multicore processor architecture, covering core design, interconnects, parallel processing, and cache coherence. It highlights the performance benefits and challenges associated with multicore systems.

        This course aims to provide a comprehensive understanding of multicore processor architecture, preparing students for advanced studies in computer architecture and parallel computing.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=t6VF4HTd1gY',
              videoUrl: 'videos/mma.mp4',
              finalQuestion: 'What is a key benefit of multicore processors?',
              correctAnswer: 'Parallel processing',
            ),
            Course(
              title: 'Manycore Processor Architecture',
              description: 'Introduction to the architecture and functioning of manycore processors.',
              content: '''
        This course explores the architecture and operation of manycore processors, which integrate a large number of cores to achieve high parallelism. Topics include:

        1. Definition: Understanding what manycore processors are and their significance.
        2. Core Integration: How many cores are integrated and managed in a processor.
        3. Interconnects: Types and roles of interconnects in manycore processors.
        4. Parallel Processing: Techniques and benefits of extensive parallel processing.
        5. Scalability: Challenges and solutions for scaling manycore processors.
        6. Applications: Use cases and applications benefiting from manycore architecture.

        **Topic Summary**
        Manycore processors significantly increase the number of cores to enhance parallel computing capabilities. They require advanced interconnects and innovative scalability solutions to manage the extensive parallelism. Such processors are used in applications that demand high computational power and parallel processing efficiency.

        This course aims to provide a comprehensive understanding of manycore processor architecture, preparing students for advanced studies in computer architecture and parallel computing.
    ''',
              finalQuestion: 'What is the primary advantage of manycore processors?',
              correctAnswer: 'Parallelism',
            ),
          ],
        ),
        Subcategory(
          name: 'Concurrency, Threading, and Parallelism',
          courses: [
            Course(
              title: 'Concurrency, Threading, and Parallelism',
              description: 'Introduction to concurrency, threading, and parallelism in computing.',
              content: '''
        This course provides a comprehensive introduction to the concepts of concurrency, threading, and parallelism, which are essential for modern computing. Topics include:

        1. Definitions: Understanding concurrency, threading, and parallelism.
        2. Threading: Basics of threading and how it enables multitasking.
        3. Concurrency: Techniques for managing multiple tasks simultaneously.
        4. Parallelism: Strategies for executing multiple tasks at the same time.
        5. Synchronization: Methods for synchronizing threads to avoid conflicts.
        6. Performance: How these concepts impact the performance of software applications.

        **Video Summary:**
        The video explains the fundamentals of concurrency, threading, and parallelism, highlighting their differences and how they work together to improve software performance. It covers the basics of creating and managing threads, techniques for achieving concurrency, and strategies for parallel execution.

        This course aims to provide a solid foundation in concurrency, threading, and parallelism, preparing students for advanced topics in software development and computer science.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=olYdb0DdGtM',
              videoUrl: 'videos/concurrency.mp4',
              finalQuestion: 'What technique allows multiple tasks to be managed simultaneously?',
              correctAnswer: 'Concurrency',
            ),
          ],
        ),
      ],
    ),
    Category(
      name: 'Advanced Processor Architectures',
      subcategories: [
        Subcategory(
          name: 'Flynn’s Taxonomy',
          courses: [
            Course(
              title: 'Flynn’s Taxonomy',
              description: 'Overview of Flynn’s Taxonomy of computer architectures.',
              content: '''
        This course provides a comprehensive overview of Flynn’s Taxonomy, which classifies computer architectures based on instruction and data streams. Topics include:

        1. SISD (Single Instruction, Single Data): Understanding the basics of SISD architecture.
        2. SIMD (Single Instruction, Multiple Data): Exploring SIMD architecture and its applications.
        3. MISD (Multiple Instruction, Single Data): Characteristics and examples of MISD.
        4. MIMD (Multiple Instruction, Multiple Data): Detailed study of MIMD architecture and its significance.
        5. Applications: Real-world applications and use cases for each type of architecture.
        6. Performance: Comparing performance and efficiency across different architectures.

        **Video Summary:**
        The video explains Flynn’s Taxonomy, detailing the characteristics and differences between SISD, SIMD, MISD, and MIMD architectures. It discusses their applications and compares their performance and efficiency in various computing scenarios.

        This course aims to provide a solid understanding of Flynn’s Taxonomy, preparing students for advanced studies in computer architecture and parallel computing.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=KVOc6369-Lo',
              videoUrl: 'videos/flynns_taxonomy.mp4',
              finalQuestion: 'What does MIMD stand for?',
              correctAnswer: 'Multiple Instruction Multiple Data',
            ),
          ],
        ),
        Subcategory(
          name: 'Vector Processors and GPUs',
          courses: [
            Course(
              title: 'Vector Processors',
              description: 'Introduction to the characteristics, use, and examples of vector processors.',
              content: '''
        This course explores vector processors, which are designed to handle vector computations efficiently. Topics include:

        1. Definition: Understanding what vector processors are and their significance.
        2. Characteristics: Key features of vector processors, including their ability to process multiple data elements simultaneously.
        3. Vector Instructions: How vector instructions operate and their role in performance enhancement.
        4. Applications: Common use cases for vector processors in scientific computing, graphics, and other fields.
        5. Performance: How vector processors enhance performance for specific tasks.
        6. Examples: Real-world examples of vector processors and their implementations.

        **Video Summary**
        The video provides an in-depth look at vector processors, explaining their ability to process multiple data points simultaneously through vector instructions. It highlights their applications in high-performance computing fields and discusses the key features that contribute to their efficiency.

        This course aims to provide a comprehensive understanding of vector processors, preparing students for advanced studies in computer architecture and high-performance computing.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=I-r5pcPCe-M',
              videoUrl: 'videos/vector_processors.mp4',
              finalQuestion: 'What type of instructions do vector processors use?',
              correctAnswer: 'Vector instructions.',
            ),
            Course(
              title: 'GPU Architecture',
              description: 'Introduction to the architecture and functioning of Graphics Processing Units (GPUs).',
              content: '''
        This course provides a comprehensive introduction to GPU architecture, focusing on its design and applications in parallel processing. Topics include:

        1. Definition: Understanding what GPUs are and their primary functions.
        2. Architecture: Detailed overview of GPU architecture, including cores, memory hierarchy, and processing units.
        3. Parallel Processing: How GPUs handle parallel processing and the benefits over traditional CPUs.
        4. Applications: Common use cases for GPUs in graphics rendering, scientific computing, and machine learning.
        5. Performance: Techniques for optimizing GPU performance.
        6. Examples: Real-world examples of GPU applications and advancements.

        **Video Summary:**
        The video explains the fundamentals of GPU architecture, highlighting the design and functioning of various components such as cores and memory hierarchy. It discusses how GPUs excel in parallel processing, providing advantages in graphics rendering and computational tasks.

        This course aims to provide a solid understanding of GPU architecture, preparing students for advanced studies in computer graphics and high-performance computing.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=4Pi424VJgcE',
              videoUrl: 'videos/gpu_architecture.mp4',
              finalQuestion: 'What is a primary function of GPUs?',
              correctAnswer: 'Parallel processing',
            ),
          ],
        ),
        Subcategory(
          name: 'Heterogeneous Computing',
          courses: [
            Course(
              title: 'Heterogeneous Computing',
              description: 'Introduction to heterogeneous computing and its applications.',
              content: '''
        This course provides an overview of heterogeneous computing, which involves using multiple types of processors within a single system to improve performance. Topics include:

        1. Definition: Understanding what heterogeneous computing is and its significance.
        2. Processor Types: Different types of processors used in heterogeneous computing (e.g., CPUs, GPUs, FPGAs).
        3. Architecture: How heterogeneous systems are architected and managed.
        4. Applications: Common use cases and benefits of heterogeneous computing in various fields.
        5. Performance: Techniques for optimizing performance in heterogeneous environments.
        6. Examples: Real-world examples of heterogeneous computing implementations.

        **Video Summary**
        The video explains the concept of heterogeneous computing, highlighting the use of multiple processor types to optimize performance for different tasks. It covers the architecture, applications, and performance benefits of heterogeneous systems.

        This course aims to provide a comprehensive understanding of heterogeneous computing, preparing students for advanced studies in computer architecture and high-performance computing.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=9gvVyfiKTwc',
              videoUrl: 'videos/heterogeneous_computing.mp4',
              finalQuestion: 'What does heterogeneous computing involve?',
              correctAnswer: 'Multiple processor types',
            ),
          ],
        ),
      ],
    ),
    Category(
      name: 'Emerging Trends and Technologies',
      subcategories: [
        Subcategory(
          name: 'Quantum Computing Basics',
          courses: [
            Course(
              title: 'Introduction to Quantum Computation',
              description: 'Fundamentals of quantum computation and its principles',
              content: '''
        This course provides a foundational understanding of quantum computation, exploring its basic principles and potential applications. Topics include:

        1. Definition: Understanding what quantum computation is and its significance.
        2. Quantum Bits (Qubits): Basics of qubits and how they differ from classical bits.
        3. Superposition: Concept of superposition in quantum computing.
        4. Entanglement: Explanation of entanglement and its role in quantum computation.
        5. Quantum Gates: Introduction to quantum gates and how they manipulate qubits.
        6. Applications: Potential applications of quantum computing in various fields.

        **Video Summary:**
        The video explains the fundamental concepts of quantum computation, including qubits, superposition, entanglement, and quantum gates. It highlights how these principles differ from classical computing and explores potential applications.

        This course aims to provide a solid foundation in quantum computation, preparing students for advanced studies in quantum computing and related technologies.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=OVdruUk0-fM',
              videoUrl: 'videos/qc.mp4',
              finalQuestion: 'What is a fundamental unit of quantum computation?',
              correctAnswer: 'Qubit',
            ),
          ],
        ),
        Subcategory(
          name: 'Neuromorphic Computing',
          courses: [
            Course(
              title: 'Neuromorphic Computing',
              description: 'Introduction to neuromorphic computing and its significance for artificial intelligence.',
              content: '''
        This course explores the fundamentals of neuromorphic computing, an approach to designing computer systems inspired by the human brain. Topics include:

        1. Definition: Understanding what neuromorphic computing is and its importance.
        2. Brain Inspiration: How neuromorphic computing mimics the structure and function of the brain.
        3. Hardware: Overview of neuromorphic hardware, including specialized chips and architectures.
        4. Applications: Potential applications of neuromorphic computing in AI and other fields.
        5. Advantages: Benefits of neuromorphic computing over traditional computing methods.
        6. Future Trends: Emerging trends and future directions in neuromorphic computing.

        **Video Summary:**
        The video explains the concept of neuromorphic computing, highlighting its brain-inspired approach and potential applications in AI. It discusses the unique hardware used in neuromorphic systems and the advantages of this approach over traditional computing.

        This course aims to provide a comprehensive understanding of neuromorphic computing, preparing students for advanced studies in AI and computer architecture.
    ''',
              youtubeUrl: 'https://www.youtube.com/watch?v=TetLY4gPDpo',
              videoUrl: 'videos/neuromorphic.mp4',
              finalQuestion: 'What does neuromorphic computing mimic?',
              correctAnswer: 'Brain',
            ),
          ],
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserID().then((_) {
      _loadCourseProgress(); // Load progress immediately
      _startProgressTimer(); // Start the progress timer
    });
  }
  void _startProgressTimer() {
    const Duration refreshInterval = Duration(seconds: 5); // Example: reload every 5 minutes

    _progressTimer = Timer.periodic(refreshInterval, (timer) {
      if (mounted) {
        _loadCourseProgress(); // Reload course progress periodically
      }
    });
  }
  Future<void> _loadUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userID');
      print('Loaded userID: $userID'); // Debug
    });
  }

  Future<void> _loadCourseProgress() async {
    if (userID == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var category in categories) {
      for (var subcategory in category.subcategories) {
        for (var course in subcategory.courses) {
          String status = prefs.getString('$userID-${course.title}') ?? 'Not Started';
          setState(() {
            course.status = status;
          });
          print('Loaded progress for ${course.title}: $status'); // Debug
        }
      }
    }
  }

  Future<void> _saveCourseProgress(String courseTitle, String status) async {
    if (userID == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('$userID-$courseTitle', status);
    print('Saved progress for $courseTitle: $status'); // Debug
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Courses',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: userID == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Course Progress:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Stack(
                    children: [
                      Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Container(
                        height: 24,
                        width: MediaQuery.of(context).size.width * _calculateOverallProgress(),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            '${(_calculateOverallProgress() * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategoryWidget(
                  category: categories[index],
                  initiallyExpanded: categories[index].name == 'Computer Architecture',
                  saveCourseProgress: _saveCourseProgress,
                );
              },
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExtraMaterialPage()),
                  );
                },
                icon: Icon(Icons.book, color: Colors.white),
                label: Text('View Extra Materials'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  double _calculateOverallProgress() {
    int totalCourses = 0;
    int completedCourses = 0;

    for (var category in categories) {
      for (var subcategory in category.subcategories) {
        totalCourses += subcategory.courses.length;
        completedCourses += subcategory.courses
            .where((course) => course.status == 'Completed')
            .length;
      }
    }

    if (totalCourses == 0) return 0.0;
    return completedCourses / totalCourses;
  }
}

class CategoryWidget extends StatelessWidget {
  final Category category;
  final bool initiallyExpanded;
  final Future<void> Function(String, String) saveCourseProgress;

  const CategoryWidget({Key? key, required this.category, this.initiallyExpanded = false, required this.saveCourseProgress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      title: Text(
        category.name,
        style: TextStyle(color: Colors.lightBlue),
      ),
      children: category.subcategories
          .map((subcategory) => SubcategoryWidget(subcategory: subcategory, saveCourseProgress: saveCourseProgress))
          .toList(),
    );
  }
}

class SubcategoryWidget extends StatelessWidget {
  final Subcategory subcategory;
  final Future<void> Function(String, String) saveCourseProgress;

  const SubcategoryWidget({Key? key, required this.subcategory, required this.saveCourseProgress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        subcategory.name,
        style: TextStyle(color: Colors.lightBlue),
      ),
      children: subcategory.courses
          .map((course) => CourseWidget(course: course, saveCourseProgress: saveCourseProgress))
          .toList(),
    );
  }
}

class CourseWidget extends StatelessWidget {
  final Course course;
  final Future<void> Function(String, String) saveCourseProgress;

  const CourseWidget({Key? key, required this.course, required this.saveCourseProgress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        course.title,
        style: TextStyle(color: Colors.lightBlue),
      ),
      subtitle: Text(
        course.description,
        style: TextStyle(color: Colors.lightBlue),
      ),
      trailing: _buildStatusBadge(course.status),
      onTap: () async {
        if (course.status != 'Completed') {
          await saveCourseProgress(course.title, 'In Progress');
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CourseDetailsPage(course: course, saveCourseProgress: saveCourseProgress)),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Completed':
        color = Colors.green;
        break;
      case 'In Progress':
        color = Colors.orange;
        break;
      case 'Not Started':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
        break;
    }

    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class Category {
  final String name;
  final List<Subcategory> subcategories;

  Category({
    required this.name,
    required this.subcategories,
  });
}

class Subcategory {
  final String name;
  final List<Course> courses;

  Subcategory({
    required this.name,
    required this.courses,
  });
}

class Course {
  final String title;
  final String description;
  final String content;
  final String? youtubeUrl; 
  final String? pdfPath; 
  final String? videoUrl; 
  final String finalQuestion; 
  final String correctAnswer; 
  String status = 'Not Started';

  Course({
    required this.title,
    required this.description,
    required this.content,
    this.youtubeUrl,
    this.pdfPath,
    this.videoUrl,
    required this.finalQuestion,
    required this.correctAnswer,
  });
}

class CourseDetailsPage extends StatefulWidget {
  final Course course;
  final Future<void> Function(String, String) saveCourseProgress;

  const CourseDetailsPage({Key? key, required this.course, required this.saveCourseProgress}) : super(key: key);

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  bool _finalQuestionCorrect = false; 
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.course.videoUrl != null) {
      _videoController = VideoPlayerController.asset(widget.course.videoUrl!)
        ..initialize().then((_) {
          setState(() {});
          print('Video initialized: ${widget.course.videoUrl}');
        }).catchError((error) {
          print('Error initializing video: $error');
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateStatus(String newStatus) {
    setState(() {
      widget.course.status = newStatus;
      widget.saveCourseProgress(widget.course.title, newStatus);
    });
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🔵 Status: ${widget.course.status}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(widget.course.status),
                ),
              ),
              SizedBox(height: 16),
              Text(
                '📄 Description:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.course.description,
                style: TextStyle(color: Colors.lightBlue),
              ),
              SizedBox(height: 16),
              Text(
                '📚 Content:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.course.content,
                style: TextStyle(color: Colors.lightBlue),
              ),
              SizedBox(height: 16),
              if (_videoController != null && _videoController!.value.isInitialized) ...[
                Center(
                  child: Text(
                    '🎥 Watch Video:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
                VideoProgressIndicator(_videoController!, allowScrubbing: true),
                Center(
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          _videoController!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                          size: 36.0,
                          color: Colors.lightBlue,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_videoController!.value.isPlaying) {
                              _videoController!.pause();
                              print('Video paused');
                            } else {
                              _videoController!.play();
                              print('Video playing');
                            }
                          });
                        },
                      ),
                      Text(
                        'Play Video',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],
              if (widget.course.youtubeUrl != null) ...[
                Center(
                  child: Text(
                    '📺 Watch Video:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _launchURL(widget.course.youtubeUrl!),
                    child: Text('Open YouTube Video', style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
              Text(
                '❓ Final Question:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.course.finalQuestion,
                style: TextStyle(color: Colors.lightBlue),
              ),
              SizedBox(height: 8),
              TextField(
                onChanged: (value) {
                  if (value.toLowerCase() == widget.course.correctAnswer.toLowerCase()) {
                    _finalQuestionCorrect = true;
                  } else {
                    _finalQuestionCorrect = false;
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Enter your answer',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_finalQuestionCorrect) {
                      _updateStatus('Completed');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Your answer is correct!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Final question answer is incorrect. Try again.')),
                      );
                    }
                  },
                  child: Text('Finish Course'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      case 'Not Started':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;

  const PDFViewerScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Center(
        child: Text('PDF Viewer is currently not implemented'),
      ),
    );
  }
}
