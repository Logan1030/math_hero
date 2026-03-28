import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/level_data.dart';
import '../../core/theme/app_theme.dart';
import '../providers/game_provider.dart';

class WorldMapScreen extends StatelessWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB),
              Color(0xFF98FB98),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        '游戏地图',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Consumer<GameProvider>(
                      builder: (context, game, _) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: AppColors.secondary, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '${game.totalStars}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Level Grid
              Expanded(
                child: Consumer<GameProvider>(
                  builder: (context, game, _) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: levels.length,
                      itemBuilder: (context, index) {
                        final level = levels[index];
                        final isUnlocked = game.isLevelUnlocked(level.id);
                        final isCompleted = game.isLevelCompleted(level.id);

                        return _LevelCard(
                          level: level,
                          isUnlocked: isUnlocked,
                          isCompleted: isCompleted,
                          onTap: isUnlocked
                              ? () => context.go('/quiz/${level.id}')
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final LevelData level;
  final bool isUnlocked;
  final bool isCompleted;
  final VoidCallback? onTap;

  const _LevelCard({
    required this.level,
    required this.isUnlocked,
    required this.isCompleted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.white : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Level number
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.success
                          : (isUnlocked ? AppColors.primary : Colors.grey),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white)
                          : Text(
                              '${level.id}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Level name
                  Text(
                    level.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? AppColors.textPrimary : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Stars progress
                  if (isUnlocked) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: isCompleted
                              ? AppColors.secondary
                              : Colors.grey.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${level.targetStars}颗',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Lock icon
            if (!isUnlocked)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.lock,
                  size: 24,
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
