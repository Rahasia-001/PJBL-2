import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/custom_navbar.dart';
import 'home_page.dart';
import 'quiz_result_page.dart';

class LevelTwoQuizPage extends StatefulWidget {
  const LevelTwoQuizPage({super.key});

  @override
  State<LevelTwoQuizPage> createState() => _LevelTwoQuizPageState();
}

class _LevelTwoQuizPageState extends State<LevelTwoQuizPage> {
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  bool isAnswered = false;
  int score = 0;
  int timeLeft = 25; // 25 detik untuk level sedang
  Timer? timer;

  final List<Map<String, dynamic>> questions = [
    {
      'question':
          'Zona laut yang masih dapat ditembus cahaya matahari disebut zona ...',
      'answers': ['Fotik', 'Afotik', 'Bathyal', 'Abyssal'],
      'correctAnswer': 0,
    },
    {
      'question':
          'Ekosistem perairan payau yang terbentuk di muara sungai disebut ...',
      'answers': ['Terumbu Karang', 'Estuari', 'Laguna', 'Delta'],
      'correctAnswer': 1,
    },
    {
      'question':
          'Hewan laut yang termasuk dalam kelompok Cephalopoda adalah ...',
      'answers': ['Kepiting', 'Ubur-ubur', 'Cumi-cumi', 'Bintang Laut'],
      'correctAnswer': 2,
    },
    {
      'question': 'Palung laut terdalam di dunia adalah Palung ...',
      'answers': ['Sunda', 'Mariana', 'Puerto Rico', 'Jawa'],
      'correctAnswer': 1,
    },
    {
      'question':
          'Hewan laut yang memiliki exoskeleton dari zat kitin adalah ...',
      'answers': ['Ikan Pari', 'Udang', 'Ubur-ubur', 'Paus'],
      'correctAnswer': 1,
    },
    {
      'question':
          'Proses perpindahan air laut akibat perbedaan suhu dan salinitas disebut ...',
      'answers': [
        'Arus Permukaan',
        'Arus Thermohaline',
        'Gelombang',
        'Pasang Surut'
      ],
      'correctAnswer': 1,
    },
    {
      'question':
          'Hewan laut yang dapat menghasilkan cahaya sendiri (bioluminescence) adalah ...',
      'answers': ['Hiu Putih', 'Ikan Badut', 'Cumi-cumi Raksasa', 'Ubur-ubur'],
      'correctAnswer': 3,
    },
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timeLeft = 25; // 25 detik untuk level sedang
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        // Auto move to next question when time's up
        if (!isAnswered) {
          nextQuestion();
        }
      }
    });
  }

  void selectAnswer(int index) {
    if (isAnswered) return;

    setState(() {
      selectedAnswerIndex = index;
      isAnswered = true;

      // Check if answer is correct
      if (index == questions[currentQuestionIndex]['correctAnswer']) {
        score += 10;
      }
    });

    timer?.cancel();

    // Auto move to next question after 2 seconds
    Future.delayed(const Duration(seconds: 1), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        isAnswered = false;
      });
      startTimer();
    } else {
      // Quiz finished, go to result page
      timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultPage(
            score: score,
            totalQuestions: questions.length,
            quizType: 'level2',
          ),
        ),
      );
    }
  }

  Color getAnswerColor(int index) {
    if (!isAnswered) {
      return Colors.transparent;
    }

    // If this is the correct answer, always show green
    if (index == questions[currentQuestionIndex]['correctAnswer']) {
      return Colors.green;
    }

    // If this is the selected wrong answer, show red
    if (index == selectedAnswerIndex) {
      return Colors.red;
    }

    return Colors.transparent;
  }

  Color getAnswerBorderColor(int index) {
    if (!isAnswered) {
      return Colors.white;
    }

    // If this is the correct answer, show green border
    if (index == questions[currentQuestionIndex]['correctAnswer']) {
      return Colors.green;
    }

    // If this is the selected wrong answer, show red border
    if (index == selectedAnswerIndex) {
      return Colors.red;
    }

    return Colors.white;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3B82F6),
              Color(0xFF6366F1),
              Color(0xFF1E1B4B),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header dengan progress
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Level 2: Explorer',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'Skor: $score',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress bar
                    Row(
                      children: [
                        Text(
                          'Soal ${currentQuestionIndex + 1}/${questions.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value:
                                  (currentQuestionIndex + 1) / questions.length,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF3B82F6),
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Question text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  currentQuestion['question'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Timer dengan circular progress
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: timeLeft / 25,
                      strokeWidth: 6,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        timeLeft > 10
                            ? const Color(0xFF3B82F6)
                            : timeLeft > 5
                                ? Colors.orange
                                : Colors.red,
                      ),
                    ),
                  ),
                  Text(
                    '$timeLeft',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Answer options
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: List.generate(
                      currentQuestion['answers'].length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildAnswerButton(
                          currentQuestion['answers'][index],
                          index,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 1) {
            timer?.cancel();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildAnswerButton(String answer, int index) {
    return InkWell(
      onTap: () => selectAnswer(index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: getAnswerColor(index).withOpacity(0.3),
          border: Border.all(
            color: getAnswerBorderColor(index),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          answer,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
