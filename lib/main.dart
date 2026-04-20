import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const QuizApp());

// ─────────────────────────────────────────────
//  GLOBAL STATE
// ─────────────────────────────────────────────
class AppState {
  static int personalBest = 0;
  static int totalGamesPlayed = 0;
  // Full history, newest first
  static final List<QuizResult> history = [];

  static void addResult(QuizResult r) {
    history.insert(0, r);
    totalGamesPlayed++;
    if (r.score > personalBest) personalBest = r.score;
  }
}

// ─────────────────────────────────────────────
//  DATA MODEL
// ─────────────────────────────────────────────
class Question {
  final String text;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  const Question({required this.text, required this.options, required this.correctIndex, this.explanation = ''});
}

class QuizResult {
  final int score;
  final int total;
  final int streakMax;
  final List<int?> userAnswers;
  final List<Question> questions;
  final QuizCategory category;
  final DateTime playedAt;

  QuizResult({
    required this.score,
    required this.total,
    required this.streakMax,
    required this.userAnswers,
    required this.questions,
    required this.category,
  }) : playedAt = DateTime.now();
}

// ─────────────────────────────────────────────
//  CATEGORIES
// ─────────────────────────────────────────────
enum QuizCategory { generalCS, flutter, dataStructures }

extension QuizCategoryX on QuizCategory {
  String get label {
    switch (this) {
      case QuizCategory.generalCS: return 'General CS';
      case QuizCategory.flutter: return 'Flutter';
      case QuizCategory.dataStructures: return 'Data Structures';
    }
  }
  IconData get icon {
    switch (this) {
      case QuizCategory.generalCS: return Icons.computer_rounded;
      case QuizCategory.flutter: return Icons.flutter_dash_rounded;
      case QuizCategory.dataStructures: return Icons.account_tree_rounded;
    }
  }
  Color get color {
    switch (this) {
      case QuizCategory.generalCS: return const Color(0xFF6C63FF);
      case QuizCategory.flutter: return const Color(0xFF00B4D8);
      case QuizCategory.dataStructures: return const Color(0xFFFF6B6B);
    }
  }
  List<Question> get questions {
    switch (this) {
      case QuizCategory.generalCS: return _generalCSQuestions;
      case QuizCategory.flutter: return _flutterQuestions;
      case QuizCategory.dataStructures: return _dsQuestions;
    }
  }
}

// ─────────────────────────────────────────────
//  QUESTION BANKS
// ─────────────────────────────────────────────
const List<Question> _generalCSQuestions = [
  Question(text: 'What does CPU stand for?', options: ['Central Processing Unit','Core Processor Unit','Computer Personal Unit','Central Program Utility'], correctIndex: 0, explanation: 'CPU = Central Processing Unit — the brain of a computer.'),
  Question(text: 'What does HTTP stand for?', options: ['HyperText Transfer Protocol','High Transfer Text Protocol','HyperText Terminal Protocol','Home Tool Transfer Protocol'], correctIndex: 0, explanation: 'HTTP is the foundation of data communication on the web.'),
  Question(text: 'What does RAM stand for?', options: ['Read Access Memory','Random Access Memory','Runtime Access Module','Record Access Module'], correctIndex: 1, explanation: 'RAM is volatile memory used for active processes.'),
  Question(text: 'Which of these is a compiled language?', options: ['Python','JavaScript','C++','Ruby'], correctIndex: 2, explanation: 'C++ is compiled directly to machine code for fast execution.'),
  Question(text: 'What is the output of 2 + 2 * 2?', options: ['8','6','4','12'], correctIndex: 1, explanation: 'Operator precedence: multiplication first → 2 + 4 = 6.'),
  Question(text: 'What does OOP stand for?', options: ['Object Oriented Programming','Object Oriented Protocol','Open Object Programming','Ordered Object Program'], correctIndex: 0, explanation: 'OOP organizes code around objects with properties and behaviors.'),
  Question(text: 'Which is NOT a programming paradigm?', options: ['Functional','Declarative','Procedural','Synchronal'], correctIndex: 3, explanation: '"Synchronal" is not a real programming paradigm.'),
  Question(text: 'What is "Big O" notation used for?', options: ['Syntax checking','Algorithm complexity','Memory allocation','Code formatting'], correctIndex: 1, explanation: 'Big O describes an algorithm\'s time/space complexity.'),
  Question(text: 'Which OSI layer handles routing?', options: ['Physical','Data Link','Network','Transport'], correctIndex: 2, explanation: 'Layer 3 (Network) handles logical addressing and routing.'),
  Question(text: 'What is the base of the binary number system?', options: ['8','2','16','10'], correctIndex: 1, explanation: 'Binary uses base-2 (only digits 0 and 1).'),
];

