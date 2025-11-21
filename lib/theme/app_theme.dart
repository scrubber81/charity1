import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryPurple = Colors.deepPurpleAccent;
  static const Color secondaryPurple = Colors.purpleAccent;
  static const Color backgroundColor = Color(0xff0f1419);
  static const Color surfaceColor = Color(0xff1a1f2e);
  static const Color cardColor = Color(0xff1e1e2e);

  // Accent Colors
  static const Color successGreen = Colors.green;
  static const Color warningAmber = Colors.amber;
  static const Color errorRed = Colors.red;
  static const Color infoBlue = Colors.blue;

  // Event Type Colors
  static const Map<String, Color> eventTypeColors = {
    'Collection': Colors.blue,
    'Training': Colors.orange,
    'Volunteer': Colors.green,
    'Event': Colors.purple,
    'Meeting': Colors.red,
    'Program': Colors.teal,
    'Workshop': Colors.pink,
    'Fundraiser': Colors.amber,
  };

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textTertiary = Colors.white60;
  static const Color textDisabled = Colors.white30;

  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXL = 20.0;

  // Animation Durations
  static const Duration animationShortDuration = Duration(milliseconds: 250);
  static const Duration animationMediumDuration = Duration(milliseconds: 300);
  static const Duration animationLongDuration = Duration(milliseconds: 500);

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      platform: TargetPlatform.iOS,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: textTertiary,
          fontSize: 12,
        ),
      ),
    );
  }
}
