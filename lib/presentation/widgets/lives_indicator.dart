import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class LivesIndicator extends StatelessWidget {
  final int current;
  final int max;

  const LivesIndicator({
    super.key,
    required this.current,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(max, (index) {
        final isActive = index < current;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            Icons.favorite,
            color: isActive ? AppColors.error : Colors.grey.shade400,
            size: 24,
          ),
        );
      }),
    );
  }
}