const List<Question> _flutterQuestions = [
  Question(text: 'Which language is used to build Flutter apps?', options: ['Java','Kotlin','Dart','Swift'], correctIndex: 2, explanation: 'Flutter uses Dart — a strongly typed language by Google.'),
  Question(text: 'Which widget creates a scrollable list in Flutter?', options: ['Column','Row','ListView','Stack'], correctIndex: 2, explanation: 'ListView efficiently renders scrollable lists in Flutter.'),
  Question(text: 'Which keyword defines a constant in Dart?', options: ['final','const','Both final and const','static'], correctIndex: 2, explanation: 'Both `final` and `const` define constants, with subtle differences.'),
  Question(text: 'Which of these is NOT a Flutter widget?', options: ['Scaffold','AppBar','Fragment','Container'], correctIndex: 2, explanation: 'Fragment is an Android concept, not a Flutter widget.'),
  Question(text: 'What does `setState()` do in Flutter?', options: ['Navigates to a new screen','Triggers a UI rebuild','Saves data to disk','Calls an API'], correctIndex: 1, explanation: '`setState()` notifies Flutter to rebuild the widget subtree.'),
  Question(text: 'Which widget makes content scrollable?', options: ['Padding','SingleChildScrollView','SizedBox','Opacity'], correctIndex: 1, explanation: 'SingleChildScrollView wraps a widget to make it scrollable.'),
  Question(text: 'What does Hot Reload do?', options: ['Restarts phone','Re-runs the entire app','Injects code without full restart','Clears the cache'], correctIndex: 2, explanation: 'Hot Reload injects updated code while preserving app state.'),
  Question(text: 'Which class is typically the root of the Flutter widget tree?', options: ['MaterialApp','Scaffold','Widget','BuildContext'], correctIndex: 0, explanation: 'MaterialApp provides theme and routing at the root.'),
  Question(text: 'What does `BuildContext` represent?', options: ['App configuration','Location of a widget in the tree','A database connection','A network request'], correctIndex: 1, explanation: 'BuildContext is a handle to a widget\'s location in the widget tree.'),
  Question(text: 'Which layout arranges children horizontally?', options: ['Column','Stack','Row','Wrap'], correctIndex: 2, explanation: 'Row arranges children horizontally along the main axis.'),
];

const List<Question> _dsQuestions = [
  Question(text: 'Which data structure uses LIFO order?', options: ['Queue','Stack','Array','Linked List'], correctIndex: 1, explanation: 'Stack = Last In, First Out (like a stack of plates).'),
  Question(text: 'Time complexity of binary search?', options: ['O(n)','O(n²)','O(log n)','O(1)'], correctIndex: 2, explanation: 'Binary search halves the search space each step → O(log n).'),
  Question(text: 'Which structure is best for FIFO processing?', options: ['Stack','Tree','Queue','Graph'], correctIndex: 2, explanation: 'Queue = First In, First Out (like a waiting line).'),
  Question(text: 'A binary tree node has at most how many children?', options: ['1','2','3','Unlimited'], correctIndex: 1, explanation: 'Binary tree nodes have at most 2 children: left and right.'),
  Question(text: 'Worst-case time complexity for bubble sort?', options: ['O(n)','O(n log n)','O(n²)','O(log n)'], correctIndex: 2, explanation: 'Bubble sort compares all pairs → O(n²) in the worst case.'),
  Question(text: 'Which traversal visits root FIRST?', options: ['Inorder','Postorder','Preorder','Level order'], correctIndex: 2, explanation: 'Preorder: Root → Left → Right.'),
  Question(text: 'Average lookup time for hash maps?', options: ['O(n)','O(log n)','O(1)','O(n²)'], correctIndex: 2, explanation: 'Hash maps use a hash function for O(1) average access.'),
  Question(text: 'Which data structure underlies recursion?', options: ['Queue','Stack','Heap','Graph'], correctIndex: 1, explanation: 'Recursive calls use the call stack (LIFO).'),
  Question(text: 'What connects nodes in a linked list?', options: ['Index','Key','Pointer/Reference','Hash'], correctIndex: 2, explanation: 'Each node stores data and a pointer to the next node.'),
  Question(text: 'Which sorting algorithm uses divide-and-conquer?', options: ['Bubble Sort','Selection Sort','Insertion Sort','Merge Sort'], correctIndex: 3, explanation: 'Merge Sort recursively splits and merges → O(n log n).'),
];

// ─────────────────────────────────────────────
//  THEME
// ─────────────────────────────────────────────
const Color _primary        = Color(0xFF6C63FF);
const Color _accent         = Color(0xFF03DAC6);
const Color _bg             = Color(0xFF0F0E17);
const Color _surface        = Color(0xFF1C1B2E);
const Color _card           = Color(0xFF252438);
const Color _textPrimary    = Color(0xFFF5F5F5);
const Color _textSecondary  = Color(0xFFBBBBCC);
const Color _correct        = Color(0xFF4CAF50);
const Color _wrong          = Color(0xFFEF5350);
const Color _timerWarn      = Color(0xFFFF9800);
const int   _timeSec        = 20;

// ─────────────────────────────────────────────
//  HELPERS
// ─────────────────────────────────────────────
String _timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inSeconds < 60)  return 'Just now';
  if (diff.inMinutes < 60)  return '${diff.inMinutes}m ago';
  if (diff.inHours < 24)    return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}

Color _gradeColor(int score, int total) {
  final r = score / total;
  if (r >= 0.8) return _correct;
  if (r >= 0.5) return _accent;
  return _wrong;
}

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
        colorScheme: const ColorScheme.dark(primary: _primary, secondary: _accent, surface: _surface),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':       return MaterialPageRoute(builder: (_) => const StartScreen());
          case '/category': return _fade(const CategoryScreen(), settings);
          case '/quiz':   return _fade(QuizScreen(category: settings.arguments as QuizCategory), settings);
          case '/score':  return _fade(const ScoreScreen(), settings);
          case '/review': return MaterialPageRoute(settings: settings, builder: (_) => const ReviewScreen());
          case '/history': return _fade(const HistoryScreen(), settings);
          default:        return MaterialPageRoute(builder: (_) => const StartScreen());
        }
      },
    );
  }

  PageRouteBuilder _fade(Widget page, RouteSettings settings) => PageRouteBuilder(
    settings: settings,
    pageBuilder: (_, a, __) => page,
    transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
    transitionDuration: const Duration(milliseconds: 350),
  );
}

