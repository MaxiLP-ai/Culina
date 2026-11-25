import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class CategoryChipItem extends StatelessWidget {
  final String label;
  final String icon;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChipItem({
    super.key,
    required this.label,
    required this.icon,
    required this.count,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeBg = isDark ? const Color(0xFFDDA743) : AppColors.darkButton;
    final activeText = isDark ? Colors.black : Colors.white;
    final inactiveBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isSelected ? activeBg : (isDark ? AppColors.borderDark : AppColors.border);
    final textColor = isSelected ? activeText : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);
    final countColor = isSelected ? activeText.withValues(alpha: 0.8) : (isDark ? AppColors.textSecondaryDark : AppColors.textMuted);

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : inactiveBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.12 : (isDark ? 0.2 : 0.02)),
              blurRadius: isSelected ? 6 : 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon.isNotEmpty) ...[
              Text(
                icon,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: textColor,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black.withValues(alpha: 0.15) : (isDark ? const Color(0xFF282522) : const Color(0xFFF3EFEA)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: countColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
