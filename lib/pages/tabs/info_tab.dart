import 'package:flutter/material.dart';
import 'package:charity1/theme/app_theme.dart';
import 'package:charity1/widgets/ios_card.dart';
import 'package:charity1/constants/app_constants.dart';

class InfoTab extends StatelessWidget {
  const InfoTab({super.key});

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
            'About Us',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          IOSCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Our Mission',
                  style: TextStyle(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                const Text(
                  'We are dedicated to supporting vulnerable communities across the United Kingdom. Through partnerships with local organisations, we tackle homelessness, food poverty, mental health crises, and social isolation.',
                  style: TextStyle(color: Colors.white, height: 1.5),
                ),
                const SizedBox(height: AppTheme.spacing16),
                const Text(
                  'Our Impact',
                  style: TextStyle(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  '• ${AppConstants.livesImpacted} Lives Impacted\n• ${AppConstants.projectsCompleted} Projects Completed\n• ${AppConstants.charityEventsRan} Charity Events Ran',
                  style: const TextStyle(color: Colors.white, height: 1.8),
                ),
                const SizedBox(height: AppTheme.spacing16),
                const Text(
                  'Get In Touch',
                  style: TextStyle(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'Email: ${AppConstants.charityEmail}\nPhone: ${AppConstants.charityPhone}\nWebsite: ${AppConstants.charityWebsite}',
                  style: const TextStyle(color: Colors.white, height: 1.8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
