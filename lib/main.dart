import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  ENTRY POINT
// ─────────────────────────────────────────────
void main() => runApp(const QuizApp());

// ─────────────────────────────────────────────
//  DATA MODEL
// ─────────────────────────────────────────────
class Question {
  final String text;
  final List<String> options;
  final int correctIndex;

  const Question({
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}

// ─────────────────────────────────────────────
//  QUESTION BANK
// ─────────────────────────────────────────────
const List<Question> _questions = [
  Question(
    text: 'What does CPU stand for?',
    options: [
      'Central Processing Unit',
      'Core Processor Unit',
      'Computer Personal Unit',
      'Central Program Utility',
    ],
    correctIndex: 0,
  ),
  Question(
    text: 'Which language is used to build Flutter apps?',
    options: ['Java', 'Kotlin', 'Dart', 'Swift'],
    correctIndex: 2,
  ),
  Question(
    text: 'What does HTTP stand for?',
    options: [
      'HyperText Transfer Protocol',
      'High Transfer Text Protocol',
      'HyperText Terminal Protocol',
      'Home Tool Transfer Protocol',
    ],
    correctIndex: 0,
  ),
  Question(
    text: 'Which widget is used to create a scrollable list in Flutter?',
    options: ['Column', 'Row', 'ListView', 'Stack'],
    correctIndex: 2,
  ),
  Question(
    text: 'What is the output of 2 + 2 * 2 in most programming languages?',
    options: ['8', '6', '4', '12'],
    correctIndex: 1,
  ),
  Question(
    text: 'Which data structure uses LIFO order?',
    options: ['Queue', 'Stack', 'Array', 'Linked List'],
    correctIndex: 1,
  ),
  Question(
    text: 'What is the full form of OOP?',
    options: [
      'Object Oriented Programming',
      'Object Oriented Protocol',
      'Open Object Programming',
      'Ordered Object Program',
    ],
    correctIndex: 0,
  ),
  Question(
    text: 'Which keyword is used to define a constant in Dart?',
    options: ['final', 'const', 'Both final and const', 'static'],
    correctIndex: 2,
  ),
  Question(
    text: 'What does RAM stand for?',
    options: [
      'Read Access Memory',
      'Random Access Memory',
      'Runtime Access Module',
      'Record Access Module',
    ],
    correctIndex: 1,
  ),
  Question(
    text: 'Which of these is NOT a Flutter widget?',
    options: ['Scaffold', 'AppBar', 'Fragment', 'Container'],
    correctIndex: 2,
  ),
];

// ─────────────────────────────────────────────
//  THEME CONSTANTS
// ─────────────────────────────────────────────
const Color _primary = Color(0xFF6C63FF);
const Color _accent = Color(0xFF03DAC6);
const Color _bg = Color(0xFF0F0E17);
const Color _surface = Color(0xFF1C1B2E);
const Color _card = Color(0xFF252438);
const Color _textPrimary = Color(0xFFF5F5F5);
const Color _textSecondary = Color(0xFFBBBBCC);
const Color _correct = Color(0xFF4CAF50);
const Color _wrong = Color(0xFFEF5350);

// ─────────────────────────────────────────────
//  APP ROOT
// ─────────────────────────────────────────────
class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _bg,
        colorScheme: const ColorScheme.dark(
          primary: _primary,
          secondary: _accent,
          surface: _surface,
        ),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: _textPrimary),
          bodyMedium: TextStyle(color: _textSecondary),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/score': (context) => const ScoreScreen(),
      },
    );
  }
}

