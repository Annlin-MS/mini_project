import 'package:flutter/material.dart';
import '../data/mock_database.dart';

class AdminMessageCenter extends StatefulWidget {
  @override
  _AdminMessageCenterState createState() => _AdminMessageCenterState();
}

class _AdminMessageCenterState extends State<AdminMessageCenter> {
  final TextEditingController _messageController = TextEditingController();
  String _selectedRecipientType = 'all'; // all, dealers, users
  String? _selectedDealer;
  String? _selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Recipient Selection
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Send Message To:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedRecipientType,
                      items: [
                        DropdownMenuItem(value: 'all', child: Text('All Users & Dealers')),
                        DropdownMenuItem(value: 'dealers', child: Text('Specific Dealer')),
                        DropdownMenuItem(value: 'users', child: Text('Specific User')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedRecipientType = value!;
                          _selectedDealer = null;
                          _selectedUser = null;
                        });
                      },
                    ),
                    if (_selectedRecipientType == 'dealers') ...[
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedDealer,
                        decoration: InputDecoration(labelText: 'Select Dealer'),
                        items: mockDealers.map((dealer) {
                          return DropdownMenuItem(
                            value: dealer.id,
                            child: Text(dealer.name),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedDealer = value),
                      ),
                    ],
                    if (_selectedRecipientType == 'users') ...[
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'User Ration Card Number',
                            hintText: 'Enter ration card number'
                        ),
                        onChanged: (value) => _selectedUser = value,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Message Input
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Message:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    TextField(
                      controller: _messageController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type your message here...',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Send Button
            ElevatedButton(
              onPressed: _sendMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('SEND MESSAGE', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 20),

            // Message History
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Message History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView(
                          children: [
                            ListTile(
                              leading: Icon(Icons.message, color: Colors.blue),
                              title: Text('Stock Update Notification'),
                              subtitle: Text('Sent to all dealers - Yesterday'),
                            ),
                            ListTile(
                              leading: Icon(Icons.message, color: Colors.green),
                              title: Text('Monthly Ration Announcement'),
                              subtitle: Text('Sent to all users - 2 days ago'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a message')),
      );
      return;
    }

    String recipientInfo = '';
    switch (_selectedRecipientType) {
      case 'all':
        recipientInfo = 'All users and dealers';
        break;
      case 'dealers':
        recipientInfo = _selectedDealer != null
            ? 'Dealer: ${mockDealers.firstWhere((d) => d.id == _selectedDealer).name}'
            : 'All dealers';
        break;
      case 'users':
        recipientInfo = _selectedUser != null
            ? 'User: $_selectedUser'
            : 'All users';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message sent to $recipientInfo')),
    );

    _messageController.clear();
    setState(() {
      _selectedDealer = null;
      _selectedUser = null;
    });
  }
}