import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final int? badgeCount;
  final bool isPrimary;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.badgeCount,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isPrimary
        ? (isDark ? AppColors.darkPrimary : AppColors.primary)
        : (isDark ? AppColors.darkSurface2 : AppColors.surface2);
    final iconColor = isPrimary
        ? Colors.white
        : (isDark ? AppColors.darkText2 : AppColors.text2);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onPressed: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
        ),
        if (badgeCount != null && badgeCount! > 0)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.danger,
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? AppColors.darkSurface : Colors.white, width: 2),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$badgeCount',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
