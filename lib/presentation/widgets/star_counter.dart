import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class StarCounter extends StatelessWidget {
  final int current;
  final int target;

  const StarCounter({
    super.key,
    required this.current,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: AppColors.secondary, size: 20),
          const SizedBox(width: 4),
          Text(
            '$current / $target',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
