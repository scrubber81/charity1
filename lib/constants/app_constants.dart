class AppConstants {
  // Contact Information
  static const String charityEmail = 'info@charity.org';
  static const String charityPhone = '+44 7762 277 440';
  static const String charityPhoneDisplay = '+44 7762 277 440';
  static const String charityWebsite = 'www.charity.org';

  // Strings
  static const String appTitle = 'Charity App';
  static const String charityMission = 'Your donations directly help the peterhead and local communities';
  
  // Impact Stats
  static const int livesImpacted = 50000;
  static const int projectsCompleted = 200;
  static const int charityEventsRan = 100;

  // Campaign Progress
  static const double campaignProgress = 0.75;
  static const String campaignProgressText = '75% of Goal Reached';

  // Onboarding Screen Titles & Descriptions
  static const List<Map<String, String>> onboardingPages = [
    {
      'title': 'Make a Real Impact',
      'description': 'Your donations directly help the peterhead and local communities',
    },
    {
      'title': 'Join Our Community',
      'description': 'Connect with thousands of changemakers and supporters like you.',
    },
    {
      'title': 'Track Your Impact',
      'description': 'See exactly how your contributions are transforming lives in Scotland.',
    },
    {
      'title': 'Helping Together',
      'description': 'Every donation matters. Join us in building a better tomorrow.',
    },
  ];

  // Donation Amounts
  static const List<String> donationAmounts = ['\$10', '\$25', '\$50', '\$100', 'Custom'];

  // Scan Types
  static const List<String> scanTypes = [
    'Event Check-in',
    'Donation Station',
    'Partner Location'
  ];

  // Reward Tiers
  static const List<Map<String, int>> rewardTiers = [
    {'title_index': 0, 'min': 0, 'max': 100},
    {'title_index': 1, 'min': 100, 'max': 250},
    {'title_index': 2, 'min': 250, 'max': 500},
    {'title_index': 3, 'min': 500, 'max': 1000},
  ];

  static const List<String> rewardTierNames = [
    'Bronze Member',
    'Silver Member',
    'Gold Member',
    'Platinum Member'
  ];

  // Scan Points
  static const List<int> scanPoints = [10, 25, 50];

  // Tab Names
  static const List<String> tabNames = ['Home', 'Events', 'Scan', 'Info', 'Donate'];

  // Animation Durations
  static const Duration animationShortDuration = Duration(milliseconds: 250);
  static const Duration animationMediumDuration = Duration(milliseconds: 300);
  static const Duration animationLongDuration = Duration(milliseconds: 500);

  // Message Templates
  static const String scanSuccessMessage = 'You earned {points} reward points!\n\n{scanType}';
  static const String donationThankYou = 'Thank you for your donation of {amount}!';
  static const String eventRegistration = 'Registered for {eventTitle}!';
}
