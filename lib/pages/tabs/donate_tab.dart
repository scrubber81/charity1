import 'package:flutter/material.dart';
import 'package:charity1/theme/app_theme.dart';
import 'package:charity1/widgets/ios_card.dart';
import 'package:charity1/widgets/ios_button.dart';
import 'package:charity1/constants/app_constants.dart';

class DonateTab extends StatelessWidget {
  const DonateTab({super.key});

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
            'Make a Donation',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spacing24),
          Text(
            'Select an amount:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          ...AppConstants.donationAmounts.map((amount) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
              child: IOSButton(
                label: 'Donate $amount',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for your donation of $amount!'),
                      backgroundColor: AppTheme.successGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          const SizedBox(height: AppTheme.spacing24),
          IOSCard(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why Donate?',
                  style: TextStyle(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: AppTheme.spacing8),
                Text(
                  '✓ 100% of funds go to those in need\n✓ Tax-deductible donations\n✓ Monthly impact reports\n✓ Secure transactions',
                  style: TextStyle(color: Colors.white, height: 1.8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
