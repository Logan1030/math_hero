import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  const OptionButton({
    super.key,
    required this.text,
    this.isSelected = false,
    this.isCorrect = false,
    this.isWrong = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    Color textColor = AppColors.textPrimary;

    if (isCorrect) {
      backgroundColor = AppColors.success.withOpacity(0.2);
      borderColor = AppColors.success;
      textColor = AppColors.success;
    } else if (isWrong) {
      backgroundColor = AppColors.error.withOpacity(0.2);
      borderColor = AppColors.error;
      textColor = AppColors.error;
    } else if (isSelected) {
      backgroundColor = AppColors.primary.withOpacity(0.1);
      borderColor = AppColors.primary;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
