import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:charity1/theme/app_theme.dart';
import 'package:charity1/widgets/ios_card.dart';
import 'package:charity1/utils/date_utils.dart' as date_utils;

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  late DateTime _selectedDate;
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = _normalizeDate(DateTime.now());
    _focusedMonth = _normalizeDate(DateTime.now());
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

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
  };

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
            'Event Calendar',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spacing20),
          _buildCalendarCard(),
          const SizedBox(height: AppTheme.spacing24),
          _buildEventsList(),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    return IOSCard(
      child: Column(
        children: [
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
                date_utils.DateUtils.getMonthYear(_focusedMonth),
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
          const SizedBox(height: AppTheme.spacing16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: date_utils.DateUtils.weekdays.map((day) {
              return SizedBox(
                width: 40,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppTheme.spacing12),
          _buildCalendarGrid(),
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

    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox(width: 40, height: 40));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final hasEvents = _hasEventsOnDate(date);
      final isSelected = date_utils.DateUtils.isSameDay(date, _selectedDate);
      final isToday = date_utils.DateUtils.isSameDay(date, _normalizeDate(DateTime.now()));

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = _normalizeDate(date);
            });
          },
          child: Container(
            width: 35,
            height: 35,
            margin: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryPurple : (isToday ? AppTheme.primaryPurple.withOpacity(0.3) : Colors.transparent),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isToday && !isSelected ? AppTheme.primaryPurple : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    color: isSelected ? Colors.white : (isToday ? Colors.white : AppTheme.textSecondary),
                    fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
                if (hasEvents)
                  Positioned(
                    bottom: 2,
                    child: Container(
                      width: 3,
                      height: 3,
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

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 1.8,
      ),
      itemCount: dayWidgets.length,
      itemBuilder: (context, index) => dayWidgets[index],
    );
  }

  Widget _buildEventsList() {
    final eventsForDay = _getEventsForDate(_selectedDate);

    if (eventsForDay.isEmpty) {
      return IOSCard(
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacing24),
            child: Column(
              children: [
                Icon(
                  CupertinoIcons.calendar_badge_minus,
                  color: Colors.white30,
                  size: 48,
                ),
                SizedBox(height: AppTheme.spacing12),
                Text(
                  'No events scheduled',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
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
          padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
          child: IOSCard(
            child: _buildEventCard(event),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEventCard(Map<String, String> event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing8, vertical: AppTheme.spacing4),
              decoration: BoxDecoration(
                color: _getEventColor(event['type']!).withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
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
              color: AppTheme.textSecondary,
              size: 16,
            ),
            const SizedBox(width: AppTheme.spacing4),
            Text(
              event['time']!,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing12),
        Text(
          event['title']!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Row(
          children: [
            const Icon(
              CupertinoIcons.location_solid,
              color: AppTheme.textSecondary,
              size: 14,
            ),
            const SizedBox(width: 6.0),
            Text(
              event['location']!,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool _hasEventsOnDate(DateTime date) {
    return _events.keys.any((eventDate) => date_utils.DateUtils.isSameDay(eventDate, date));
  }

  List<Map<String, String>> _getEventsForDate(DateTime date) {
    final dateKey = _events.keys.firstWhere(
      (key) => date_utils.DateUtils.isSameDay(key, date),
      orElse: () => DateTime(1900),
    );
    return _events[dateKey] ?? [];
  }

  Color _getEventColor(String type) {
    return AppTheme.eventTypeColors[type] ?? AppTheme.primaryPurple;
  }
}