// ═══════════════════════════════════════════════════════════════
//  START SCREEN
// ═══════════════════════════════════════════════════════════════
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(
            colors: [Color(0xFF0F0E17), Color(0xFF1A1740), Color(0xFF0F0E17)],
            begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),

                      // ── Hero icon ──
                      Hero(tag: 'quiz-icon', child: Container(
                        width: 96, height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(colors: [_primary, _accent], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          boxShadow: [BoxShadow(color: _primary.withOpacity(0.35), blurRadius: 28, spreadRadius: 4)],
                        ),
                        child: const Icon(Icons.quiz_rounded, size: 46, color: Colors.white),
                      )),
                      const SizedBox(height: 20),
                      const Text('Quiz Master', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: _textPrimary)),
                      const SizedBox(height: 6),
                      const Text('Test your knowledge across 3 categories.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: _textSecondary, height: 1.5)),
                      const SizedBox(height: 26),

                      // ── Last quiz card (tappable → review) ──
                      if (AppState.history.isNotEmpty) _LastQuizCard(result: AppState.history.first),

                      // ── Quick stats ──
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(18), border: Border.all(color: _primary.withOpacity(0.18))),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [
                          _StatChip(icon: Icons.help_outline_rounded, label: '10', sub: 'Questions'),
                          _StatChip(icon: Icons.timer_rounded, label: '20s', sub: '/ Question'),
                          _StatChip(icon: Icons.local_fire_department_rounded, label: 'Streaks', sub: 'Bonus'),
                        ]),
                      ),
                      const SizedBox(height: 22),

                      // ── Start ──
                      SizedBox(
                        width: double.infinity, height: 54,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [_primary, Color(0xFF9B8FFF)]),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: _primary.withOpacity(0.42), blurRadius: 18, offset: const Offset(0, 7))],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                            onPressed: () => Navigator.pushNamed(context, '/category'),
                            child: const Text('Start Quiz', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── View all history ──
                      if (AppState.history.isNotEmpty)
                        SizedBox(
                          width: double.infinity, height: 48,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: _primary.withOpacity(0.4), width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () => Navigator.pushNamed(context, '/history'),
                            icon: const Icon(Icons.history_rounded, color: _primary, size: 17),
                            label: Text('View All History  (${AppState.history.length} games)', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _primary)),
                          ),
                        ),
                      const SizedBox(height: 8),
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

// ── Last Quiz preview card ────────────────────
class _LastQuizCard extends StatelessWidget {
  final QuizResult result;
  const _LastQuizCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final sc = _gradeColor(result.score, result.total);
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/review', arguments: result),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(18), border: Border.all(color: result.category.color.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.history_rounded, color: _textSecondary, size: 12),
            const SizedBox(width: 5),
            const Text('Last quiz', style: TextStyle(fontSize: 11, color: _textSecondary, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
            const Spacer(),
            Text(_timeAgo(result.playedAt), style: const TextStyle(fontSize: 11, color: _textSecondary)),
            const SizedBox(width: 3),
            const Icon(Icons.chevron_right_rounded, color: _textSecondary, size: 14),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: result.category.color.withOpacity(0.14)), child: Icon(result.category.icon, color: result.category.color, size: 18)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(result.category.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _textPrimary)),
              Text('Streak: ${result.streakMax}', style: const TextStyle(fontSize: 11, color: _textSecondary)),
            ]),
            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              RichText(text: TextSpan(children: [
                TextSpan(text: '${result.score}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: sc)),
                const TextSpan(text: '/10', style: TextStyle(fontSize: 13, color: _textSecondary)),
              ])),
              Text('${((result.score / result.total) * 100).round()}% accuracy', style: const TextStyle(fontSize: 11, color: _textSecondary)),
            ]),
          ]),
        ]),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon; final String label, sub;
  const _StatChip({required this.icon, required this.label, required this.sub});
  @override
  Widget build(BuildContext context) => Column(children: [
    Icon(icon, color: _accent, size: 19),
    const SizedBox(height: 5),
    Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _textPrimary)),
    Text(sub, style: const TextStyle(fontSize: 11, color: _textSecondary)),
  ]);
}

// ═══════════════════════════════════════════════════════════════
//  HISTORY SCREEN
// ═══════════════════════════════════════════════════════════════
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  QuizCategory? _filter;

  List<QuizResult> get _filtered => _filter == null
      ? AppState.history
      : AppState.history.where((r) => r.category == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final list      = _filtered;
    final total     = list.length;
    final avgScore  = total == 0 ? 0.0 : list.map((r) => r.score).reduce((a, b) => a + b) / total;
    final best      = total == 0 ? 0   : list.map((r) => r.score).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(
            colors: [Color(0xFF0F0E17), Color(0xFF1C1B30)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(child: Column(children: [

          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 14, 18, 0),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: _textSecondary, size: 20), onPressed: () => Navigator.pop(context)),
              const Expanded(child: Text('Quiz History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _textPrimary))),
              Text('${AppState.history.length} total', style: const TextStyle(fontSize: 12, color: _textSecondary)),
            ]),
          ),
          const SizedBox(height: 14),

          // ── Summary strip ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(children: [
              _SummaryBox(label: 'Games', value: '$total'),
              const SizedBox(width: 10),
              _SummaryBox(label: 'Avg score', value: total == 0 ? '—' : avgScore.toStringAsFixed(1)),
              const SizedBox(width: 10),
              _SummaryBox(label: 'Best', value: total == 0 ? '—' : '$best/10', valueColor: _correct),
            ]),
          ),
          const SizedBox(height: 14),

          // ── Filter chips ──
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: [
                _FilterChip(label: 'All', active: _filter == null, onTap: () => setState(() => _filter = null)),
                ...QuizCategory.values.map((c) => _FilterChip(
                  label: c.label, color: c.color,
                  active: _filter == c,
                  onTap: () => setState(() => _filter = _filter == c ? null : c),
                )),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── List ──
          Expanded(
            child: list.isEmpty
                ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.quiz_outlined, color: _textSecondary.withOpacity(0.28), size: 44),
              const SizedBox(height: 12),
              Text(_filter == null ? 'No games yet.' : 'No ${_filter!.label} games yet.',
                  style: const TextStyle(color: _textSecondary, fontSize: 14)),
            ]))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: list.length,
              itemBuilder: (context, i) => _HistoryTile(result: list[i], globalIndex: AppState.history.indexOf(list[i]), rank: i + 1),
            ),
          ),
        ])),
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String label, value; final Color? valueColor;
  const _SummaryBox({required this.label, required this.value, this.valueColor});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(14), border: Border.all(color: _primary.withOpacity(0.15))),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: valueColor ?? _textPrimary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: _textSecondary)),
      ]),
    ),
  );
}

