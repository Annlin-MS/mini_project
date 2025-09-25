import 'package:flutter/material.dart';
import '../models/token_model.dart';
import '../models/dealer_model.dart';
import '../models/shop_model.dart';
import '../models/payment_model.dart';
import '../data/mock_database.dart';
import 'dealer_create_token.dart';
import 'shop_time_management.dart';
import '../services/token_service.dart';
import 'manual_cash_payment.dart';

class DealerDashboardPage extends StatefulWidget {
  final String dealerId;
  final String dealerName;

  const DealerDashboardPage({
    Key? key,
    required this.dealerId,
    required this.dealerName,
  }) : super(key: key);

  @override
  _DealerDashboardPageState createState() => _DealerDashboardPageState();
}

class _DealerDashboardPageState extends State<DealerDashboardPage> {
  int _currentIndex = 0;
  late Dealer _currentDealer;

  // Dynamic AppBar titles for dealer tabs
  final List<String> _appBarTitles = [
    'Dealer Dashboard',    // Overview tab
    'Manage Tokens',       // Tokens tab
    'Shop Management',     // Shop/Inventory tab
    'Sales Reports',       // Reports tab
  ];

  @override
  void initState() {
    super.initState();
    _currentDealer = mockDealers.firstWhere(
          (dealer) => dealer.id == widget.dealerId,
      orElse: () => Dealer(
        id: '',
        name: 'Unknown Dealer',
        shopId: '',
        shopName: 'Unknown Shop',
        licenseNumber: '',
        phone: '',
        email: '',
        address: '',
        licenseExpiry: DateTime.now(),
        status: 'inactive',
      ),
    );
  }

  List<Token> _getTodayTokens() {
    final today = DateTime.now();
    final todayFormatted = '${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}';
    return mockTokens
        .where((token) => token.shopId == _currentDealer.shopId && token.date == todayFormatted)
        .toList();
  }

  Map<String, dynamic> _calculateTokenStats(List<Token> tokens) {
    final pending = tokens.where((t) => t.status == 'confirmed').length;
    final completed = tokens.where((t) => t.status == 'completed').length;
    final cancelled = tokens.where((t) => t.status == 'cancelled').length;
    final totalRevenue = tokens
        .where((t) => t.status == 'completed')
        .fold(0.0, (sum, token) => sum + (token.totalAmount ?? 0));

    return {
      'pending': pending,
      'completed': completed,
      'cancelled': cancelled,
      'total': tokens.length,
      'revenue': totalRevenue,
    };
  }

  bool _isShopOpen(Shop shop) {
    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final openingTime = shop.openingHours['open'] ?? '09:00';
    final closingTime = shop.openingHours['close'] ?? '18:00';

    return currentTime.compareTo(openingTime) >= 0 && currentTime.compareTo(closingTime) <= 0;
  }

