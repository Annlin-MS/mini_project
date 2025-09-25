import '../models/complaint_model.dart';
import '../data/mock_database.dart';

class ComplaintService {
  // Mock storage for complaints
  static List<Complaint> _mockComplaints = [
    Complaint(
      id: 'complaint1',
      rationCardNo: 'AAY001234',
      userName: 'John Doe',
      category: 'quality',
      priority: 'high',
      description: 'The rice quality was very poor. Found stones and dirt in the rice packet.',
      timestamp: DateTime.now().subtract(Duration(days: 2)),
      status: 'resolved',
      adminResponse: 'We have contacted the supplier and ensured quality control. New stock has been arranged.',
      responseTimestamp: DateTime.now().subtract(Duration(days: 1)),
      assignedTo: 'admin1',
    ),
    Complaint(
      id: 'complaint2',
      rationCardNo: 'BPL005678',
      userName: 'Priya Sharma',
      category: 'shortage',
      priority: 'medium',
      description: 'Did not receive the full quantity of wheat that was allocated for this month.',
      timestamp: DateTime.now().subtract(Duration(hours: 5)),
      status: 'in_progress',
      assignedTo: 'admin1',
    ),
    Complaint(
      id: 'complaint3',
      rationCardNo: 'APL009876',
      userName: 'Raj Kumar',
      category: 'behavior',
      priority: 'low',
      description: 'The dealer was rude and unhelpful during my visit.',
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
      status: 'pending',
    ),
  ];

  static List<Complaint> getAllComplaints() {
    return _mockComplaints;
  }

  static List<Complaint> getComplaintsByStatus(String status) {
    return _mockComplaints.where((complaint) => complaint.status == status).toList();
  }

  static List<Complaint> getComplaintsByPriority(String priority) {
    return _mockComplaints.where((complaint) => complaint.priority == priority).toList();
  }

  static List<Complaint> getComplaintsByCategory(String category) {
    return _mockComplaints.where((complaint) => complaint.category == category).toList();
  }

  static Future<void> submitComplaint(Complaint complaint) async {
    // Simulate API delay
    await Future.delayed(Duration(seconds: 1));

    _mockComplaints.add(complaint);
    print('Complaint submitted: ${complaint.id}');
  }

  static Future<void> updateComplaintStatus(String complaintId, String status, {
    String? adminResponse,
    String? assignedTo,
  }) async {
    await Future.delayed(Duration(milliseconds: 500));

    final index = _mockComplaints.indexWhere((c) => c.id == complaintId);
    if (index != -1) {
      _mockComplaints[index] = _mockComplaints[index].copyWith(
        status: status,
        adminResponse: adminResponse,
        responseTimestamp: adminResponse != null ? DateTime.now() : null,
        assignedTo: assignedTo,
      );
    }
  }

  static Complaint? getComplaintById(String id) {
    try {
      return _mockComplaints.firstWhere((complaint) => complaint.id == id);
    } catch (e) {
      return null;
    }
  }

  static Map<String, int> getComplaintStats() {
    return {
      'total': _mockComplaints.length,
      'pending': _mockComplaints.where((c) => c.status == 'pending').length,
      'in_progress': _mockComplaints.where((c) => c.status == 'in_progress').length,
      'resolved': _mockComplaints.where((c) => c.status == 'resolved').length,
      'closed': _mockComplaints.where((c) => c.status == 'closed').length,
      'high_priority': _mockComplaints.where((c) => c.priority == 'high').length,
      'medium_priority': _mockComplaints.where((c) => c.priority == 'medium').length,
      'low_priority': _mockComplaints.where((c) => c.priority == 'low').length,
    };
  }

  static List<Map<String, dynamic>> getCategoryBreakdown() {
    final categories = ['quality', 'shortage', 'behavior', 'payment', 'other'];
    return categories.map((category) {
      final count = _mockComplaints.where((c) => c.category == category).length;
      return {
        'category': category,
        'count': count,
        'label': _getCategoryLabel(category),
      };
    }).toList();
  }

  static String _getCategoryLabel(String category) {
    switch (category) {
      case 'quality': return 'Quality Issue';
      case 'shortage': return 'Shortage/Delivery';
      case 'behavior': return 'Staff Behavior';
      case 'payment': return 'Payment Issue';
      case 'other': return 'Other';
      default: return category;
    }
  }
}