class _FilterChip extends StatelessWidget {
  final String label; final bool active; final Color? color; final VoidCallback onTap;
  const _FilterChip({required this.label, required this.active, required this.onTap, this.color});
  @override
  Widget build(BuildContext context) {
    final c = color ?? _primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? c.withOpacity(0.16) : _card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? c.withOpacity(0.65) : _primary.withOpacity(0.16)),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? c : _textSecondary)),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final QuizResult result;
  final int globalIndex; // 0 = latest in AppState.history
  final int rank;        // 1-based position in current filtered list
  const _HistoryTile({required this.result, required this.globalIndex, required this.rank});

  @override
  Widget build(BuildContext context) {
    final sc       = _gradeColor(result.score, result.total);
    final accuracy = ((result.score / result.total) * 100).round();
    final isLatest = globalIndex == 0;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/review', arguments: result),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isLatest ? result.category.color.withOpacity(0.38) : _primary.withOpacity(0.12)),
        ),
        child: Row(children: [
          // ── Rank ──
          SizedBox(width: 28, child: Text('#$rank', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: rank == 1 && isLatest ? const Color(0xFFFFD700) : _textSecondary))),
          const SizedBox(width: 4),

          // ── Category icon ──
          Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: result.category.color.withOpacity(0.14)), child: Icon(result.category.icon, color: result.category.color, size: 17)),
          const SizedBox(width: 11),

          // ── Info ──
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(result.category.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _textPrimary)),
              if (isLatest) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: _primary.withOpacity(0.16), borderRadius: BorderRadius.circular(5)),
                  child: const Text('Latest', style: TextStyle(fontSize: 9, color: _primary, fontWeight: FontWeight.w700)),
                ),
              ],
            ]),
            const SizedBox(height: 3),
            Row(children: [
              Text('$accuracy% acc', style: const TextStyle(fontSize: 11, color: _textSecondary)),
              const SizedBox(width: 8),
              Text('🔥 ${result.streakMax}', style: const TextStyle(fontSize: 11, color: _textSecondary)),
              const SizedBox(width: 8),
              Text(_timeAgo(result.playedAt), style: const TextStyle(fontSize: 11, color: _textSecondary)),
            ]),
          ])),

          // ── Score badge ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: sc.withOpacity(0.11), borderRadius: BorderRadius.circular(10), border: Border.all(color: sc.withOpacity(0.32))),
            child: Text('${result.score}/10', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: sc)),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, color: _textSecondary, size: 16),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  CATEGORY SCREEN
// ═══════════════════════════════════════════════════════════════
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  QuizCategory _selected = QuizCategory.generalCS;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  int? _bestFor(QuizCategory cat) {
    final games = AppState.history.where((r) => r.category == cat).toList();
    if (games.isEmpty) return null;
    return games.map((r) => r.score).reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(
            colors: [Color(0xFF0F0E17), Color(0xFF1A1740), Color(0xFF0F0E17)],
            begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: SafeArea(child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: _textSecondary, size: 20), onPressed: () => Navigator.pop(context)),
            ]),
          ),
          Expanded(child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Choose Category', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: _textPrimary)),
                  const SizedBox(height: 5),
                  const Text('Select a topic to test your knowledge.', style: TextStyle(fontSize: 13, color: _textSecondary)),
                  const SizedBox(height: 24),
                  ...QuizCategory.values.map((cat) => _CategoryCard(
                    category: cat, isSelected: _selected == cat, best: _bestFor(cat),
                    onTap: () => setState(() => _selected = cat),
                  )),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity, height: 54,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [_selected.color, _selected.color.withOpacity(0.7)]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: _selected.color.withOpacity(0.4), blurRadius: 18, offset: const Offset(0, 6))],
                      ),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                        onPressed: () => Navigator.pushReplacementNamed(context, '/quiz', arguments: _selected),
                        icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
                        label: const Text('Start Quiz', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ]),
              ),
            ),
          )),
        ])),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final QuizCategory category; final bool isSelected; final int? best; final VoidCallback onTap;
  const _CategoryCard({required this.category, required this.isSelected, required this.onTap, this.best});
  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _scale;
  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 130));
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(CurvedAnimation(parent: _ac, curve: Curves.easeIn));
  }
  @override
  void dispose() { _ac.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    return GestureDetector(
      onTapDown: (_) => _ac.forward(),
      onTapUp: (_) { _ac.reverse(); widget.onTap(); },
      onTapCancel: () => _ac.reverse(),
      child: ScaleTransition(scale: _scale, child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: widget.isSelected ? cat.color.withOpacity(0.12) : _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: widget.isSelected ? cat.color.withOpacity(0.7) : _primary.withOpacity(0.14), width: widget.isSelected ? 1.5 : 1),
        ),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, color: cat.color.withOpacity(0.14)), child: Icon(cat.icon, color: cat.color, size: 21)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(cat.label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: widget.isSelected ? cat.color : _textPrimary)),
            Row(children: [
              const Text('10 questions  •  20s each', style: TextStyle(fontSize: 11, color: _textSecondary)),
              if (widget.best != null) ...[
                const SizedBox(width: 8),
                Text('Best: ${widget.best}/10', style: TextStyle(fontSize: 11, color: cat.color, fontWeight: FontWeight.w600)),
              ],
            ]),
          ])),
          AnimatedContainer(
            duration: const Duration(milliseconds: 190),
            width: 22, height: 22,
            decoration: BoxDecoration(shape: BoxShape.circle, color: widget.isSelected ? cat.color : Colors.transparent, border: Border.all(color: widget.isSelected ? cat.color : _textSecondary.withOpacity(0.3), width: 2)),
            child: widget.isSelected ? const Icon(Icons.check, color: Colors.white, size: 13) : null,
          ),
        ]),
      )),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  QUIZ SCREEN
