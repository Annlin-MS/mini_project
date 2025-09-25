import 'package:flutter/material.dart';

class EntitlementsScreen extends StatelessWidget {
  final String rationCardNo;
  final String cardType;
  final Map<String, dynamic> currentMonthEntitlement;

  const EntitlementsScreen({
    required this.rationCardNo,
    required this.cardType,
    required this.currentMonthEntitlement,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Entitlements'),
        backgroundColor: _getCardColor(cardType),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Current Month - ${currentMonthEntitlement['month']}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    ...currentMonthEntitlement['items'].map<Widget>((item) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${item['quantity']} @ ${item['price']}'),
                          ],
                        ),
                      );
                    }).toList(),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Value:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('₹${currentMonthEntitlement['totalValue']}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Entitlement History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildHistoryItem('November 2023', '35kg Rice, 15kg Wheat', '₹135.00'),
                  _buildHistoryItem('October 2023', '35kg Rice, 15kg Wheat', '₹135.00'),
                  _buildHistoryItem('September 2023', '35kg Rice, 15kg Wheat', '₹135.00'),
                  _buildHistoryItem('August 2023', '35kg Rice, 15kg Wheat', '₹135.00'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String month, String items, String amount) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: Colors.blue),
        title: Text(month),
        subtitle: Text(items),
        trailing: Text(amount, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _getCardColor(String cardType) {
    switch (cardType) {
      case 'AAY': return Colors.yellow;
      case 'PHH': return Colors.white;
      case 'BPL': return Colors.pink;
      case 'APL': return Colors.blue;
      default: return Colors.grey;
    }
  }
}