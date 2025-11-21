import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:charity1/theme/app_theme.dart';
import 'package:charity1/widgets/ios_card.dart';
import 'package:charity1/widgets/reward_tier.dart';
import 'package:charity1/utils/date_utils.dart' as date_utils;
import 'package:charity1/constants/app_constants.dart';

class ScanTab extends StatefulWidget {
  const ScanTab({super.key});

  @override
  State<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  int _totalPoints = 0;
  final List<Map<String, dynamic>> _scanHistory = [];

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
            'Scan QR Codes',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spacing20),
          _buildPointsCard(),
          const SizedBox(height: AppTheme.spacing24),
          _buildQRScannerButton(),
          const SizedBox(height: AppTheme.spacing24),
          _buildScanHistory(),
          const SizedBox(height: AppTheme.spacing24),
          _buildRewardsTiers(),
        ],
      ),
    );
  }

  Widget _buildPointsCard() {
    return IOSCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Reward Points',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.star_fill,
                    color: AppTheme.warningAmber,
                    size: 28,
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Text(
                    '$_totalPoints',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: const Icon(
              CupertinoIcons.gift_fill,
              color: AppTheme.primaryPurple,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRScannerButton() {
    return GestureDetector(
      onTap: _simulateQRScan,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryPurple.withOpacity(0.3),
              AppTheme.secondaryPurple.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: AppTheme.primaryPurple.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppTheme.radiusXL),
              ),
              child: const Icon(
                CupertinoIcons.qrcode_viewfinder,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: AppTheme.spacing16),
            const Text(
              'Tap to Scan QR Code',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            const Text(
              'Earn points for each scan',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Scan History',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '${_scanHistory.length} scans',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing12),
        if (_scanHistory.isEmpty)
          IOSCard(
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.spacing16),
                child: Text(
                  'No scans yet. Start scanning to earn rewards!',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        else
          ...List.generate(_scanHistory.length, (index) {
            final scan = _scanHistory[_scanHistory.length - 1 - index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
              child: IOSCard(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: const Icon(
                        CupertinoIcons.checkmark_circle_fill,
                        color: AppTheme.successGreen,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scan['type'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          Text(
                            scan['time'] as String,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+${scan['points']} pts',
                      style: const TextStyle(
                        color: AppTheme.warningAmber,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildRewardsTiers() {
    return IOSCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rewards Tiers',
            style: TextStyle(
              color: AppTheme.primaryPurple,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          ...List.generate(
            AppConstants.rewardTierNames.length,
            (index) {
              final tier = AppConstants.rewardTiers[index];
              return RewardTierWidget(
                title: AppConstants.rewardTierNames[index],
                minPoints: tier['min']!,
                maxPoints: tier['max']!,
                currentPoints: _totalPoints,
              );
            },
          ),
        ],
      ),
    );
  }

  void _simulateQRScan() {
    final random = DateTime.now().millisecondsSinceEpoch % 3;
    final points = AppConstants.scanPoints[random];

    setState(() {
      _totalPoints += points;
      _scanHistory.add({
        'type': AppConstants.scanTypes[random],
        'points': points,
        'time': date_utils.DateUtils.formatTime(DateTime.now()),
      });
    });

    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.checkmark_circle_fill, color: AppTheme.successGreen, size: 24),
            SizedBox(width: AppTheme.spacing8),
            Text('Success!'),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: AppTheme.spacing12),
          child: Text(
            'You earned $points reward points!\n\n${AppConstants.scanTypes[random]}',
            style: const TextStyle(fontSize: 15),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Great!'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
