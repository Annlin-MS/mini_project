import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  final String rationCardNo;

  const NotificationScreen({required this.rationCardNo});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'type': 'entitlement',
      'title': 'Monthly Entitlements Updated',
      'message': 'Your November 2023 entitlements are now available. Check your dashboard for details.',
      'time': '2 hours ago',
      'read': false,
      'icon': Icons.shopping_basket,
      'color': Colors.green,
    },
    {
      'type': 'token',
      'title': 'Token Approved',
      'message': 'Your token #T20231120-001 has been approved. Please visit the shop on 20-Nov-2023.',
      'time': '1 day ago',
      'read': false,
      'icon': Icons.confirmation_number,
      'color': Colors.blue,
    },
    {
      'type': 'complaint',
      'title': 'Complaint Update',
      'message': 'Your complaint regarding rice quality has been resolved. Thank you for your feedback.',
      'time': '2 days ago',
      'read': true,
      'icon': Icons.support,
      'color': Colors.orange,
    },
    {
      'type': 'system',
      'title': 'System Maintenance',
      'message': 'Scheduled maintenance on Sunday, 26-Nov-2023 from 2:00 AM to 4:00 AM. System may be unavailable during this time.',
      'time': '3 days ago',
      'read': true,
      'icon': Icons.settings,
      'color': Colors.purple,
    },
    {
      'type': 'payment',
      'title': 'Payment Received',
      'message': 'Payment of ₹21.00 for token #T20231120-001 has been received successfully.',
      'time': '4 days ago',
      'read': true,
      'icon': Icons.payment,
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.purple.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.checklist),
            onPressed: _markAllAsRead,
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No notifications', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationCard(notification, index);
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    return Dismissible(
      key: Key(notification['title']),
      background: Container(color: Colors.red),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _notifications.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notification dismissed')),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: notification['read'] ? Colors.white : Colors.blue.shade50,
        child: ListTile(
          leading: Icon(
            notification['icon'],
            color: notification['color'],
          ),
          title: Text(
            notification['title'],
            style: TextStyle(
              fontWeight: notification['read'] ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification['message']),
              SizedBox(height: 4),
              Text(
                notification['time'],
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: notification['read']
              ? null
              : Icon(Icons.circle, size: 12, color: Colors.blue),
          onTap: () => _markAsRead(index),
          onLongPress: () => _showNotificationDetails(notification),
        ),
      ),
    );
  }

  void _markAsRead(int index) {
    setState(() {
      _notifications[index]['read'] = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['read'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notification Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Type', notification['type'].toUpperCase()),
              _buildDetailRow('Title', notification['title']),
              _buildDetailRow('Message', notification['message']),
              _buildDetailRow('Time', notification['time']),
              _buildDetailRow('Status', notification['read'] ? 'Read' : 'Unread'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}