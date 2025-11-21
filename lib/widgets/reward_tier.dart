import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charity1/theme/app_theme.dart';

class RewardTierWidget extends StatelessWidget {
  final String title;
  final int minPoints;
  final int maxPoints;
  final int currentPoints;

  const RewardTierWidget({
    super.key,
    required this.title,
    required this.minPoints,
    required this.maxPoints,
    required this.currentPoints,
  });

  @override
  Widget build(BuildContext context) {
    bool isUnlocked = currentPoints >= minPoints;
    bool isCurrent = currentPoints >= minPoints && currentPoints < maxPoints;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: Row(
        children: [
          Icon(
            isUnlocked ? CupertinoIcons.checkmark_seal_fill : CupertinoIcons.lock_fill,
            color: isUnlocked ? AppTheme.warningAmber : AppTheme.textDisabled,
            size: 20,
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isUnlocked ? AppTheme.textPrimary : AppTheme.textSecondary,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$minPoints - $maxPoints points',
                  style: const TextStyle(
                    color: AppTheme.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing8, vertical: AppTheme.spacing4),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: const Text(
                'Current',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
