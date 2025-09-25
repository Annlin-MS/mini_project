import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/complaint_model.dart';
import '../services/complaint_service.dart';

class AdminComplaintManagement extends StatefulWidget {
  @override
  _AdminComplaintManagementState createState() => _AdminComplaintManagementState();
}

class _AdminComplaintManagementState extends State<AdminComplaintManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPriorityFilter = 'all';
  String _selectedCategoryFilter = 'all';
  List<Complaint> _complaints = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadComplaints();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadComplaints() {
    setState(() {
      _complaints = ComplaintService.getAllComplaints();
    });
  }

  int _getNewComplaintsCount() {
    return _complaints.where((c) => c.status == 'pending').length;
  }

  @override
  Widget build(BuildContext context) {
    final newComplaintsCount = _getNewComplaintsCount();

    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Management'),
        backgroundColor: Colors.red.shade700,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New'),
                  if (newComplaintsCount > 0) ...[
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                      child: Text(
                        newComplaintsCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(text: 'In Progress'),
            Tab(text: 'Resolved'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildComplaintsList('pending'),
                _buildComplaintsList('in_progress'),
                _buildComplaintsList('resolved'),
                _buildComplaintsList('all'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              value: _selectedPriorityFilter,
              isExpanded: true,
              onChanged: (value) => setState(() => _selectedPriorityFilter = value!),
              items: [
                DropdownMenuItem(value: 'all', child: Text('All Priorities')),
                DropdownMenuItem(value: 'high', child: Text('High Priority')),
                DropdownMenuItem(value: 'medium', child: Text('Medium Priority')),
                DropdownMenuItem(value: 'low', child: Text('Low Priority')),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: DropdownButton<String>(
              value: _selectedCategoryFilter,
              isExpanded: true,
              onChanged: (value) => setState(() => _selectedCategoryFilter = value!),
              items: [
                DropdownMenuItem(value: 'all', child: Text('All Categories')),
                DropdownMenuItem(value: 'quality', child: Text('Quality Issues')),
                DropdownMenuItem(value: 'shortage', child: Text('Shortage/Delivery')),
                DropdownMenuItem(value: 'behavior', child: Text('Staff Behavior')),
                DropdownMenuItem(value: 'payment', child: Text('Payment Issues')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintsList(String statusFilter) {
    List<Complaint> filteredComplaints = _complaints.where((complaint) {
      bool statusMatch = statusFilter == 'all' || complaint.status == statusFilter;
      bool priorityMatch = _selectedPriorityFilter == 'all' || complaint.priority == _selectedPriorityFilter;
      bool categoryMatch = _selectedCategoryFilter == 'all' || complaint.category == _selectedCategoryFilter;
      return statusMatch && priorityMatch && categoryMatch;
    }).toList();

    // Sort by timestamp (newest first)
    filteredComplaints.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (filteredComplaints.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No complaints found', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredComplaints.length,
      itemBuilder: (context, index) {
        final complaint = filteredComplaints[index];
        return _buildComplaintCard(complaint);
      },
    );
  }

  Widget _buildComplaintCard(Complaint complaint) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getPriorityColor(complaint.priority),
          child: Icon(
            _getCategoryIcon(complaint.category),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          'ID: ${complaint.id}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${complaint.userName} • ${complaint.rationCardNo}'),
            Text('${_getCategoryLabel(complaint.category)} • ${_formatDateTime(complaint.timestamp)}'),
          ],
        ),
        trailing: _buildStatusChip(complaint.status),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(complaint.description),
                SizedBox(height: 16),

                if (complaint.adminResponse != null) ...[
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Admin Response:', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(complaint.adminResponse!),
                        if (complaint.responseTimestamp != null)
                          Text(
                            'Response on: ${DateFormat('dd MMM yyyy, HH:mm').format(complaint.responseTimestamp!)}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],

                if (complaint.status == 'pending' || complaint.status == 'in_progress')
                  _buildActionButtons(complaint),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Complaint complaint) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (complaint.status == 'pending')
          ElevatedButton.icon(
            onPressed: () => _assignComplaint(complaint),
            icon: Icon(Icons.assignment_ind, size: 16),
            label: Text('Assign'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ElevatedButton.icon(
          onPressed: () => _respondToComplaint(complaint),
          icon: Icon(Icons.reply, size: 16),
          label: Text('Respond'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        if (complaint.status != 'resolved')
          ElevatedButton.icon(
            onPressed: () => _resolveComplaint(complaint),
            icon: Icon(Icons.check_circle, size: 16),
            label: Text('Resolve'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),
        ElevatedButton.icon(
          onPressed: () => _escalateComplaint(complaint),
          icon: Icon(Icons.priority_high, size: 16),
          label: Text('Escalate'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        icon = Icons.pending;
        break;
      case 'in_progress':
        color = Colors.blue;
        icon = Icons.work;
        break;
      case 'resolved':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'rejected':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          SizedBox(width: 4),
          Text(status.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
      backgroundColor: color,
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high': return Colors.red;
      case 'medium': return Colors.orange;
      case 'low': return Colors.green;
      default: return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'quality': return Icons.warning;
      case 'shortage': return Icons.inventory;
      case 'behavior': return Icons.people;
      case 'payment': return Icons.payment;
      case 'other': return Icons.help;
      default: return Icons.report;
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'quality': return 'Quality Issue';
      case 'shortage': return 'Shortage/Delivery';
      case 'behavior': return 'Staff Behavior';
      case 'payment': return 'Payment Issue';
      case 'other': return 'Other';
      default: return 'Unknown';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return '${difference.inMinutes} min ago';
    }
  }

  void _assignComplaint(Complaint complaint) {
    String? selectedAdmin;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assign Complaint'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Assign this complaint to:'),
            SizedBox(height: 16),
            StatefulBuilder(
              builder: (context, setDialogState) {
                return DropdownButton<String>(
                  hint: Text('Select Admin'),
                  value: selectedAdmin,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(value: 'admin1', child: Text('Admin 1')),
                    DropdownMenuItem(value: 'admin2', child: Text('Admin 2')),
                    DropdownMenuItem(value: 'admin3', child: Text('Admin 3')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedAdmin = value;
                    });
                  },
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: selectedAdmin != null ? () {
              ComplaintService.updateComplaintStatus(
                complaint.id,
                'in_progress',
                assignedTo: selectedAdmin,
              );
              _loadComplaints();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Complaint assigned successfully')),
              );
            } : null,
            child: Text('Assign'),
          ),
        ],
      ),
    );
  }

  void _respondToComplaint(Complaint complaint) {
    final responseController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Respond to Complaint'),
        content: TextField(
          controller: responseController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter your response...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (responseController.text.isNotEmpty) {
                ComplaintService.updateComplaintStatus(
                  complaint.id,
                  'in_progress',
                  adminResponse: responseController.text,
                );
                _loadComplaints();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Response added successfully')),
                );
              }
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _resolveComplaint(Complaint complaint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resolve Complaint'),
        content: Text('Mark this complaint as resolved?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ComplaintService.updateComplaintStatus(complaint.id, 'resolved');
              _loadComplaints();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Complaint resolved successfully')),
              );
            },
            child: Text('Resolve'),
          ),
        ],
      ),
    );
  }

  void _escalateComplaint(Complaint complaint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Escalate Complaint'),
        content: Text('This complaint will be escalated to higher authorities. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Complaint escalated to higher authorities'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('Escalate'),
          ),
        ],
      ),
    );
  }
}
