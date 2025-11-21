import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Charity App',
      theme: ThemeData(
        useMaterial3: true,
        platform: TargetPlatform.iOS,
      ),
      home: const OnboardingPage1(),
    );
  }
}

// -------------------- ONBOARDING --------------------

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(
        pages: [
          OnboardingPageModel(
            title: 'Make a Real Impact',
            description: 'Your donations directly help communities in need around the world.',
            imageUrl: 'https://i.ibb.co/cJqsPSB/scooter.png',
            bgColor: Colors.indigo,
          ),
          OnboardingPageModel(
            title: 'Join Our Community',
            description: 'Connect with thousands of changemakers and supporters like you.',
            imageUrl: 'https://i.ibb.co/LvmZypG/storefront-illustration-2.png',
            bgColor: const Color(0xff1eb090),
          ),
          OnboardingPageModel(
            title: 'Track Your Impact',
            description: 'See exactly how your contributions are transforming lives.',
            imageUrl: 'https://i.ibb.co/420D7VP/building.png',
            bgColor: const Color(0xfffeae4f),
          ),
          OnboardingPageModel(
            title: 'Together We Rise',
            description: 'Every donation matters. Join us in building a better tomorrow.',
            imageUrl: 'https://i.ibb.co/cJqsPSB/scooter.png',
            bgColor: Colors.purple,
          ),
        ],
        onFinish: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const CharityHomePage(),
            ),
            (Route<dynamic> route) => false,
          );
        },
      ),
    );
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter({
    super.key,
    required this.pages,
    this.onSkip,
    this.onFinish,
  });

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: widget.pages[_currentPage].bgColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final item = widget.pages[idx];
                    return Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Image.network(item.imageUrl),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  item.title,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: item.textColor,
                                      ),
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(maxWidth: 280),
                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                                child: Text(
                                  item.description,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: item.textColor,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.pages.map((item) {
                  int index = widget.pages.indexOf(item);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: _currentPage == index ? 30 : 8,
                    height: 8,
                    margin: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        widget.onFinish?.call();
                      },
                      child: const Text("Skip", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        if (_currentPage == widget.pages.length - 1) {
                          widget.onFinish?.call();
                        } else {
                          _pageController.animateToPage(
                            _currentPage + 1,
                            curve: Curves.easeInOutCubic,
                            duration: const Duration(milliseconds: 250),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            _currentPage == widget.pages.length - 1 ? "Finish" : "Next",
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _currentPage == widget.pages.length - 1 ? CupertinoIcons.checkmark : CupertinoIcons.forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPageModel {
  final String title;
  final String description;
  final String imageUrl;
  final Color bgColor;
  final Color textColor;

  OnboardingPageModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.bgColor = Colors.blue,
    this.textColor = Colors.white,
  });
}

// -------------------- CHARITY HOME PAGE --------------------

class CharityHomePage extends StatefulWidget {
  const CharityHomePage({super.key});

  @override
  State<CharityHomePage> createState() => _CharityHomePageState();
}

class _CharityHomePageState extends State<CharityHomePage> with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  final List<String> tabs = ['Home', 'Events', 'Scan', 'Info', 'Donate'];
  late AnimationController _tabAnimationController;
  int _totalPoints = 0;
  final List<Map<String, dynamic>> _scanHistory = [];
  
  // Calendar state
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  
  // Fake events data
  final Map<DateTime, List<Map<String, String>>> _events = {
    DateTime(2025, 11, 21): [
      {'title': 'Food Drive Kickoff', 'time': '9:00 AM', 'location': 'Community Center', 'type': 'Collection'},
      {'title': 'Volunteer Orientation', 'time': '2:00 PM', 'location': 'Main Office', 'type': 'Training'},
    ],
    DateTime(2025, 11, 23): [
      {'title': 'Weekend Clothing Drive', 'time': '10:00 AM', 'location': 'City Park', 'type': 'Collection'},
    ],
    DateTime(2025, 11, 25): [
      {'title': 'Thanksgiving Meal Prep', 'time': '8:00 AM', 'location': 'Kitchen Facility', 'type': 'Volunteer'},
      {'title': 'Community Dinner', 'time': '5:00 PM', 'location': 'Community Hall', 'type': 'Event'},
    ],
    DateTime(2025, 11, 27): [
      {'title': 'Monthly Board Meeting', 'time': '6:00 PM', 'location': 'Conference Room', 'type': 'Meeting'},
    ],
    DateTime(2025, 11, 30): [
      {'title': 'Youth Mentorship Program', 'time': '11:00 AM', 'location': 'Youth Center', 'type': 'Program'},
      {'title': 'Fundraising Gala Planning', 'time': '3:00 PM', 'location': 'Main Office', 'type': 'Meeting'},
    ],
    DateTime(2025, 12, 5): [
      {'title': 'Winter Coat Distribution', 'time': '9:00 AM', 'location': 'Distribution Center', 'type': 'Event'},
    ],
    DateTime(2025, 12, 10): [
      {'title': 'Holiday Toy Drive', 'time': '10:00 AM', 'location': 'Shopping Mall', 'type': 'Collection'},
      {'title': 'Gift Wrapping Workshop', 'time': '2:00 PM', 'location': 'Community Center', 'type': 'Workshop'},
    ],
    DateTime(2025, 12, 15): [
      {'title': 'Annual Fundraising Gala', 'time': '7:00 PM', 'location': 'Grand Ballroom', 'type': 'Fundraiser'},
    ],
    DateTime(2025, 12, 20): [
      {'title': 'Holiday Food Basket Prep', 'time': '8:00 AM', 'location': 'Warehouse', 'type': 'Volunteer'},
    ],
    DateTime(2025, 12, 24): [
      {'title': 'Christmas Eve Service', 'time': '6:00 PM', 'location': 'Main Hall', 'type': 'Event'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
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
            colors: [Color(0xff0f1419), Color(0xff1a1f2e)],
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
                  color: const Color(0xff0f1419).withOpacity(0.95),
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
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(tabs.length, (index) {
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
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? Colors.deepPurpleAccent.withOpacity(0.2) : Colors.transparent,
            ),
            child: Text(
              tabs[index],
              style: TextStyle(
                color: isSelected ? Colors.deepPurpleAccent : Colors.white60,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 3,
            width: isSelected ? 30 : 0,
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
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
        return _buildHomeTab();
      case 1:
        return _buildEventsTab();
      case 2:
        return _buildScanTab();
      case 3:
        return _buildInfoTab();
      case 4:
        return _buildDonateTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
          const SizedBox(height: 20),
          _buildIOSCard(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Making a Difference',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Our mission is to help communities in need. Join us in making the world a better place.',
                  style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildIOSCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Campaign Progress',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation(Colors.deepPurpleAccent),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '75% of Goal Reached',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildIOSCard(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Information',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Email: info@charity.org\nPhone: +1 (800) 123-4567',
                  style: TextStyle(color: Colors.white70, height: 1.8),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Recent Updates',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildIOSCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Update ${index + 1}',
                      style: const TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Great progress on our latest initiative. Thank you for your support!',
                      style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
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

  Widget _buildDonateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
          const SizedBox(height: 24),
          Text(
            'Select an amount:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 12),
          ...['\$10', '\$25', '\$50', '\$100', 'Custom'].map((amount) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildIOSButton('Donate $amount', () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Thank you for your donation of $amount!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }),
            );
          }).toList(),
          const SizedBox(height: 24),
          _buildIOSCard(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why Donate?',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
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

  Widget _buildIOSCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff1e1e2e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildIOSButton(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Calendar',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          
          // Calendar Card
          _buildIOSCard(
            child: Column(
              children: [
                // Month Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
                        });
                      },
                      child: const Icon(CupertinoIcons.chevron_left, color: Colors.white, size: 24),
                    ),
                    Text(
                      _getMonthYear(_focusedMonth),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
                        });
                      },
                      child: const Icon(CupertinoIcons.chevron_right, color: Colors.white, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Weekday Headers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) {
                    return SizedBox(
                      width: 40,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                
                // Calendar Grid
                _buildCalendarGrid(),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Selected Date Events
          Text(
            _isSameDay(_selectedDate, DateTime.now()) 
                ? 'Today\'s Events' 
                : 'Events on ${_formatDate(_selectedDate)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          
          // Events List for Selected Date
          _buildEventsList(),
        ],
      ),
    );
  }
  
  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final startingWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;
    
    List<Widget> dayWidgets = [];
    
    // Add empty spaces for days before month starts
    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox(width: 40, height: 40));
    }
    
    // Add days of month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final hasEvents = _hasEventsOnDate(date);
      final isSelected = _isSameDay(date, _selectedDate);
      final isToday = _isSameDay(date, DateTime.now());
      
      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected 
                  ? Colors.deepPurpleAccent 
                  : isToday 
                      ? Colors.deepPurpleAccent.withOpacity(0.3)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isToday && !isSelected
                    ? Colors.deepPurpleAccent
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    color: isSelected 
                        ? Colors.white 
                        : isToday
                            ? Colors.white
                            : Colors.white70,
                    fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                if (hasEvents)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.amber,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Wrap(
      spacing: 0,
      runSpacing: 0,
      children: dayWidgets,
    );
  }
  
  Widget _buildEventsList() {
    final eventsForDay = _getEventsForDate(_selectedDate);
    
    if (eventsForDay.isEmpty) {
      return _buildIOSCard(
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              children: [
                Icon(
                  CupertinoIcons.calendar_badge_minus,
                  color: Colors.white30,
                  size: 48,
                ),
                SizedBox(height: 12),
                Text(
                  'No events scheduled',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Column(
      children: eventsForDay.map((event) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildIOSCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getEventColor(event['type']!).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        event['type']!,
                        style: TextStyle(
                          color: _getEventColor(event['type']!),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      CupertinoIcons.time,
                      color: Colors.white60,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event['time']!,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  event['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.location_solid,
                      color: Colors.white60,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      event['location']!,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildIOSButton('Register', () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Registered for ${event['title']}!'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurpleAccent, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('More info about ${event['title']}'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Details',
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
  
  bool _hasEventsOnDate(DateTime date) {
    return _events.keys.any((eventDate) => _isSameDay(eventDate, date));
  }
  
  List<Map<String, String>> _getEventsForDate(DateTime date) {
    final dateKey = _events.keys.firstWhere(
      (key) => _isSameDay(key, date),
      orElse: () => DateTime(1900),
    );
    return _events[dateKey] ?? [];
  }
  
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }
  
  String _getMonthYear(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
  
  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
  
  Color _getEventColor(String type) {
    switch (type) {
      case 'Collection':
        return Colors.blue;
      case 'Training':
        return Colors.orange;
      case 'Volunteer':
        return Colors.green;
      case 'Event':
        return Colors.purple;
      case 'Meeting':
        return Colors.red;
      case 'Program':
        return Colors.teal;
      case 'Workshop':
        return Colors.pink;
      case 'Fundraiser':
        return Colors.amber;
      default:
        return Colors.deepPurpleAccent;
    }
  }

  Widget _buildScanTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
          const SizedBox(height: 20),
          
          // Points Display Card
          _buildIOSCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Reward Points',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.star_fill,
                          color: Colors.amber,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    CupertinoIcons.gift_fill,
                    color: Colors.deepPurpleAccent,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // QR Scanner Button
          GestureDetector(
            onTap: _simulateQRScan,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurpleAccent.withOpacity(0.3),
                    Colors.purpleAccent.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.deepPurpleAccent.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      CupertinoIcons.qrcode_viewfinder,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tap to Scan QR Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Earn points for each scan',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Rewards Info
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
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Scan History List
          if (_scanHistory.isEmpty)
            _buildIOSCard(
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No scans yet. Start scanning to earn rewards!',
                    style: TextStyle(
                      color: Colors.white70,
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
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildIOSCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          CupertinoIcons.checkmark_circle_fill,
                          color: Colors.green,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
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
                            const SizedBox(height: 4),
                            Text(
                              scan['time'] as String,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '+${scan['points']} pts',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          
          const SizedBox(height: 24),
          
          // Rewards Tiers
          _buildIOSCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rewards Tiers',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRewardTier('Bronze Member', 0, 100),
                _buildRewardTier('Silver Member', 100, 250),
                _buildRewardTier('Gold Member', 250, 500),
                _buildRewardTier('Platinum Member', 500, 1000),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardTier(String title, int minPoints, int maxPoints) {
    bool isUnlocked = _totalPoints >= minPoints;
    bool isCurrent = _totalPoints >= minPoints && _totalPoints < maxPoints;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            isUnlocked ? CupertinoIcons.checkmark_seal_fill : CupertinoIcons.lock_fill,
            color: isUnlocked ? Colors.amber : Colors.white30,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isUnlocked ? Colors.white : Colors.white60,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$minPoints - $maxPoints points',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Current',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _simulateQRScan() {
    // Simulate QR code scanning with random points
    final random = DateTime.now().millisecondsSinceEpoch % 3;
    final scanTypes = ['Event Check-in', 'Donation Station', 'Partner Location'];
    final points = [10, 25, 50][random];
    
    setState(() {
      _totalPoints += points;
      _scanHistory.add({
        'type': scanTypes[random],
        'points': points,
        'time': _formatTime(DateTime.now()),
      });
    });
    
    // Show success feedback
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.checkmark_circle_fill, color: Colors.green, size: 24),
            SizedBox(width: 8),
            Text('Success!'),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            'You earned $points reward points!\n\n${scanTypes[random]}',
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

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${time.month}/${time.day}/${time.year} $hour:${time.minute.toString().padLeft(2, '0')} $period';
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
          const SizedBox(height: 16),
          _buildIOSCard(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our Mission',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'We are dedicated to creating positive change in communities worldwide.',
                  style: TextStyle(color: Colors.white, height: 1.5),
                ),
                SizedBox(height: 16),
                Text(
                  'Our Impact',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• 50,000+ Lives Impacted\n• 200+ Projects Completed\n• 100+ Countries Reached',
                  style: TextStyle(color: Colors.white, height: 1.8),
                ),
                SizedBox(height: 16),
                Text(
                  'Get In Touch',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Email: info@charity.org\nPhone: +1 (800) 123-4567\nWebsite: www.charity.org',
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