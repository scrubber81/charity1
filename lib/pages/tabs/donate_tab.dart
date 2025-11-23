import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:charity1/theme/app_theme.dart';
import 'package:charity1/widgets/ios_card.dart';
import 'package:charity1/utils/date_utils.dart' as date_utils;

class DonateTab extends StatefulWidget {
  const DonateTab({super.key});

  @override
  State<DonateTab> createState() => _DonateTabState();
}

class _DonateTabState extends State<DonateTab> {
  int _totalDonated = 0;
  int _donationCount = 0;
  bool _isRecurring = false;
  String? _selectedAmount;
  List<Map<String, dynamic>> _donationHistory = [];

  @override
  void initState() {
    super.initState();
    _loadDonationHistory();
  }

  Future<void> _loadDonationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList('donation_history') ?? [];

      int total_amount = 0;
      final donations = <Map<String, dynamic>>[];

      for (var entry in history) {
        final data = jsonDecode(entry) as Map<String, dynamic>;
        donations.add(data);
        total_amount += (data['amount'] as int);
      }

      setState(() {
        _donationHistory = donations;
        _totalDonated = total_amount;
        _donationCount = donations.length;
      });
    } catch (e) {
      print('Error loading donation history: $e');
    }
  }

  void _showCustomDonationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String customAmount = '';
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          title: const Text(
            'Custom Donation',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter amount in £',
              hintStyle: const TextStyle(color: AppTheme.textSecondary),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppTheme.primaryPurple),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppTheme.primaryPurple, width: 2),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
            ),
            onChanged: (value) => customAmount = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                if (customAmount.isNotEmpty) {
                  final amount = int.tryParse(customAmount);
                  if (amount != null && amount > 0) {
                    Navigator.pop(context);
                    _recordDonation(amount);
                  }
                }
              },
              child: const Text('Donate', style: TextStyle(color: AppTheme.primaryPurple)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _recordDonation(int amount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList('donation_history') ?? [];

      final donation = {
        'amount': amount,
        'date': date_utils.DateUtils.formatTime(DateTime.now()),
        'recurring': _isRecurring,
      };

      history.add(jsonEncode(donation));
      final newTotal = _totalDonated + amount;

      await prefs.setStringList('donation_history', history);
      await prefs.setInt('total_donated', newTotal);

      await _loadDonationHistory();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Thank you for your donation of £$amount!${_isRecurring ? ' (Recurring)' : ''}',
          ),
          backgroundColor: AppTheme.successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          duration: const Duration(seconds: 3),
        ),
      );

      setState(() => _selectedAmount = null);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error recording donation: $e')),
      );
    }
  }

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
          // Header
          Text(
            'Make a Donation',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spacing16),

          // Impact Stats
          _buildImpactStats(),
          const SizedBox(height: AppTheme.spacing24),

          // Where Money Goes
          _buildImpactBreakdown(),
          const SizedBox(height: AppTheme.spacing24),

          // Donation Amounts
          Text(
            'Select an Amount:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          _buildDonationAmounts(),
          const SizedBox(height: AppTheme.spacing16),

          // Recurring Donation
          IOSCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Make it Recurring',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      _isRecurring ? 'Monthly donation enabled' : 'Set up monthly donations',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _isRecurring,
                  onChanged: (value) => setState(() => _isRecurring = value),
                  activeColor: AppTheme.primaryPurple,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Why Donate
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
                SizedBox(height: AppTheme.spacing12),
                _DonationBenefit(
                  icon: '✓',
                  title: '100% Transparent',
                  description: 'See exactly where your money goes',
                ),
                SizedBox(height: AppTheme.spacing8),
                _DonationBenefit(
                  icon: '✓',
                  title: 'Tax-Deductible',
                  description: 'Registered charity organization',
                ),
                SizedBox(height: AppTheme.spacing8),
                _DonationBenefit(
                  icon: '✓',
                  title: 'Monthly Reports',
                  description: 'Track your impact over time',
                ),
                SizedBox(height: AppTheme.spacing8),
                _DonationBenefit(
                  icon: '✓',
                  title: 'Secure Transactions',
                  description: 'Your data is protected',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Donation History
          if (_donationHistory.isNotEmpty) ...[
            Text(
              'Your Donation History',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            _buildDonationHistory(),
            const SizedBox(height: AppTheme.spacing24),
          ],
        ],
      ),
    );
  }

  Widget _buildImpactStats() {
    return Row(
      children: [
        Expanded(
          child: IOSCard(
            child: Column(
              children: [
                Text(
                  '$_donationCount',
                  style: const TextStyle(
                    color: AppTheme.primaryPurple,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                const Text(
                  'Donations',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacing12),
        Expanded(
          child: IOSCard(
            child: Column(
              children: [
                Text(
                  '£$_totalDonated',
                  style: const TextStyle(
                    color: AppTheme.successGreen,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                const Text(
                  'Total Donated',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImpactBreakdown() {
    return IOSCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Where Your Money Goes',
            style: TextStyle(
              color: AppTheme.primaryPurple,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          _buildImpactItem('Food & Supplies', 40, Colors.green),
          const SizedBox(height: AppTheme.spacing12),
          _buildImpactItem('Community Programs', 30, Colors.blue),
          const SizedBox(height: AppTheme.spacing12),
          _buildImpactItem('Staff & Operations', 20, Colors.orange),
          const SizedBox(height: AppTheme.spacing12),
          _buildImpactItem('Emergency Relief', 10, Colors.red),
        ],
      ),
    );
  }

  Widget _buildImpactItem(String title, int percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildDonationAmounts() {
    return Wrap(
      spacing: AppTheme.spacing12,
      runSpacing: AppTheme.spacing12,
      children: [
        for (final amount in [10, 25, 50, 100, 250])
          SizedBox(
            width: (MediaQuery.of(context).size.width - AppTheme.spacing32 - (AppTheme.spacing12 * 4)) / 5,
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedAmount = '$amount');
                _recordDonation(amount);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spacing14,
                  horizontal: AppTheme.spacing8,
                ),
                decoration: BoxDecoration(
                  color: _selectedAmount == '$amount'
                      ? AppTheme.primaryPurple
                      : AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(
                    color: _selectedAmount == '$amount'
                        ? AppTheme.primaryPurple
                        : Colors.white.withOpacity(0.1),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '£$amount',
                      style: TextStyle(
                        color: _selectedAmount == '$amount'
                            ? Colors.white
                            : AppTheme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        SizedBox(
          width: (MediaQuery.of(context).size.width - AppTheme.spacing32 - (AppTheme.spacing12 * 4)) / 5,
          child: GestureDetector(
            onTap: _showCustomDonationDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppTheme.spacing14,
                horizontal: AppTheme.spacing8,
              ),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 2,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Custom',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDonationHistory() {
    return Column(
      children: _donationHistory.take(5).toList().asMap().entries.map((entry) {
        final donation = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
          child: IOSCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '£${donation['amount']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      donation['date'] as String,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (donation['recurring'] as bool)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing8,
                      vertical: AppTheme.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: const Text(
                      'Monthly',
                      style: TextStyle(
                        color: AppTheme.primaryPurple,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing8,
                      vertical: AppTheme.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: const Text(
                      'One-time',
                      style: TextStyle(
                        color: AppTheme.successGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DonationBenefit extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const _DonationBenefit({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          icon,
          style: const TextStyle(
            color: AppTheme.successGreen,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: AppTheme.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
