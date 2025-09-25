class Complaint {
  final String id;
  final String rationCardNo;
  final String userName;
  final String category;
  final String priority;
  final String description;
  final DateTime timestamp;
  final String status; // pending, in_progress, resolved, closed
  final String? adminResponse;
  final DateTime? responseTimestamp;
  final String? assignedTo;
  final List<String> attachments;

  Complaint({
    required this.id,
    required this.rationCardNo,
    required this.userName,
    required this.category,
    required this.priority,
    required this.description,
    required this.timestamp,
    required this.status,
    this.adminResponse,
    this.responseTimestamp,
    this.assignedTo,
    this.attachments = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rationCardNo': rationCardNo,
      'userName': userName,
      'category': category,
      'priority': priority,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'adminResponse': adminResponse,
      'responseTimestamp': responseTimestamp?.toIso8601String(),
      'assignedTo': assignedTo,
      'attachments': attachments,
    };
  }

  factory Complaint.fromMap(Map<String, dynamic> map) {
    return Complaint(
      id: map['id'],
      rationCardNo: map['rationCardNo'],
      userName: map['userName'],
      category: map['category'],
      priority: map['priority'],
      description: map['description'],
      timestamp: DateTime.parse(map['timestamp']),
      status: map['status'],
      adminResponse: map['adminResponse'],
      responseTimestamp: map['responseTimestamp'] != null
          ? DateTime.parse(map['responseTimestamp'])
          : null,
      assignedTo: map['assignedTo'],
      attachments: List<String>.from(map['attachments'] ?? []),
    );
  }

  Complaint copyWith({
    String? status,
    String? adminResponse,
    DateTime? responseTimestamp,
    String? assignedTo,
  }) {
    return Complaint(
      id: id,
      rationCardNo: rationCardNo,
      userName: userName,
      category: category,
      priority: priority,
      description: description,
      timestamp: timestamp,
      status: status ?? this.status,
      adminResponse: adminResponse ?? this.adminResponse,
      responseTimestamp: responseTimestamp ?? this.responseTimestamp,
      assignedTo: assignedTo ?? this.assignedTo,
      attachments: attachments,
    );
  }
}
