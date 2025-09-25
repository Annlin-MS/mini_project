import 'package:flutter/material.dart';
import '../services/token_service.dart';
import '../data/mock_database.dart';
import '../models/token_model.dart'; // Added import

class AdminStockMonitor extends StatefulWidget {
  @override
  _AdminStockMonitorState createState() => _AdminStockMonitorState();
}

class _AdminStockMonitorState extends State<AdminStockMonitor> {
  String _selectedShop = 'shop1';

  @override
  Widget build(BuildContext context) {
    final shopIndex = mockShops.indexWhere((s) => s.id == _selectedShop);
    if (shopIndex == -1) return Scaffold(appBar: AppBar(title: Text('Error')), body: Center(child: Text('Shop not found')));

    final shop = mockShops[shopIndex];
    final stockAlerts = TokenService.getStockAlerts(_selectedShop);
    final todayTokens = TokenService.getTodayTokens(_selectedShop);

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Monitoring'),
        backgroundColor: Colors.red.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Shop Selection
            DropdownButtonFormField<String>(
              value: _selectedShop,
              decoration: InputDecoration(
                labelText: 'Select Shop',
                border: OutlineInputBorder(),
              ),
              items: mockShops.map((shop) {
                return DropdownMenuItem<String>(
                  value: shop.id,
                  child: Text(shop.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedShop = value!;
                });
              },
            ),
            SizedBox(height: 20),

            // Stock Alerts
            if ((stockAlerts['outOfStock'] as List).isNotEmpty || (stockAlerts['lowStock'] as List).isNotEmpty)
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Stock Alerts', style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange.shade800)),
                      SizedBox(height: 8),
                      if ((stockAlerts['outOfStock'] as List<String>).isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Out of Stock:', style: TextStyle(color: Colors.red)),
                            Text((stockAlerts['outOfStock'] as List<String>).join(', ')),
                            SizedBox(height: 8),
                          ],
                        ),
                      if ((stockAlerts['lowStock'] as List<Map<String, dynamic>>).isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Low Stock:', style: TextStyle(color: Colors.orange)),
                            ...(stockAlerts['lowStock'] as List<Map<String, dynamic>>).map((item) =>
                                Text('${item['item']}: ${item['current']}/${item['max']} (${item['percentage']}%)')
                            ).toList(),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 20),

            // Today's Distribution
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's Distribution", style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    if ((stockAlerts['todayDistribution'] as Map<String, double>).isEmpty)
                      Text('No distributions today'),
                    ...(stockAlerts['todayDistribution'] as Map<String, double>).entries.map((entry) =>
                        ListTile(
                          leading: Icon(Icons.shopping_basket, size: 20),
                          title: Text(entry.key),
                          trailing: Text('${entry.value.toStringAsFixed(1)} ${entry.key == 'Kerosene' ? 'L' : 'kg'}'),
                          dense: true,
                        )
                    ).toList(),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Recent Transactions
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Transactions', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Expanded(
                    child: todayTokens.isEmpty
                        ? Center(child: Text('No transactions today'))
                        : ListView.builder(
                      itemCount: todayTokens.length,
                      itemBuilder: (context, index) {
                        final token = todayTokens[index];
                        return _buildTransactionCard(token);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Token token) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          token.status == 'completed' ? Icons.check_circle : Icons.pending,
          color: token.status == 'completed' ? Colors.green : Colors.orange,
        ),
        title: Text(token.userName),
        subtitle: Text('${token.items.length} items • ₹${token.totalAmount.toStringAsFixed(2)}'),
        trailing: Chip(
          label: Text(token.status, style: TextStyle(color: Colors.white, fontSize: 12)),
          backgroundColor: _getStatusColor(token.status),
        ),
        onLongPress: () => _showTransactionDetails(token),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed': return Colors.green;
      case 'approved': return Colors.blue;
      case 'pending': return Colors.orange;
      case 'rejected': return Colors.red;
      default: return Colors.grey;
    }
  }

  void _showTransactionDetails(Token token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Token: ${token.tokenNumber}'),
              Text('User: ${token.userName}'),
              Text('Status: ${token.status}'),
              Text('Time: ${token.timeSlot}'),
              SizedBox(height: 8),
              Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...token.items.map((item) => Text('• ${item['quantity']} ${item['name']}')),
              SizedBox(height: 8),
              Text('Total: ₹${token.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              if (token.dealerNotes != null) SizedBox(height: 8),
              if (token.dealerNotes != null) Text('Dealer Notes: ${token.dealerNotes}'),
              if (token.adminNotes != null) SizedBox(height: 8),
              if (token.adminNotes != null) Text('Admin Notes: ${token.adminNotes}'),
            ],
          ),
        ),
        actions: [
          if (token.status == 'approved')
            TextButton(
              onPressed: () {
                TokenService.reportMalpractice(token.id, 'admin1', 'Suspicious transaction');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Malpractice reported')),
                );
                setState(() {});
              },
              child: Text('Report Malpractice', style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}