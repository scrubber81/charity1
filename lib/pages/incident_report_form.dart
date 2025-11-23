import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:charity1/theme/app_theme.dart';
import 'package:charity1/widgets/ios_card.dart';
import 'package:charity1/widgets/ios_button.dart';
import 'package:charity1/models/incident_model.dart';
import 'package:charity1/utils/date_utils.dart' as date_utils;

class IncidentReportForm extends StatefulWidget {
  final String eventTitle;

  const IncidentReportForm({super.key, required this.eventTitle});

  @override
  State<IncidentReportForm> createState() => _IncidentReportFormState();
}

class _IncidentReportFormState extends State<IncidentReportForm> {
  final _descriptionController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String _selectedCategory = 'Safety Concern';
  String _selectedSeverity = 'Medium';
  bool _isAnonymous = false;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Safety Concern',
    'Harassment',
    'Accident',
    'Missing Person',
    'Medical Emergency',
    'Suspicious Activity',
    'Other',
  ];

  final List<String> _severities = [
    'Low',
    'Medium',
    'High',
    'Critical',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe the incident'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final report = IncidentReport(
        id: const Uuid().v4(),
        eventTitle: widget.eventTitle,
        category: _selectedCategory,
        severity: _selectedSeverity,
        description: _descriptionController.text,
        timestamp: date_utils.DateUtils.formatTime(DateTime.now()),
        isAnonymous: _isAnonymous,
        reporterName: _isAnonymous ? null : _nameController.text.isEmpty ? null : _nameController.text,
        reporterEmail: _isAnonymous ? null : _emailController.text.isEmpty ? null : _emailController.text,
      );

      final prefs = await SharedPreferences.getInstance();
      final reports = prefs.getStringList('incident_reports') ?? [];
      reports.add(jsonEncode(report.toJson()));
      await prefs.setStringList('incident_reports', reports);

      if (!mounted) return;

      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incident #${report.id.substring(0, 8)} reported successfully'),
          backgroundColor: AppTheme.successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting report: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Report Incident', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.backgroundColor, AppTheme.surfaceColor],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Title
              IOSCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Event',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      widget.eventTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Category
              Text(
                'Category *',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing12),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  underline: const SizedBox(),
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: AppTheme.cardColor,
                  items: _categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategory = value ?? _selectedCategory);
                  },
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Severity
              Text(
                'Severity Level *',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing12),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: DropdownButton<String>(
                  value: _selectedSeverity,
                  isExpanded: true,
                  underline: const SizedBox(),
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: AppTheme.cardColor,
                  items: _severities.map((sev) {
                    return DropdownMenuItem(
                      value: sev,
                      child: Text(sev),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedSeverity = value ?? _selectedSeverity);
                  },
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Description
              Text(
                'Description *',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Describe what happened...',
                    hintStyle: TextStyle(color: AppTheme.textSecondary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(AppTheme.spacing12),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Anonymous Toggle
              IOSCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Report Anonymously',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing4),
                        Text(
                          _isAnonymous ? 'Your identity will not be shared' : 'We\'ll keep your contact info private',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isAnonymous,
                      onChanged: (value) => setState(() => _isAnonymous = value),
                      activeColor: AppTheme.primaryPurple,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Name Field
              if (!_isAnonymous) ...[
                Text(
                  'Your Name',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Enter your name (optional)',
                      hintStyle: TextStyle(color: AppTheme.textSecondary),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(AppTheme.spacing12),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing16),

                // Email Field
                Text(
                  'Your Email',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Enter your email (optional)',
                      hintStyle: TextStyle(color: AppTheme.textSecondary),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(AppTheme.spacing12),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing16),
              ],

              // Submit Button
              IOSButton(
                label: 'Submit Report',
                onPressed: _submitReport,
                isLoading: _isSubmitting,
              ),
              const SizedBox(height: AppTheme.spacing12),

              // Help Text
              Center(
                child: Text(
                  'Your report helps us keep events safe',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const double spacing4 = 4.0;
