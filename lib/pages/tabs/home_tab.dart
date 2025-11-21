import 'package:flutter/material.dart';
import 'package:charity1/theme/app_theme.dart';
import 'package:charity1/widgets/ios_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spacing20),
          IOSCard(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Making a Difference',
                  style: TextStyle(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: AppTheme.spacing12),
                Text(
                  'Our mission is to help the local community',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: AppTheme.spacing16),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          IOSCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Campaign Progress',
                  style: TextStyle(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  child: const LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation(AppTheme.primaryPurple),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                const Text(
                  '75% of Goal Reached',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          IOSCard(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Information',
                  style: TextStyle(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: AppTheme.spacing8),
                Text(
                  'Email: info@charity.org\nPhone: +44 7762 277 440',
                  style: TextStyle(color: AppTheme.textSecondary, height: 1.8),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),
          Text(
            'Recent Updates',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          ...List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
              child: IOSCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Update ${index + 1}',
                      style: const TextStyle(
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    const Text(
                      'Great progress on our latest initiative. Thank you for your support!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
