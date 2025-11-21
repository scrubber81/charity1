import 'package:flutter/material.dart';
import 'package:charity1/theme/app_theme.dart';

class IOSCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const IOSCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppTheme.spacing16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
