class IncidentReport {
  final String id;
  final String eventTitle;
  final String category;
  final String severity;
  final String description;
  final String timestamp;
  final bool isAnonymous;
  final String? reporterName;
  final String? reporterEmail;
  final String status;

  IncidentReport({
    required this.id,
    required this.eventTitle,
    required this.category,
    required this.severity,
    required this.description,
    required this.timestamp,
    required this.isAnonymous,
    this.reporterName,
    this.reporterEmail,
    this.status = 'Submitted',
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventTitle': eventTitle,
      'category': category,
      'severity': severity,
      'description': description,
      'timestamp': timestamp,
      'isAnonymous': isAnonymous,
      'reporterName': reporterName,
      'reporterEmail': reporterEmail,
      'status': status,
    };
  }

  // Create from JSON
  factory IncidentReport.fromJson(Map<String, dynamic> json) {
    return IncidentReport(
      id: json['id'] as String,
      eventTitle: json['eventTitle'] as String,
      category: json['category'] as String,
      severity: json['severity'] as String,
      description: json['description'] as String,
      timestamp: json['timestamp'] as String,
      isAnonymous: json['isAnonymous'] as bool,
      reporterName: json['reporterName'] as String?,
      reporterEmail: json['reporterEmail'] as String?,
      status: json['status'] as String? ?? 'Submitted',
    );
  }
}
