import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:charity1/theme/app_theme.dart';
import 'package:charity1/widgets/ios_card.dart';
import 'package:charity1/models/incident_model.dart';

class IncidentHistoryPage extends StatefulWidget {
  const IncidentHistoryPage({super.key});

  @override
  State<IncidentHistoryPage> createState() => _IncidentHistoryPageState();
}

class _IncidentHistoryPageState extends State<IncidentHistoryPage> {
  List<IncidentReport> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportStrings = prefs.getStringList('incident_reports') ?? [];
      
      final reports = reportStrings
          .map((json) => IncidentReport.fromJson(jsonDecode(json)))
          .toList();
      
      // Sort by timestamp (newest first)
      reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      setState(() {
        _reports = reports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Critical':
        return Colors.red;
      case 'High':
        return Colors.orange;
      case 'Medium':
        return Colors.amber;
      case 'Low':
        return Colors.green;
      default:
        return AppTheme.primaryPurple;
    }
  }

  Future<void> _deleteReport(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportStrings = prefs.getStringList('incident_reports') ?? [];
      
      reportStrings.removeWhere((json) {
        final report = IncidentReport.fromJson(jsonDecode(json));
        return report.id == id;
      });
      
      await prefs.setStringList('incident_reports', reportStrings);
      await _loadReports();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report deleted'),
          backgroundColor: AppTheme.primaryPurple,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting report: $e')),
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
        title: const Text('Incident Reports', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.backgroundColor, AppTheme.surfaceColor],
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppTheme.primaryPurple),
                ),
              )
            : _reports.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.white30,
                          size: 64,
                        ),
                        const SizedBox(height: AppTheme.spacing16),
                        const Text(
                          'No incidents reported',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    itemCount: _reports.length,
                    itemBuilder: (context, index) {
                      final report = _reports[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
                        child: IOSCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          report.eventTitle,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: AppTheme.spacing4),
                                        Text(
                                          report.timestamp,
                                          style: const TextStyle(
                                            color: AppTheme.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppTheme.spacing8,
                                      vertical: AppTheme.spacing4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getSeverityColor(report.severity).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                    ),
                                    child: Text(
                                      report.severity,
                                      style: TextStyle(
                                        color: _getSeverityColor(report.severity),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppTheme.spacing12),

                              // Category
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppTheme.spacing8,
                                      vertical: AppTheme.spacing4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryPurple.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                    ),
                                    child: Text(
                                      report.category,
                                      style: const TextStyle(
                                        color: AppTheme.primaryPurple,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppTheme.spacing8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppTheme.spacing8,
                                      vertical: AppTheme.spacing4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                    ),
                                    child: Text(
                                      report.status,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (report.isAnonymous)
                                    Padding(
                                      padding: const EdgeInsets.only(left: AppTheme.spacing8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppTheme.spacing8,
                                          vertical: AppTheme.spacing4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.purple.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                        ),
                                        child: const Text(
                                          'Anonymous',
                                          style: TextStyle(
                                            color: Colors.purple,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: AppTheme.spacing12),

                              // Description
                              Text(
                                report.description,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppTheme.spacing12),

                              // Reporter Info
                              if (!report.isAnonymous && (report.reporterName != null || report.reporterEmail != null))
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(color: Colors.white12),
                                    const SizedBox(height: AppTheme.spacing8),
                                    if (report.reporterName != null)
                                      Text(
                                        'Reported by: ${report.reporterName}',
                                        style: const TextStyle(
                                          color: AppTheme.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    if (report.reporterEmail != null)
                                      Text(
                                        'Email: ${report.reporterEmail}',
                                        style: const TextStyle(
                                          color: AppTheme.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    const SizedBox(height: AppTheme.spacing8),
                                  ],
                                ),

                              // Report ID
                              Text(
                                'Report ID: ${report.id.substring(0, 8).toUpperCase()}',
                                style: const TextStyle(
                                  color: AppTheme.textTertiary,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacing12),

                              // Delete Button
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: AppTheme.cardColor,
                                        title: const Text(
                                          'Delete Report?',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: const Text(
                                          'This action cannot be undone.',
                                          style: TextStyle(color: AppTheme.textSecondary),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _deleteReport(report.id);
                                            },
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Delete Report',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

const double spacing4 = 4.0;
