import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:charity1/theme/app_theme.dart';
import 'package:charity1/constants/app_constants.dart';
import 'package:charity1/pages/tabs/home_tab.dart';
import 'package:charity1/pages/tabs/events_tab.dart';
import 'package:charity1/pages/tabs/scan_tab.dart';
import 'package:charity1/pages/tabs/info_tab.dart';
import 'package:charity1/pages/tabs/donate_tab.dart';

class CharityHomePage extends StatefulWidget {
  const CharityHomePage({super.key});

  @override
  State<CharityHomePage> createState() => _CharityHomePageState();
}

class _CharityHomePageState extends State<CharityHomePage> with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  late AnimationController _tabAnimationController;

  @override
  void initState() {
    super.initState();
    _tabAnimationController = AnimationController(
      duration: AppTheme.animationLongDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabAnimationController.dispose();
    super.dispose();
  }

  void _selectTab(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    _tabAnimationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.backgroundColor, AppTheme.surfaceColor],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ScaleTransition(
                  scale: Tween(begin: 0.95, end: 1.0).animate(
                    CurvedAnimation(parent: _tabAnimationController, curve: Curves.easeOutCubic),
                  ),
                  child: FadeTransition(
                    opacity: Tween(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(parent: _tabAnimationController, curve: Curves.easeOutCubic),
                    ),
                    child: _buildTabContent(),
                  ),
                ),
              ),
              // iOS-style Bottom Tab Bar
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor.withOpacity(0.95),
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 0.5,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(AppConstants.tabNames.length, (index) {
                        return _buildIOSTabButton(index);
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIOSTabButton(int index) {
    bool isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () => _selectTab(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: AppTheme.animationMediumDuration,
            curve: Curves.easeInOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16, vertical: AppTheme.spacing8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              color: isSelected ? AppTheme.primaryPurple.withOpacity(0.2) : Colors.transparent,
            ),
            child: Text(
              AppConstants.tabNames[index],
              style: TextStyle(
                color: isSelected ? AppTheme.primaryPurple : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing4),
          AnimatedContainer(
            duration: AppTheme.animationMediumDuration,
            height: 3,
            width: isSelected ? 30 : 0,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return const HomeTab();
      case 1:
        return const EventsTab();
      case 2:
        return const ScanTab();
      case 3:
        return const InfoTab();
      case 4:
        return const DonateTab();
      default:
        return const SizedBox.shrink();
    }
  }
}