// ═══════════════════════════════════════════════════════════════
class QuizScreen extends StatefulWidget {
  final QuizCategory category;
  const QuizScreen({super.key, required this.category});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late List<Question> _questions;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOption;
  bool _answered = false;
  int _streak = 0;
  int _maxStreak = 0;
  bool _showStreakPop = false;
  bool _used5050 = false;
  bool _usedSkip = false;
  Set<int> _hidden = {};
  final List<int?> _userAnswers = [];

  late AnimationController _cardCtrl, _streakCtrl, _timerCtrl;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardFade, _streakScale;

  @override
  void initState() {
    super.initState();
    _questions = List.from(widget.category.questions)..shuffle();
    _questions = _questions.take(10).toList();

    _cardCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 360));
    _cardSlide = Tween<Offset>(begin: const Offset(0.55, 0), end: Offset.zero).animate(CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutCubic));
    _cardFade  = CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut);

    _streakCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 620));
    _streakScale = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1.25).chain(CurveTween(curve: Curves.elasticOut)), weight: 60),
      TweenSequenceItem(tween: Tween<double>(begin: 1.25, end: 0).chain(CurveTween(curve: Curves.easeIn)), weight: 40),
    ]).animate(_streakCtrl);

    _timerCtrl = AnimationController(vsync: this, duration: const Duration(seconds: _timeSec))
      ..addStatusListener((s) { if (s == AnimationStatus.completed) _onTimeout(); });

    _cardCtrl.forward();
    _timerCtrl.forward();
  }

  @override
  void dispose() { _cardCtrl.dispose(); _streakCtrl.dispose(); _timerCtrl.dispose(); super.dispose(); }

  void _onTimeout() {
    if (_answered) return;
    setState(() { _answered = true; _userAnswers.add(null); _streak = 0; });
  }

  void _selectOption(int i) {
    if (_answered || _hidden.contains(i)) return;
    _timerCtrl.stop();
    final correct = i == _questions[_currentIndex].correctIndex;
    setState(() {
      _selectedOption = i; _answered = true; _userAnswers.add(i);
      if (correct) {
        _score++; _streak++;
        if (_streak > _maxStreak) _maxStreak = _streak;
        if (_streak >= 2) _triggerStreakPop();
      } else { _streak = 0; }
    });
  }

  void _triggerStreakPop() {
    _showStreakPop = true;
    _streakCtrl.reset();
    _streakCtrl.forward().then((_) { if (mounted) setState(() => _showStreakPop = false); });
  }

  void _nextQuestion() {
    if (!_answered) return;
    if (_currentIndex < _questions.length - 1) {
      setState(() { _currentIndex++; _selectedOption = null; _answered = false; _hidden = {}; });
      _cardCtrl.reset(); _cardCtrl.forward();
      _timerCtrl.reset(); _timerCtrl.forward();
    } else { _finish(); }
  }

  void _finish() {
    final result = QuizResult(score: _score, total: _questions.length, streakMax: _maxStreak, userAnswers: _userAnswers, questions: _questions, category: widget.category);
    AppState.addResult(result);
    Navigator.pushReplacementNamed(context, '/score', arguments: result);
  }

  void _use5050() {
    if (_used5050 || _answered) return;
    setState(() => _used5050 = true);
    final correct = _questions[_currentIndex].correctIndex;
    final wrong = List.generate(4, (i) => i).where((i) => i != correct).toList()..shuffle();
    setState(() => _hidden = {wrong[0], wrong[1]});
  }

  void _useSkip() {
    if (_usedSkip || _answered) return;
    _timerCtrl.stop();
    setState(() { _usedSkip = true; _answered = true; _userAnswers.add(null); _streak = 0; });
    Future.delayed(const Duration(milliseconds: 380), _nextQuestion);
  }

  Color _optionColor(int i) {
    if (_hidden.contains(i)) return _card.withOpacity(0.25);
    if (!_answered) return _card;
    if (i == _questions[_currentIndex].correctIndex) return _correct;
    if (i == _selectedOption) return _wrong;
    return _card;
  }

  Color _optionBorder(int i) {
    if (_hidden.contains(i)) return _primary.withOpacity(0.05);
    if (!_answered) return i == _selectedOption ? _primary.withOpacity(0.7) : _primary.withOpacity(0.13);
    if (i == _questions[_currentIndex].correctIndex) return _correct.withOpacity(0.8);
    if (i == _selectedOption) return _wrong.withOpacity(0.8);
    return _primary.withOpacity(0.1);
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentIndex];
    final catColor = widget.category.color;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(
            colors: [Color(0xFF0F0E17), Color(0xFF1C1B30)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ── Top bar ──
            Row(children: [
              IconButton(icon: const Icon(Icons.close_rounded, color: _textSecondary, size: 22), onPressed: () => _showQuitDialog(context)),
              Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: (_currentIndex + 1) / _questions.length, backgroundColor: _card, color: catColor, minHeight: 6))),
              const SizedBox(width: 10),
              Text('${_currentIndex + 1}/${_questions.length}', style: const TextStyle(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(14), border: Border.all(color: catColor.withOpacity(0.4))),
                child: Row(children: [
                  Icon(Icons.check_circle_rounded, color: catColor, size: 13),
                  const SizedBox(width: 4),
                  Text('$_score', style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w800, fontSize: 13)),
                ]),
              ),
            ]),
            const SizedBox(height: 8),

            // ── Timer ──
            _TimerBar(controller: _timerCtrl, color: catColor),
            const SizedBox(height: 10),

            // ── Streak badge ──
            if (_streak >= 2) Center(child: Container(
              margin: const EdgeInsets.only(bottom: 7),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFFFF6B35).withOpacity(0.9), const Color(0xFFFFD700).withOpacity(0.85)]), borderRadius: BorderRadius.circular(16)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('🔥', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 5),
                Text('$_streak Combo!', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
              ]),
            )),

            if (_showStreakPop) Center(child: ScaleTransition(scale: _streakScale, child: Text(
              _streak >= 5 ? '🚀 Unstoppable!' : _streak >= 3 ? '⚡ On Fire!' : '✨ Streak!',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Color(0xFFFFD700)),
            ))),

            // ── Question card ──
            FadeTransition(opacity: _cardFade, child: SlideTransition(position: _cardSlide,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(20), border: Border.all(color: catColor.withOpacity(0.22))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(color: catColor.withOpacity(0.13), borderRadius: BorderRadius.circular(7)),
                    child: Text('Q${_currentIndex + 1}  •  ${widget.category.label}', style: TextStyle(fontSize: 10, color: catColor, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
                  ),
                  const SizedBox(height: 10),
                  Text(q.text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _textPrimary, height: 1.4)),
                  if (_answered && q.explanation.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(9), border: Border.all(color: _accent.withOpacity(0.27))),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Icon(Icons.info_outline_rounded, color: _accent, size: 13),
                        const SizedBox(width: 7),
                        Expanded(child: Text(q.explanation, style: const TextStyle(fontSize: 11, color: _textSecondary, height: 1.5))),
                      ]),
                    ),
                ]),
              ),
            )),
            const SizedBox(height: 10),

            // ── Options ──
            Expanded(child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: q.options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final hidden    = _hidden.contains(i);
                final isCorrect = _answered && i == q.correctIndex;
                final isWrong   = _answered && i == _selectedOption && i != q.correctIndex;
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: hidden ? 0.2 : 1.0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 230),
                    decoration: BoxDecoration(color: _optionColor(i), borderRadius: BorderRadius.circular(15), border: Border.all(color: _optionBorder(i), width: 1.5)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: hidden || _answered ? null : () => _selectOption(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                        child: Row(children: [
                          Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: isCorrect || isWrong ? Colors.white.withOpacity(0.15) : _surface, border: Border.all(color: _optionBorder(i).withOpacity(0.5))),
                            child: Center(child: _answered
                                ? Icon(i == q.correctIndex ? Icons.check_circle_rounded : i == _selectedOption ? Icons.cancel_rounded : null, color: Colors.white, size: 15)
                                : Text(['A','B','C','D'][i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: catColor))),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(q.options[i], style: TextStyle(fontSize: 14, fontWeight: isCorrect || isWrong ? FontWeight.w700 : FontWeight.w500, color: isCorrect || isWrong ? Colors.white : _textPrimary))),
                        ]),
                      ),
                    ),
                  ),
                );
              },
            )),
            const SizedBox(height: 8),

            // ── Lifelines + Next ──
            Row(children: [
              _LifelineBtn(label: '50:50', icon: Icons.filter_2_rounded, used: _used5050, color: const Color(0xFFFFB300), onTap: _use5050),
              const SizedBox(width: 10),
              _LifelineBtn(label: 'Skip', icon: Icons.skip_next_rounded, used: _usedSkip, color: const Color(0xFF00BCD4), onTap: _useSkip),
              const Spacer(),
              SizedBox(
                width: 138, height: 47,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: _answered ? [catColor, catColor.withOpacity(0.7)] : [_card, _card]),
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: _answered ? [BoxShadow(color: catColor.withOpacity(0.36), blurRadius: 12, offset: const Offset(0, 4))] : [],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
                    onPressed: _answered ? _nextQuestion : null,
                    child: Text(_currentIndex < _questions.length - 1 ? 'Next →' : 'Results 🏆',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _answered ? Colors.white : _textSecondary.withOpacity(0.3))),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 2),
          ]),
        )),
      ),
    );
  }

  void _showQuitDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: _card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Text('Quit Quiz?', style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w700)),
      content: const Text('Your progress will be lost.', style: TextStyle(color: _textSecondary)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Stay', style: TextStyle(color: _accent))),
        TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('Quit', style: TextStyle(color: _wrong))),
      ],
    ));
  }
}

