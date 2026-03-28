import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../../core/constants/level_data.dart';
import '../../core/theme/app_theme.dart';
import '../providers/game_provider.dart';

class ResultScreen extends StatefulWidget {
  final int levelId;

  const ResultScreen({super.key, required this.levelId});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final game = context.read<GameProvider>();
      game.finishLevel();

      if (game.isLevelComplete) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final levelIndex = widget.levelId - 1;
    final level = levels[levelIndex];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.7),
                ],
              ),
            ),
            child: SafeArea(
              child: Consumer<GameProvider>(
                builder: (context, game, _) {
                  final isPass = game.isLevelComplete;
                  final earnedStars = game.sessionStars;

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Trophy/Star
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              isPass ? Icons.emoji_events : Icons.star,
                              size: 64,
                              color: isPass ? AppColors.secondary : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Title
                          Text(
                            isPass ? '恭喜通关！' : '继续加油！',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Level name
                          Text(
                            level.name,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Stars collected
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: AppColors.secondary,
                                  size: 32,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '+${earnedStars}',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 48),
                          // Buttons
                          if (isPass && widget.levelId < 10)
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  context.go('/quiz/${widget.levelId + 1}');
                                },
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('下一关'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                context.go('/world-map');
                              },
                              icon: const Icon(Icons.map),
                              label: const Text('返回地图'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () {
                              context.go('/quiz/${widget.levelId}');
                            },
                            icon: const Icon(Icons.replay, color: Colors.white70),
                            label: const Text(
                              '再玩一次',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.2,
              shouldLoop: false,
              colors: const [
                AppColors.secondary,
                AppColors.primary,
                AppColors.success,
                Colors.pink,
                Colors.orange,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
