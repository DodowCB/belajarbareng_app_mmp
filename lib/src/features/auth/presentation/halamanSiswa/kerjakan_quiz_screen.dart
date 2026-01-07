import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/connectivity_provider.dart';

class KerjakanQuizScreen extends ConsumerStatefulWidget {
  final String quizId;
  final String judulQuiz;
  final int waktu;
  final Color color;

  const KerjakanQuizScreen({
    super.key,
    required this.quizId,
    required this.judulQuiz,
    required this.waktu,
    required this.color,
  });

  @override
  ConsumerState<KerjakanQuizScreen> createState() => _KerjakanQuizScreenState();
}

class _KerjakanQuizScreenState extends ConsumerState<KerjakanQuizScreen> {
  int _currentQuestionIndex = 0;
  Map<int, dynamic> _answers =
      {}; // Changed to dynamic to support String or List<String>
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = widget.waktu * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _submitQuiz();
      }
    });
  }

  Future<void> _loadQuestions() async {
    try {
      // Query quiz_soal by id_quiz
      final quizSoalSnapshot = await FirebaseFirestore.instance
          .collection('quiz_soal')
          .where('id_quiz', isEqualTo: int.tryParse(widget.quizId))
          .get();

      final questions = <Map<String, dynamic>>[];

      for (var doc in quizSoalSnapshot.docs) {
        final data = doc.data();
        final soalId = doc.id;
        final tipe = data['tipe'] ?? 'single'; // 'single' or 'multiple'

        // Get all jawaban from quiz_jawaban by id_soal
        final jawabanOptions = <String>[];
        final isCorrectMap =
            <String, bool>{}; // Map option letter to is_correct
        try {
          final jawabanSnapshot = await FirebaseFirestore.instance
              .collection('quiz_jawaban')
              .where('id_soal', isEqualTo: int.tryParse(soalId))
              .get();

          for (var jawabanDoc in jawabanSnapshot.docs) {
            final jawabanData = jawabanDoc.data();
            final jawaban = jawabanData['jawaban'] ?? '';

            jawabanOptions.add(jawaban);
          }

          // Map each option (A, B, C, D) to its is_correct value
          for (int i = 0; i < jawabanSnapshot.docs.length && i < 4; i++) {
            final jawabanData = jawabanSnapshot.docs[i].data();
            final isCorrect = jawabanData['is_correct'] ?? false;
            final optionLetter = String.fromCharCode(
              65 + i,
            ); // A=65, B=66, C=67, D=68
            isCorrectMap[optionLetter] = isCorrect;
          }
        } catch (e) {
          debugPrint('Error loading jawaban: $e');
        }

        // Ensure we have at least 4 options (pad with empty strings if needed)
        while (jawabanOptions.length < 4) {
          jawabanOptions.add('');
          final optionLetter = String.fromCharCode(
            65 + jawabanOptions.length - 1,
          );
          isCorrectMap[optionLetter] = false;
        }

        questions.add({
          'id': soalId,
          'pertanyaan': data['pertanyaan'] ?? '',
          'tipe': tipe,
          'opsi_a': jawabanOptions.isNotEmpty ? jawabanOptions[0] : '',
          'opsi_b': jawabanOptions.length > 1 ? jawabanOptions[1] : '',
          'opsi_c': jawabanOptions.length > 2 ? jawabanOptions[2] : '',
          'opsi_d': jawabanOptions.length > 3 ? jawabanOptions[3] : '',
          'is_correct_map': isCorrectMap, // Map of option letter to is_correct
        });
      }

      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading questions: $e')));
      }
    }
  }

  void _submitQuiz() {
    _timer?.cancel();

    int correctAnswers = 0;
    for (var i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      final userAnswer = _answers[i];
      final isCorrectMap = question['is_correct_map'] as Map<String, dynamic>;
      final tipe = question['tipe'] ?? 'single';

      if (tipe == 'single') {
        // For single answer, check if the selected option has is_correct = true
        if (userAnswer is String) {
          final isCorrect = isCorrectMap[userAnswer] ?? false;
          if (isCorrect == true) {
            correctAnswers++;
          }
        }
      } else {
        // For multiple answer, check if all selected options have is_correct = true
        // and all options with is_correct = true are selected
        if (userAnswer is List) {
          final userAnswerSet = Set<String>.from(userAnswer.cast<String>());
          final correctOptionsSet = <String>{};

          // Find all options where is_correct = true
          isCorrectMap.forEach((option, isCorrect) {
            if (isCorrect == true) {
              correctOptionsSet.add(option);
            }
          });

          // Check if user selected exactly the correct options
          if (userAnswerSet.difference(correctOptionsSet).isEmpty &&
              correctOptionsSet.difference(userAnswerSet).isEmpty) {
            correctAnswers++;
          }
        }
      }
    }

    final score = (_questions.isEmpty)
        ? 0
        : ((correctAnswers / _questions.length) * 100).toInt();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          score: score,
          correctAnswers: correctAnswers,
          totalQuestions: _questions.length,
          color: widget.color,
          questions: _questions,
          userAnswers: _answers,
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  int _getAnsweredCount() {
    int count = 0;
    for (var entry in _answers.entries) {
      final answer = entry.value;
      if (answer is String && answer.isNotEmpty) {
        count++;
      } else if (answer is List && answer.isNotEmpty) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOnline = ref.watch(isOnlineProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.judulQuiz),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isOnline ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isOnline ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isOnline ? Icons.wifi : Icons.wifi_off,
                    color: isOnline ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: isOnline ? Colors.green[700] : Colors.red[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Center(child: CircularProgressIndicator(color: widget.color)),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.judulQuiz),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isOnline ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isOnline ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isOnline ? Icons.wifi : Icons.wifi_off,
                    color: isOnline ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: isOnline ? Colors.green[700] : Colors.red[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Tidak ada soal',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Keluar dari Quiz?'),
            content: const Text(
              'Progres Anda akan hilang. Yakin ingin keluar?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Tidak'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Ya, Keluar'),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.judulQuiz),
          actions: [
            // Online/Offline Indicator
            Consumer(
              builder: (context, ref, _) {
                final isOnline = ref.watch(isOnlineProvider);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isOnline ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isOnline ? Colors.green : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isOnline ? Icons.wifi : Icons.wifi_off,
                        color: isOnline ? Colors.green : Colors.red,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: isOnline ? Colors.green[700] : Colors.red[700],
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Timer
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _remainingSeconds < 60
                    ? Colors.red.withOpacity(0.2)
                    : widget.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 20,
                    color: _remainingSeconds < 60 ? Colors.red : widget.color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatTime(_remainingSeconds),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _remainingSeconds < 60 ? Colors.red : widget.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress Indicator
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark ? AppTheme.cardDark : Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Soal ${_currentQuestionIndex + 1} dari ${_questions.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_getAnsweredCount()} dijawab',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / _questions.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                    minHeight: 8,
                  ),
                ],
              ),
            ),
            // Question
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: widget.color.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (currentQuestion['tipe'] == 'multiple') ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: widget.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_box,
                                    size: 16,
                                    color: widget.color,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Pilih lebih dari satu jawaban',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: widget.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          Text(
                            currentQuestion['pertanyaan'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Options
                    if (currentQuestion['opsi_a']?.toString().isNotEmpty ??
                        false) ...[
                      _buildOptionButton('A', currentQuestion['opsi_a']),
                      const SizedBox(height: 12),
                    ],
                    if (currentQuestion['opsi_b']?.toString().isNotEmpty ??
                        false) ...[
                      _buildOptionButton('B', currentQuestion['opsi_b']),
                      const SizedBox(height: 12),
                    ],
                    if (currentQuestion['opsi_c']?.toString().isNotEmpty ??
                        false) ...[
                      _buildOptionButton('C', currentQuestion['opsi_c']),
                      const SizedBox(height: 12),
                    ],
                    if (currentQuestion['opsi_d']?.toString().isNotEmpty ??
                        false)
                      _buildOptionButton('D', currentQuestion['opsi_d']),
                  ],
                ),
              ),
            ),
            // Navigation Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardDark : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentQuestionIndex > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _currentQuestionIndex--;
                          });
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Sebelumnya'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: widget.color,
                          side: BorderSide(color: widget.color),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  if (_currentQuestionIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_currentQuestionIndex < _questions.length - 1) {
                          setState(() {
                            _currentQuestionIndex++;
                          });
                        } else {
                          _showSubmitDialog();
                        }
                      },
                      icon: Icon(
                        _currentQuestionIndex < _questions.length - 1
                            ? Icons.arrow_forward
                            : Icons.check_circle,
                      ),
                      label: Text(
                        _currentQuestionIndex < _questions.length - 1
                            ? 'Selanjutnya'
                            : 'Selesai',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option, String text) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final tipe = currentQuestion['tipe'] ?? 'single';
    final currentAnswer = _answers[_currentQuestionIndex];

    bool isSelected;
    if (tipe == 'single') {
      isSelected = currentAnswer == option;
    } else {
      isSelected = (currentAnswer is List) && currentAnswer.contains(option);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        setState(() {
          if (tipe == 'single') {
            _answers[_currentQuestionIndex] = option;
          } else {
            // Multiple selection
            if (_answers[_currentQuestionIndex] == null) {
              _answers[_currentQuestionIndex] = <String>[option];
            } else {
              final list = List<String>.from(
                (_answers[_currentQuestionIndex] as List).cast<String>(),
              );
              if (list.contains(option)) {
                list.remove(option);
              } else {
                list.add(option);
              }
              _answers[_currentQuestionIndex] = list;
            }
          }
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? widget.color.withOpacity(0.15)
              : (isDark ? AppTheme.cardDark : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? widget.color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? widget.color : Colors.grey[300],
                shape: (currentQuestion['tipe'] == 'multiple')
                    ? BoxShape.rectangle
                    : BoxShape.circle,
                borderRadius: (currentQuestion['tipe'] == 'multiple')
                    ? BorderRadius.circular(8)
                    : null,
              ),
              child: Center(
                child: currentQuestion['tipe'] == 'multiple' && isSelected
                    ? Icon(Icons.check, color: Colors.white, size: 24)
                    : Text(
                        option,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: widget.color, size: 24),
          ],
        ),
      ),
    );
  }

  void _showSubmitDialog() {
    final answeredCount = _getAnsweredCount();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Quiz?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Soal terjawab: $answeredCount/${_questions.length}'),
            const SizedBox(height: 8),
            if (answeredCount < _questions.length)
              Text(
                'Anda masih memiliki ${_questions.length - answeredCount} soal yang belum dijawab.',
                style: const TextStyle(color: Colors.orange),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cek Lagi'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitQuiz();
            },
            style: ElevatedButton.styleFrom(backgroundColor: widget.color),
            child: const Text('Ya, Submit'),
          ),
        ],
      ),
    );
  }
}