  @override
  Widget build(BuildContext context) {
    final todayTokens = _getTodayTokens();
    final tokenStats = _calculateTokenStats(todayTokens);
    final shop = mockShops.firstWhere(
          (s) => s.id == _currentDealer.shopId,
      orElse: () => mockShops.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_currentIndex]), // Dynamic title
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotifications,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: _getCurrentTab(_currentIndex, todayTokens, tokenStats, shop),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
        onPressed: _navigateToCreateToken,
        backgroundColor: Colors.orange.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.orange.shade700,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Overview'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Tokens'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Reports'),
        ],
      ),
    );
  }

  Widget _getCurrentTab(int index, List<Token> todayTokens, Map<String, dynamic> tokenStats, Shop shop) {
    switch (index) {
      case 0:
        return _buildOverviewTab(todayTokens, tokenStats, shop);
      case 1:
        return _buildTokensTab(todayTokens);
      case 2:
        return _buildShopTab(shop);
      case 3:
        return _buildReportsTab();
      default:
        return _buildOverviewTab(todayTokens, tokenStats, shop);
    }
  }

  Widget _buildOverviewTab(List<Token> todayTokens, Map<String, dynamic> tokenStats, Shop shop) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Welcome, ${_currentDealer.name}!',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Shop: ${_currentDealer.shopName}'),
                  Text('License: ${_currentDealer.licenseNumber}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Today's Statistics
          const Text('Today\'s Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard('Total Tokens', tokenStats['total'].toString(), Icons.list_alt, Colors.blue),
              const SizedBox(width: 12),
              _buildStatCard('Pending', tokenStats['pending'].toString(), Icons.access_time, Colors.orange),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard('Completed', tokenStats['completed'].toString(), Icons.check_circle, Colors.green),
              const SizedBox(width: 12),
              _buildStatCard('Revenue', '₹${tokenStats['revenue']}', Icons.attach_money, Colors.purple),
            ],
          ),
          const SizedBox(height: 20),

          // Quick Actions
          const Text('Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildActionCard('Create Token', Icons.add, Colors.blue, _navigateToCreateToken),
              _buildActionCard('Manage Time', Icons.schedule, Colors.green, _navigateToTimeManagement),
              _buildActionCard('Cash Payment', Icons.payment, Colors.orange, _navigateToCashPayment),
              _buildActionCard('View Reports', Icons.analytics, Colors.purple, () {
                setState(() => _currentIndex = 3);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTokensTab(List<Token> todayTokens) {
    if (todayTokens.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No tokens for today', style: TextStyle(color: Colors.grey, fontSize: 16)),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _navigateToCreateToken,
              icon: Icon(Icons.add),
              label: Text('Create New Token'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today\'s Tokens (${todayTokens.length})',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          ...todayTokens.map((token) => Card(
            margin: EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getTokenColor(token.status),
                child: Icon(Icons.confirmation_number, color: Colors.white, size: 20),
              ),
              title: Text('Token #${token.tokenNumber}', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer: ${token.userName}'),
                  Text('Time: ${token.timeSlot}'),
                  Text('Status: ${token.status.toUpperCase()}'),
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTokenColor(token.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('₹${token.totalAmount}', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              onTap: () => _showTokenDetails(token),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildShopTab(Shop shop) {
    final isOpen = _isShopOpen(shop);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop Information Card
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shop Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Name: ${shop.name}'),
                  Text('Address: ${shop.address}'),
                  Text('License: ${shop.licenseNumber}'),
                  Row(
                    children: [
                      Text('Status: '),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isOpen ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isOpen ? 'Open' : 'Closed',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  Text('Hours: ${shop.openingHours['open']} - ${shop.openingHours['close']}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Inventory Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Shop Inventory',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: _refreshInventory,
                icon: Icon(Icons.refresh, size: 16),
                label: Text('Refresh'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Inventory items
          if (shop.inventory.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No inventory data available', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 8),
                      Text('Contact admin to set up inventory', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            )
          else
            ...shop.inventory.entries.map((entry) {
              final item = entry.key;
              final details = entry.value as Map<String, dynamic>;
              final current = (details['current'] ?? 0).toDouble();
              final max = (details['max'] ?? 1).toDouble();
              final percentage = (current / max * 100).toInt();
              final isLowStock = percentage < 30;

              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          if (isLowStock)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'LOW STOCK',
                                style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('${current.toInt()} ${details['unit']} / ${max.toInt()} ${details['unit']}'),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: current / max,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(
                          percentage > 50 ? Colors.green :
                          percentage > 30 ? Colors.orange : Colors.red,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$percentage% available'),
                          Text('₹${details['price']}/${details['unit']}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sales Reports & Analytics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.analytics_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Reports & Analytics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Detailed reports and analytics will be available here soon',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTokenColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'confirmed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showTokenDetails(Token token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Token Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Token Number: ${token.tokenNumber}'),
            Text('Customer: ${token.userName}'),
            Text('Ration Card: ${token.rationCardNo}'),
            Text('Date: ${token.date}'),
            Text('Time Slot: ${token.timeSlot}'),
            Text('Status: ${token.status.toUpperCase()}'),
            Text('Total Amount: ₹${token.totalAmount}'),
          ],
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

  void _refreshInventory() {
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Inventory refreshed')),
    );
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No new notifications')),
    );
  }

  void _navigateToCreateToken() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DealerCreateTokenPage(
          dealerId: widget.dealerId,
          dealerName: widget.dealerName,
          shopId: _currentDealer.shopId,
          shopName: _currentDealer.shopName,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void _navigateToTimeManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopTimeManagementPage(
          dealerId: widget.dealerId,
          shopId: _currentDealer.shopId,
        ),
      ),
    );
  }

  void _navigateToCashPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManualCashPayment(
          dealerId: widget.dealerId,
          rationCardNo: 'RC123456',
          onPaymentAdded: (payment) {
            setState(() {});
          },
        ),
      ),
    );
  }
}
