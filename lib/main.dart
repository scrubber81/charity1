import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charity1/theme/app_theme.dart';
import 'package:charity1/pages/onboarding_page.dart';
import 'package:charity1/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showOnboarding = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasCompletedOnboarding = prefs.getBool('onboarding_complete') ?? false;
      
      setState(() {
        _showOnboarding = !hasCompletedOnboarding;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _showOnboarding = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        home: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppTheme.backgroundColor, AppTheme.surfaceColor],
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppTheme.primaryPurple),
              ),
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Charity App',
      theme: AppTheme.lightTheme,
      home: _showOnboarding ? const OnboardingPage() : const CharityHomePage(),
    );
  }
}
