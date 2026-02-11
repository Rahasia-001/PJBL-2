import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/custom_navbar.dart';
import 'home_page.dart';
import 'quiz_result_page.dart';

class AnimalQuizQuestionPage extends StatefulWidget {
  const AnimalQuizQuestionPage({super.key});

  @override
  State<AnimalQuizQuestionPage> createState() => _AnimalQuizQuestionPageState();
}

class _AnimalQuizQuestionPageState extends State<AnimalQuizQuestionPage> {
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  bool isAnswered = false;
  int score = 0;
  int timeLeft = 30;
  Timer? timer;

  final List<Map<String, dynamic>> questions = [
    {
      'question':
          'Hewan laut yang memiliki cangkang keras dan berjalan menyamping adalah ...',
      'answers': ['Kepiting', 'Lobster', 'Gurita', 'Ikan Pari'],
      'correctAnswer': 0,
    },
    {
      'question': 'Ikan yang hidup bersimbiosis dengan anemon laut adalah ...',
      'answers': ['Ikan Badut', 'Ikan Hiu', 'Ikan Pari', 'Ikan Tuna'],
      'correctAnswer': 0,
    },
    {
      'question': 'Mamalia laut terbesar di dunia adalah…',
      'answers': ['Kuda Laut', 'Lumba-lumba', 'Paus Biru', 'Hiu Paus'],
      'correctAnswer': 2,
    },
    {
      'question':
          'Hewan laut yang memiliki kemampuan regenerasi lengan adalah ...',
      'answers': ['Kepiting', 'Lobster', 'Bintang Laut', 'Udang'],
      'correctAnswer': 2,
    },
    {
      'question':
          'Hewan laut apa yang punya delapan lengan dan bisa menyemprotkan tinta saat merasa terancam?',
      'answers': ['Ubur - ubur', 'Gurita', 'Cumi - cumi', 'Bintang Laut'],
      'correctAnswer': 2,
    },
    {
      'question':
          'Hewan laut apa yang memiliki cangkang spiral dan sering dijadikan hiasan?',
      'answers': ['Kerang', 'Siput Laut', 'Kepiting', 'Lobster'],
      'correctAnswer': 1,
    },
    {
      'question':
          'Hewan laut apa yang memiliki tubuh transparan dan sering disebut "hantu laut"?',
      'answers': ['Ubur - ubur', 'Gurita', 'Cumi - cumi', 'Salamander Laut'],
      'correctAnswer': 0,
    },
    {
      'question':
          'Hewan laut apa yang memiliki kemampuan untuk berubah warna dan tekstur kulitnya?',
      'answers': ['Kepiting', 'Lobster', 'Cumi - cumi', 'Bintang Laut'],
      'correctAnswer': 2,
    },
    {
      'question':
          'Hewan laut apa yang memiliki tubuh pipih dan sering ditemukan di dasar laut?',
      'answers': ['Ikan Pari', 'Bintang Laut', 'Lumba-lumba', 'Paus Biru'],
      'correctAnswer': 0,
    },
    {
      'question':
          'Hewan laut apa yang memiliki cangkang keras dan sering dijadikan bahan makanan?',
      'answers': ['Kerang', 'Siput Laut', 'Kepiting', 'Lobster'],
      'correctAnswer': 2,
    },
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timeLeft = 30;
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

    // Auto move to next question after 1 seconds
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
            quizType: 'animal',
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
              Color(0xFF6366F1),
              Color(0xFF1A0088),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Soal ${currentQuestionIndex + 1}/${questions.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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
              ),

              const SizedBox(height: 20),

              // Question text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  currentQuestion['question'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
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
                      value: timeLeft / 30,
                      strokeWidth: 6,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        timeLeft > 10 ? Colors.green : Colors.red,
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
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
