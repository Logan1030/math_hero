import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/game_provider.dart';
import '../widgets/star_counter.dart';
import '../widgets/lives_indicator.dart';
import '../widgets/option_button.dart';

class QuizScreen extends StatefulWidget {
  final int levelId;

  const QuizScreen({super.key, required this.levelId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _selectedAnswer;
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().startLevel(widget.levelId);
    });
  }

  void _onAnswerSelected(int answer, GameProvider game) async {
    if (_showFeedback) return;

    setState(() {
      _selectedAnswer = answer;
      _showFeedback = true;
    });

    await game.checkAnswer(answer);

    if (game.quizState == QuizState.levelComplete) {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        context.go('/result/${widget.levelId}');
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        setState(() {
          _selectedAnswer = null;
          _showFeedback = false;
        });
        await game.continueAfterCorrect();
        
        // Check if level is now complete after continueAfterCorrect
        if (game.quizState == QuizState.levelComplete) {
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            context.go('/result/${widget.levelId}');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF9800),
              Color(0xFFFFB74D),
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<GameProvider>(
            builder: (context, game, _) {
              final level = game.currentLevel;
              final problem = game.currentProblem;

              if (level == null || problem == null) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              return Stack(
                children: [
                  Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => _showExitDialog(context),
                              icon: const Icon(Icons.close, color: Colors.white),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    level.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  StarCounter(
                                    current: game.sessionStars,
                                    target: level.targetStars,
                                  ),
                                ],
                              ),
                            ),
                            LivesIndicator(
                              current: game.lives,
                              max: game.maxLives,
                            ),
                          ],
                        ),
                      ),
                      // Question area
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Question
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    problem.question,
                                    style: const TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 48),
                                // Options
                                GridView.count(
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1.5,
                                  children: problem.options.map((option) {
                                    return OptionButton(
                                      text: '$option',
                                      isSelected: _selectedAnswer == option,
                                      isCorrect: _showFeedback &&
                                          option == problem.answer,
                                      isWrong: _showFeedback &&
                                          _selectedAnswer == option &&
                                          option != problem.answer,
                                      onTap: () => _onAnswerSelected(option, game),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Feedback overlay
                  if (_showFeedback)
                    _FeedbackOverlay(
                      isCorrect: game.quizState == QuizState.correct,
                      answer: problem.answer,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出游戏？'),
        content: const Text('你的进度将不会保存'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/world-map');
            },
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }
}

class _FeedbackOverlay extends StatelessWidget {
  final bool isCorrect;
  final int answer;

  const _FeedbackOverlay({
    required this.isCorrect,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isCorrect
                      ? AppColors.success.withOpacity(0.2)
                      : AppColors.error.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrect ? Icons.check : Icons.close,
                  size: 48,
                  color: isCorrect ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isCorrect ? '太棒了！' : '正确答案：$answer',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isCorrect ? '获得 1 颗星星' : '再试一次',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              if (isCorrect) ...[
                const SizedBox(height: 8),
                const Icon(
                  Icons.star,
                  color: AppColors.secondary,
                  size: 32,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