// ── Timer Bar ──
class _TimerBar extends StatelessWidget {
  final AnimationController controller; final Color color;
  const _TimerBar({required this.controller, required this.color});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (_, __) {
      final secsLeft = ((1 - controller.value) * _timeSec).ceil();
      final warn = secsLeft <= 7;
      final c = warn ? _timerWarn : color;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(13), border: Border.all(color: c.withOpacity(0.27))),
        child: Row(children: [
          SizedBox(width: 33, height: 33, child: CustomPaint(
            painter: _ArcPainter(progress: 1 - controller.value, color: c),
            child: Center(child: Text('$secsLeft', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: c))),
          )),
          const SizedBox(width: 10),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: 1 - controller.value, backgroundColor: _surface, color: c, minHeight: 5))),
          const SizedBox(width: 10),
          Text(warn ? '⚡ Hurry!' : '⏱ Timer', style: TextStyle(fontSize: 11, color: c, fontWeight: FontWeight.w700)),
        ]),
      );
    },
  );
}

class _ArcPainter extends CustomPainter {
  final double progress; final Color color;
  const _ArcPainter({required this.progress, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 3;
    canvas.drawCircle(c, r, Paint()..color = color.withOpacity(0.12)..strokeWidth = 3..style = PaintingStyle.stroke);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), -math.pi / 2, 2 * math.pi * progress, false,
        Paint()..color = color..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
  }
  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}

