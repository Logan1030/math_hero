import 'package:flutter/foundation.dart';
import '../../core/constants/math_data.dart';
import '../../core/constants/level_data.dart';

enum QuizState { playing, correct, wrong, levelComplete }

class GameProvider extends ChangeNotifier {
  LevelData? _currentLevel;
  List<MathProblem> _problems = [];
  int _currentProblemIndex = 0;
  int _sessionStars = 0;
  QuizState _quizState = QuizState.playing;
  int _lives = 2;
  bool _levelFinished = false;

  // User progress
  int _totalStars = 0;
  List<int> _completedLevels = [];
  List<int> _unlockedLevels = [1];

  // Getters
  LevelData? get currentLevel => _currentLevel;
  List<MathProblem> get problems => _problems;
  int get currentProblemIndex => _currentProblemIndex;
  MathProblem? get currentProblem =>
      _problems.isNotEmpty && _currentProblemIndex < _problems.length
          ? _problems[_currentProblemIndex]
          : null;
  int get sessionStars => _sessionStars;
  QuizState get quizState => _quizState;
  int get lives => _lives;
  int get maxLives => 2;
  int get totalStars => _totalStars;
  List<int> get completedLevels => _completedLevels;
  List<int> get unlockedLevels => _unlockedLevels;

  bool get isLevelComplete =>
      _currentLevel != null && _sessionStars >= _currentLevel!.targetStars;

  bool isLevelUnlocked(int levelId) => _unlockedLevels.contains(levelId);
  bool isLevelCompleted(int levelId) => _completedLevels.contains(levelId);
  int getLevelStars(int levelId) => 0; // Simplified for now

  void startLevel(int levelId) {
    final levelIndex = levelId - 1;
    if (levelIndex < 0 || levelIndex >= levels.length) return;

    _currentLevel = levels[levelIndex];
    _problems = MathProblem.generateProblems(levelId);
    _currentProblemIndex = 0;
    _sessionStars = 0;
    _quizState = QuizState.playing;
    _lives = 2;
    _levelFinished = false;
    notifyListeners();
  }

  Future<void> checkAnswer(int answer) async {
    if (currentProblem == null) return;

    if (answer == currentProblem!.answer) {
      _quizState = QuizState.correct;
      _sessionStars++;
      _lives = 2;
      notifyListeners();
    } else {
      _lives--;
      if (_lives > 0) {
        _quizState = QuizState.wrong;
        notifyListeners();
      } else {
        _quizState = QuizState.wrong;
        _lives = 2;
        _nextQuestion();
      }
    }
  }

  Future<void> continueAfterCorrect() async {
    if (isLevelComplete) {
      _quizState = QuizState.levelComplete;
    } else {
      _nextQuestion();
    }
    notifyListeners();
  }

  void _nextQuestion() {
    _currentProblemIndex++;

    if (isLevelComplete || _currentProblemIndex >= _problems.length) {
      _quizState = QuizState.levelComplete;
    } else {
      _quizState = QuizState.playing;
    }
    notifyListeners();
  }

  Future<void> finishLevel() async {
    if (_currentLevel == null || _levelFinished) return;

    _levelFinished = true;
    _totalStars += _sessionStars;

    if (isLevelComplete) {
      if (!_completedLevels.contains(_currentLevel!.id)) {
        _completedLevels.add(_currentLevel!.id);
      }
      // Unlock next level
      final nextLevel = _currentLevel!.id + 1;
      if (nextLevel <= 10 && !_unlockedLevels.contains(nextLevel)) {
        _unlockedLevels.add(nextLevel);
      }
    }

    notifyListeners();
  }

  void resetSession() {
    _currentLevel = null;
    _problems = [];
    _currentProblemIndex = 0;
    _sessionStars = 0;
    _quizState = QuizState.playing;
    _lives = 2;
    notifyListeners();
  }
}