// ─────────────────────────────────────────────
//  SCREEN 1 — START SCREEN
// ─────────────────────────────────────────────
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0E17), Color(0xFF1A1740), Color(0xFF0F0E17)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Hero icon ──
                      Hero(
                        tag: 'quiz-icon',
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [_primary, _accent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _primary.withOpacity(0.45),
                                blurRadius: 32,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.quiz_rounded,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // ── Title ──
                      const Text(
                        'Quiz Master',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: _textPrimary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Test your knowledge with 10 carefully\ncrafted questions!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: _textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // ── Stats card ──
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: _card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _primary.withOpacity(0.25)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            _StatChip(
                              icon: Icons.help_outline_rounded,
                              label: '10',
                              sub: 'Questions',
                            ),
                            _StatChip(
                              icon: Icons.radio_button_checked_rounded,
                              label: '4',
                              sub: 'Options',
                            ),
                            _StatChip(
                              icon: Icons.emoji_events_rounded,
                              label: '10',
                              sub: 'Max Score',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),

                      // ── Start Button ──
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [_primary, Color(0xFF9B8FFF)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: _primary.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/quiz'),
                            child: const Text(
                              'Start Quiz',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Small stat chip used on Start Screen
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;

  const _StatChip({required this.icon, required this.label, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: _accent, size: 22),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _textPrimary,
          ),
        ),
        Text(sub, style: const TextStyle(fontSize: 12, color: _textSecondary)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  SCREEN 2 — QUIZ SCREEN
// ─────────────────────────────────────────────
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOption;
  bool _answered = false;

  late AnimationController _cardController;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardFade;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _cardSlide = Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _cardController, curve: Curves.easeOutCubic),
        );
    _cardFade = CurvedAnimation(parent: _cardController, curve: Curves.easeOut);
    _cardController.forward();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedOption = index;
      _answered = true;
      if (index == _questions[_currentIndex].correctIndex) _score++;
    });
  }

  void _nextQuestion() {
    if (!_answered) return;

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
      });
      _cardController.reset();
      _cardController.forward();
    } else {
      // Navigate to score screen
      Navigator.pushReplacementNamed(
        context,
        '/score',
        arguments: {'score': _score, 'total': _questions.length},
      );
    }
  }

  Color _optionColor(int index) {
    if (!_answered) return _card;
    if (index == _questions[_currentIndex].correctIndex) return _correct;
    if (index == _selectedOption) return _wrong;
    return _card;
  }

  Color _optionBorder(int index) {
    if (!_answered) {
      return index == _selectedOption
          ? _primary.withOpacity(0.8)
          : _primary.withOpacity(0.15);
    }
    if (index == _questions[_currentIndex].correctIndex)
      return _correct.withOpacity(0.8);
    if (index == _selectedOption) return _wrong.withOpacity(0.8);
    return _primary.withOpacity(0.1);
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0E17), Color(0xFF1C1B30)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top bar ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: _textSecondary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    // Score badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: _accent,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$_score pts',
                            style: const TextStyle(
                              color: _textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ── Progress bar ──
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: _card,
                          color: _primary,
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_currentIndex + 1}/${_questions.length}',
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Question card (animated) ──
                FadeTransition(
                  opacity: _cardFade,
                  child: SlideTransition(
                    position: _cardSlide,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: _primary.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: _primary.withOpacity(0.12),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Question ${_currentIndex + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: _primary,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            question.text,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: _textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Options ──
                Expanded(
                  child: ListView.separated(
                    itemCount: question.options.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final isSelected = _selectedOption == i;
                      final isCorrect = _answered && i == question.correctIndex;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOut,
                        decoration: BoxDecoration(
                          color: _optionColor(i),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _optionBorder(i),
                            width: 1.5,
                          ),
                          boxShadow: isSelected || isCorrect
                              ? [
                                  BoxShadow(
                                    color: (isCorrect ? _correct : _wrong)
                                        .withOpacity(0.25),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: RadioListTile<int>(
                          value: i,
                          groupValue: _selectedOption,
                          onChanged: _answered ? null : (_) => _selectOption(i),
                          activeColor: Colors.white,
                          title: Text(
                            question.options[i],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected || isCorrect
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color:
                                  _answered &&
                                      (i == question.correctIndex ||
                                          i == _selectedOption)
                                  ? Colors.white
                                  : _textPrimary,
                            ),
                          ),
                          secondary: _answered
                              ? Icon(
                                  i == question.correctIndex
                                      ? Icons.check_circle_rounded
                                      : (i == _selectedOption
                                            ? Icons.cancel_rounded
                                            : null),
                                  color: i == question.correctIndex
                                      ? Colors.white
                                      : _wrong.withOpacity(0.9),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // ── Next / Submit Button ──
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _answered
                            ? [_primary, const Color(0xFF9B8FFF)]
                            : [_card, _card],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _answered
                          ? [
                              BoxShadow(
                                color: _primary.withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : [],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _answered ? _nextQuestion : null,
                      child: Text(
                        _currentIndex < _questions.length - 1
                            ? 'Next Question →'
                            : 'See Results 🏆',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _answered
                              ? Colors.white
                              : _textSecondary.withOpacity(0.5),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SCREEN 3 — SCORE SCREEN
// ─────────────────────────────────────────────
class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _scaleFade;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _mainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleFade = CurvedAnimation(parent: _mainCtrl, curve: Curves.elasticOut);
    _pulse = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _mainCtrl.forward();
  }

  @override
  void dispose() {
    _mainCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  String _getMessage(int score, int total) {
    final ratio = score / total;
    if (ratio == 1.0) return '🎉 Perfect Score!';
    if (ratio >= 0.8) return '🌟 Excellent Work!';
    if (ratio >= 0.6) return '👍 Good Job!';
    if (ratio >= 0.4) return '📚 Keep Practicing!';
    return '💪 Try Again!';
  }

  Color _getScoreColor(int score, int total) {
    final ratio = score / total;
    if (ratio >= 0.8) return _correct;
    if (ratio >= 0.5) return _accent;
    return _wrong;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int score = args['score'];
    final int total = args['total'];
    final scoreColor = _getScoreColor(score, total);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0E17), Color(0xFF1A1740), Color(0xFF0D1117)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Hero icon (matches Start Screen) ──
                  Hero(
                    tag: 'quiz-icon',
                    child: ScaleTransition(
                      scale: _scaleFade,
                      child: AnimatedBuilder(
                        animation: _pulse,
                        builder: (_, child) =>
                            Transform.scale(scale: _pulse.value, child: child),
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [scoreColor, scoreColor.withOpacity(0.6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: scoreColor.withOpacity(0.45),
                                blurRadius: 40,
                                spreadRadius: 6,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '$score',
                              style: const TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Message ──
                  FadeTransition(
                    opacity: _scaleFade,
                    child: Text(
                      _getMessage(score, total),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: _textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeTransition(
                    opacity: _scaleFade,
                    child: Text(
                      'You scored $score out of $total',
                      style: const TextStyle(
                        fontSize: 16,
                        color: _textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ── Summary card ──
                  ScaleTransition(
                    scale: _scaleFade,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: scoreColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: scoreColor.withOpacity(0.1),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _ResultRow(
                            label: 'Correct Answers',
                            value: '$score',
                            color: _correct,
                            icon: Icons.check_circle_rounded,
                          ),
                          const Divider(color: Colors.white10, height: 28),
                          _ResultRow(
                            label: 'Wrong Answers',
                            value: '${total - score}',
                            color: _wrong,
                            icon: Icons.cancel_rounded,
                          ),
                          const Divider(color: Colors.white10, height: 28),
                          _ResultRow(
                            label: 'Accuracy',
                            value:
                                '${((score / total) * 100).toStringAsFixed(0)}%',
                            color: _accent,
                            icon: Icons.percent_rounded,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ── Replay Button ──
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_primary, Color(0xFF9B8FFF)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _primary.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/quiz',
                            (route) => route.isFirst,
                          );
                        },
                        icon: const Icon(
                          Icons.replay_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Play Again',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Home Button ──
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: _primary.withOpacity(0.5),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      ),
                      icon: const Icon(Icons.home_rounded, color: _primary),
                      label: const Text(
                        'Back to Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper row widget for score summary
class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: _textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