// Result Screen
class QuizResultScreen extends StatefulWidget {
  final int score;
  final int correctAnswers;
  final int totalQuestions;
  final Color color;
  final List<Map<String, dynamic>> questions;
  final Map<int, dynamic> userAnswers;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.color,
    required this.questions,
    required this.userAnswers,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  String? _geminiApiKey;
  final Map<int, String> _aiExplanations = {};
  final Map<int, bool> _loadingExplanations = {};

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('settings')
          .doc('gemini_api')
          .get();
      if (doc.exists) {
        setState(() {
          _geminiApiKey = doc.data()?['api_key'];
        });
      }
    } catch (e) {
      debugPrint('Error loading API key: $e');
    }
  }

  Future<void> _getAIExplanation(int questionIndex) async {
    if (_geminiApiKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gemini API Key belum diatur'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _loadingExplanations[questionIndex] = true;
    });

    try {
      final question = widget.questions[questionIndex];
      final userAnswer = widget.userAnswers[questionIndex];
      final isCorrectMap = question['is_correct_map'] as Map<String, dynamic>;
      final tipe = question['tipe'] ?? 'single';

      // Build answer text
      String userAnswerText = '';
      if (userAnswer is String) {
        userAnswerText =
            '$userAnswer. ${question['opsi_${userAnswer.toLowerCase()}']}';
      } else if (userAnswer is List) {
        userAnswerText = userAnswer
            .map(
              (opt) =>
                  '$opt. ${question['opsi_${opt.toString().toLowerCase()}']}',
            )
            .join(', ');
      } else {
        userAnswerText = 'Tidak dijawab';
      }

      // Build correct answer text
      final correctOptions = <String>[];
      isCorrectMap.forEach((option, isCorrect) {
        if (isCorrect == true) {
          correctOptions.add(
            '$option. ${question['opsi_${option.toLowerCase()}']}',
          );
        }
      });
      final correctAnswerText = correctOptions.join(', ');

      final prompt =
          '''
Anda adalah asisten pendidikan yang membantu siswa memahami jawaban quiz.

SOAL: ${question['pertanyaan']}

OPSI JAWABAN:
A. ${question['opsi_a']}
B. ${question['opsi_b']}
C. ${question['opsi_c']}
D. ${question['opsi_d']}

TIPE SOAL: ${tipe == 'single' ? 'Pilihan Tunggal' : 'Pilihan Ganda (bisa lebih dari 1)'}

JAWABAN SISWA: $userAnswerText

JAWABAN YANG BENAR: $correctAnswerText

Tugas Anda:
1. Jelaskan mengapa jawaban yang benar adalah benar
2. Jika jawaban siswa salah, jelaskan kesalahannya
3. Berikan penjelasan edukatif yang membantu siswa memahami konsep

Format jawaban:
STATUS: [Benar/Salah]

PENJELASAN:
[Jelaskan mengapa jawaban benar adalah benar dengan detail]

${userAnswerText != 'Tidak dijawab' && !correctOptions.contains(userAnswerText) ? 'KESALAHAN:\n[Jelaskan mengapa jawaban siswa salah]\n\n' : ''}TIPS:
[Berikan tips agar siswa bisa menjawab soal serupa di masa depan]

Gunakan bahasa Indonesia yang mudah dipahami. Jangan gunakan simbol markdown.
''';

      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _geminiApiKey!,
      );

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null && response.text!.isNotEmpty) {
        setState(() {
          _aiExplanations[questionIndex] = response.text!;
          _loadingExplanations[questionIndex] = false;
        });
      } else {
        throw Exception('No response from AI');
      }
    } catch (e) {
      setState(() {
        _loadingExplanations[questionIndex] = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPassed = widget.score >= 70;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Quiz'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Score Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    isPassed ? Icons.check_circle : Icons.cancel,
                    size: 100,
                    color: isPassed ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isPassed ? 'Selamat!' : 'Coba Lagi',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Skor Anda',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.score}',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Jawaban Benar:',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${widget.correctAnswers}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Soal:',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${widget.totalQuestions}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Review Section
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.assignment, color: widget.color),
                      const SizedBox(width: 8),
                      const Text(
                        'Review Jawaban',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.questions.length,
                    itemBuilder: (context, index) {
                      return _buildQuestionReview(index);
                    },
                  ),
                ],
              ),
            ),
            // Back Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Kembali ke Dashboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionReview(int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final question = widget.questions[index];
    final userAnswer = widget.userAnswers[index];
    final isCorrectMap = question['is_correct_map'] as Map<String, dynamic>;

    // Determine if answer is correct
    bool isAnswerCorrect = false;
    if (question['tipe'] == 'single') {
      if (userAnswer is String) {
        isAnswerCorrect = isCorrectMap[userAnswer] == true;
      }
    } else {
      if (userAnswer is List) {
        final userAnswerSet = Set<String>.from(userAnswer.cast<String>());
        final correctOptionsSet = <String>{};
        isCorrectMap.forEach((option, isCorrect) {
          if (isCorrect == true) {
            correctOptionsSet.add(option);
          }
        });
        isAnswerCorrect =
            userAnswerSet.difference(correctOptionsSet).isEmpty &&
            correctOptionsSet.difference(userAnswerSet).isEmpty;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isAnswerCorrect
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isAnswerCorrect ? Icons.check_circle : Icons.cancel,
                    color: isAnswerCorrect ? Colors.green : Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Soal ${index + 1}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (question['tipe'] == 'multiple')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Multiple',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: widget.color,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              question['pertanyaan'],
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            // Options
            if (question['opsi_a']?.toString().isNotEmpty ?? false) ...[
              _buildOption('A', question['opsi_a'], userAnswer, isCorrectMap),
              const SizedBox(height: 8),
            ],
            if (question['opsi_b']?.toString().isNotEmpty ?? false) ...[
              _buildOption('B', question['opsi_b'], userAnswer, isCorrectMap),
              const SizedBox(height: 8),
            ],
            if (question['opsi_c']?.toString().isNotEmpty ?? false) ...[
              _buildOption('C', question['opsi_c'], userAnswer, isCorrectMap),
              const SizedBox(height: 8),
            ],
            if (question['opsi_d']?.toString().isNotEmpty ?? false)
              _buildOption('D', question['opsi_d'], userAnswer, isCorrectMap),
            const SizedBox(height: 16),
            // AI Explanation Button
            if (_geminiApiKey != null) ...[
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 12),
              if (_aiExplanations.containsKey(index))
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.blue, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Penjelasan AI Helper',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _aiExplanations[index]!,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _loadingExplanations[index] == true
                        ? null
                        : () => _getAIExplanation(index),
                    icon: _loadingExplanations[index] == true
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.psychology, size: 18),
                    label: Text(
                      _loadingExplanations[index] == true
                          ? 'Memuat...'
                          : 'Minta Penjelasan AI',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    String option,
    String text,
    dynamic userAnswer,
    Map<String, dynamic> isCorrectMap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCorrect = isCorrectMap[option] == true;
    bool isUserAnswer = false;

    if (userAnswer is String) {
      isUserAnswer = userAnswer == option;
    } else if (userAnswer is List) {
      isUserAnswer = userAnswer.contains(option);
    }

    Color? backgroundColor;
    Color? borderColor;
    IconData? icon;
    Color? iconColor;

    if (isCorrect) {
      backgroundColor = Colors.green.withOpacity(0.1);
      borderColor = Colors.green;
      icon = Icons.check_circle;
      iconColor = Colors.green;
    } else if (isUserAnswer && !isCorrect) {
      backgroundColor = Colors.red.withOpacity(0.1);
      borderColor = Colors.red;
      icon = Icons.cancel;
      iconColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDark ? AppTheme.cardDark : Colors.white),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor ?? Colors.grey[300]!,
          width: borderColor != null ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor?.withOpacity(0.2) ?? Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: iconColor ?? Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          if (icon != null) Icon(icon, color: iconColor, size: 20),
        ],
      ),
    );
  }
}