class _LifelineBtn extends StatelessWidget {
  final String label; final IconData icon; final bool used; final Color color; final VoidCallback onTap;
  const _LifelineBtn({required this.label, required this.icon, required this.used, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: used ? null : onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 170),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: used ? _card.withOpacity(0.4) : color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: used ? _textSecondary.withOpacity(0.16) : color.withOpacity(0.5)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: used ? _textSecondary.withOpacity(0.32) : color, size: 14),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: used ? _textSecondary.withOpacity(0.32) : color)),
        if (used) ...[const SizedBox(width: 3), Text('✓', style: TextStyle(color: _textSecondary.withOpacity(0.32), fontSize: 10))],
      ]),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
//  SCORE SCREEN
// ═══════════════════════════════════════════════════════════════
class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});
  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> with TickerProviderStateMixin {
  late AnimationController _mainCtrl, _confettiCtrl;
  late Animation<double> _scaleFade;
  final math.Random _rng = math.Random();
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _mainCtrl     = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
    _confettiCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2800))..repeat();
    _scaleFade    = CurvedAnimation(parent: _mainCtrl, curve: Curves.elasticOut);
    _particles    = List.generate(28, (_) => _Particle(
      x: _rng.nextDouble(), y: _rng.nextDouble(),
      size: 4 + _rng.nextDouble() * 5, speed: 0.3 + _rng.nextDouble() * 0.7,
      color: [_primary, _accent, const Color(0xFFFFD700), const Color(0xFFFF6B6B), Colors.white][_rng.nextInt(5)],
      angle: _rng.nextDouble() * 2 * math.pi,
    ));
    _mainCtrl.forward();
  }

  @override
  void dispose() { _mainCtrl.dispose(); _confettiCtrl.dispose(); super.dispose(); }

  String _getMessage(int score, int total) {
    final r = score / total;
    if (r == 1.0) return '🎉 Perfect Score!';
    if (r >= 0.8) return '🌟 Excellent!';
    if (r >= 0.6) return '👍 Good Job!';
    if (r >= 0.4) return '📚 Keep Practicing!';
    return '💪 Try Again!';
  }

  @override
  Widget build(BuildContext context) {
    final result    = ModalRoute.of(context)!.settings.arguments as QuizResult;
    final sc        = _gradeColor(result.score, result.total);
    final highScore = result.score >= result.total * 0.8;
    final isNewBest = result.score == AppState.personalBest && AppState.totalGamesPlayed > 0;
    final accuracy  = ((result.score / result.total) * 100).round();

    return Scaffold(
      body: Stack(children: [
        Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0F0E17), Color(0xFF1A1740)], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
        if (highScore) AnimatedBuilder(animation: _confettiCtrl, builder: (_, __) => CustomPaint(painter: _ConfettiPainter(particles: _particles, progress: _confettiCtrl.value), child: const SizedBox.expand())),
        SafeArea(child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
          child: Column(children: [

            if (isNewBest) ScaleTransition(scale: _scaleFade, child: Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: const Color(0xFFFFD700).withOpacity(0.1), borderRadius: BorderRadius.circular(13), border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.38))),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('🏆', style: TextStyle(fontSize: 14)),
                SizedBox(width: 8),
                Text('New Personal Best!', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.w800, fontSize: 14)),
              ]),
            )),

            Hero(tag: 'quiz-icon', child: ScaleTransition(scale: _scaleFade,
              child: Container(
                width: 124, height: 124,
                decoration: BoxDecoration(shape: BoxShape.circle, color: sc.withOpacity(0.12), border: Border.all(color: sc, width: 3)),
                child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('${result.score}', style: const TextStyle(fontSize: 46, fontWeight: FontWeight.w900, color: Colors.white, height: 1)),
                  const Text('of 10', style: TextStyle(fontSize: 12, color: _textSecondary)),
                ])),
              ),
            )),
            const SizedBox(height: 16),

            FadeTransition(opacity: _scaleFade, child: Text(_getMessage(result.score, result.total), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _textPrimary))),
            const SizedBox(height: 4),
            FadeTransition(opacity: _scaleFade, child: Text(result.category.label, style: const TextStyle(fontSize: 13, color: _textSecondary))),
            const SizedBox(height: 26),

            ScaleTransition(scale: _scaleFade, child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(18), border: Border.all(color: sc.withOpacity(0.22), width: 1.5)),
              child: Column(children: [
                _StatLine(icon: Icons.check_circle_rounded,          label: 'Correct',       value: '${result.score}',                 color: _correct),
                const _Divider(),
                _StatLine(icon: Icons.cancel_rounded,                label: 'Wrong / Timed', value: '${result.total - result.score}',   color: _wrong),
                const _Divider(),
                _StatLine(icon: Icons.local_fire_department_rounded, label: 'Best streak',   value: '${result.streakMax}',              color: const Color(0xFFFF9800)),
                const _Divider(),
                _StatLine(icon: Icons.percent_rounded,               label: 'Accuracy',      value: '$accuracy%',                       color: _accent),
              ]),
            )),
            const SizedBox(height: 20),

            ScaleTransition(scale: _scaleFade, child: SizedBox(
              width: double.infinity, height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(side: BorderSide(color: _accent.withOpacity(0.45), width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
                onPressed: () => Navigator.pushNamed(context, '/review', arguments: result),
                icon: const Icon(Icons.fact_check_rounded, color: _accent, size: 17),
                label: const Text('Review Answers', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _accent)),
              ),
            )),
            const SizedBox(height: 10),

            ScaleTransition(scale: _scaleFade, child: SizedBox(
              width: double.infinity, height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [result.category.color, result.category.color.withOpacity(0.7)]),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: result.category.color.withOpacity(0.36), blurRadius: 15, offset: const Offset(0, 6))],
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  onPressed: () => Navigator.pushReplacementNamed(context, '/quiz', arguments: result.category),
                  icon: const Icon(Icons.replay_rounded, color: Colors.white),
                  label: const Text('Play Again', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            )),
            const SizedBox(height: 10),

            ScaleTransition(scale: _scaleFade, child: SizedBox(
              width: double.infinity, height: 46,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(side: BorderSide(color: _primary.withOpacity(0.38), width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
                onPressed: () => Navigator.pushNamed(context, '/history'),
                icon: const Icon(Icons.history_rounded, color: _primary, size: 17),
                label: Text('View History  (${AppState.history.length} games)', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _primary)),
              ),
            )),
            const SizedBox(height: 10),

            ScaleTransition(scale: _scaleFade, child: SizedBox(
              width: double.infinity, height: 42,
              child: TextButton.icon(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
                icon: const Icon(Icons.home_rounded, color: _textSecondary, size: 16),
                label: const Text('Back to Home', style: TextStyle(fontSize: 13, color: _textSecondary)),
              ),
            )),
            const SizedBox(height: 10),
          ]),
        )),
      ]),
    );
  }
}

