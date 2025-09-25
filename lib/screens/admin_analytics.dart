import 'package:flutter/material.dart';
import '../data/mock_database.dart';

class AdminAnalytics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('System Analytics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          // Add analytics content here
          Expanded(
            child: Center(
              child: Text('Analytics dashboard coming soon...',
                  style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}