class _StatLine extends StatelessWidget {
  final IconData icon; final String label, value; final Color color;
  const _StatLine({required this.icon, required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(children: [
      Container(width: 30, height: 30, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.13)), child: Icon(icon, color: color, size: 15)),
      const SizedBox(width: 12),
      Text(label, style: const TextStyle(fontSize: 14, color: _textSecondary)),
      const Spacer(),
      Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
    ]),
  );
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => const Divider(color: Colors.white10, height: 1);
}

// ═══════════════════════════════════════════════════════════════
//  REVIEW SCREEN
// ═══════════════════════════════════════════════════════════════
class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final result = ModalRoute.of(context)!.settings.arguments as QuizResult;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(
            colors: [Color(0xFF0F0E17), Color(0xFF1C1B30)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 14, 18, 0),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: _textSecondary, size: 20), onPressed: () => Navigator.pop(context)),
              const SizedBox(width: 4),
              const Expanded(child: Text('Answer Review', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: _textPrimary))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(11), border: Border.all(color: result.category.color.withOpacity(0.4))),
                child: Text('${result.score}/${result.total}', style: TextStyle(color: result.category.color, fontWeight: FontWeight.w800, fontSize: 13)),
              ),
            ]),
          ),
          Expanded(child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            itemCount: result.questions.length,
            itemBuilder: (context, i) {
              final q  = result.questions[i];
              final ua = i < result.userAnswers.length ? result.userAnswers[i] : null;
              final isCorrect = ua == q.correctIndex;
              final isTimeout = ua == null;
              final bc = isTimeout ? _timerWarn : isCorrect ? _correct : _wrong;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(16), border: Border.all(color: bc.withOpacity(0.32), width: 1.5)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(width: 24, height: 24, decoration: BoxDecoration(shape: BoxShape.circle, color: bc.withOpacity(0.13)),
                        child: Icon(isTimeout ? Icons.timer_off_rounded : isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded, color: bc, size: 13)),
                    const SizedBox(width: 8),
                    Text('Q${i + 1}', style: const TextStyle(color: _textSecondary, fontWeight: FontWeight.w700, fontSize: 12)),
                    const Spacer(),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2), decoration: BoxDecoration(color: bc.withOpacity(0.11), borderRadius: BorderRadius.circular(6)),
                        child: Text(isTimeout ? 'Timed Out' : isCorrect ? 'Correct' : 'Wrong', style: TextStyle(color: bc, fontSize: 10, fontWeight: FontWeight.w700))),
                  ]),
                  const SizedBox(height: 8),
                  Text(q.text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary, height: 1.4)),
                  const SizedBox(height: 8),
                  _ReviewRow(label: 'Correct', text: q.options[q.correctIndex], color: _correct),
                  if (!isCorrect && !isTimeout) _ReviewRow(label: 'Your answer', text: q.options[ua!], color: _wrong),
                  if (isTimeout) _ReviewRow(label: 'Your answer', text: 'No answer — time ran out', color: _timerWarn),
                  if (q.explanation.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(9), border: Border.all(color: _accent.withOpacity(0.22))),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Icon(Icons.lightbulb_rounded, color: _accent, size: 13),
                        const SizedBox(width: 7),
                        Expanded(child: Text(q.explanation, style: const TextStyle(fontSize: 11, color: _textSecondary, height: 1.5))),
                      ]),
                    ),
                ]),
              );
            },
          )),
        ])),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label, text; final Color color;
  const _ReviewRow({required this.label, required this.text, required this.color});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 5),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2), decoration: BoxDecoration(color: color.withOpacity(0.13), borderRadius: BorderRadius.circular(5)), child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w700))),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600, height: 1.4))),
    ]),
  );
}

// ─────────────────────────────────────────────
//  CONFETTI
// ─────────────────────────────────────────────
class _Particle {
  final double x, y, size, speed, angle; final Color color;
  const _Particle({required this.x, required this.y, required this.size, required this.speed, required this.color, required this.angle});
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles; final double progress;
  const _ConfettiPainter({required this.particles, required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (p.y + progress * p.speed) % 1.0;
      final x = (p.x + math.sin(progress * 2 * math.pi * p.speed + p.angle) * 0.05) * size.width;
      final y = t * size.height;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * 4 * math.pi * p.speed);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5), const Radius.circular(2)), Paint()..color = p.color.withOpacity(0.6)..style = PaintingStyle.fill);
      canvas.restore();
    }
  }
  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}