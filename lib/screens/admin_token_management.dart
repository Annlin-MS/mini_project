import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../services/token_service.dart';
import '../models/token_model.dart';

class AdminTokenManagement extends StatefulWidget {
  @override
  _AdminTokenManagementState createState() => _AdminTokenManagementState();
}

class _AdminTokenManagementState extends State<AdminTokenManagement> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedShop = 'all';
  String _selectedStatus = 'all';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Token Management'),
        backgroundColor: Colors.deepPurple,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Overview'),
            Tab(text: 'Active Tokens'),
            Tab(text: 'Pending Review'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildActiveTokensTab(),
          _buildPendingReviewTab(),
          _buildAnalyticsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final todayTokens = TokenService.getTodayTokens(_selectedShop == 'all' ? '' : _selectedShop);
    final pendingTokens = todayTokens.where((t) => t.status == 'pending').length;
    final approvedTokens = todayTokens.where((t) => t.status == 'approved').length;
    final completedTokens = todayTokens.where((t) => t.status == 'completed').length;
    final rejectedTokens = todayTokens.where((t) => t.status == 'rejected').length;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Filter Row
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedShop,
                  onChanged: (value) => setState(() => _selectedShop = value!),
                  items: [
                    DropdownMenuItem(value: 'all', child: Text('All Shops')),
                    ...mockShops.map((shop) => DropdownMenuItem(
                      value: shop.id,
                      child: Text(shop.name),
                    )),
                  ],
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Statistics Cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard('Total Today', todayTokens.length.toString(), Colors.blue, Icons.confirmation_number),
              _buildStatCard('Pending', pendingTokens.toString(), Colors.orange, Icons.hourglass_empty),
              _buildStatCard('Completed', completedTokens.toString(), Colors.green, Icons.check_circle),
              _buildStatCard('Rejected', rejectedTokens.toString(), Colors.red, Icons.cancel),
            ],
          ),
          SizedBox(height: 20),

          // Recent Alerts
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  _buildAlertItem('Stock Alert: Rice running low at Shop A', Icons.warning, Colors.orange),
                  _buildAlertItem('Disputed Token: #T12345 needs review', Icons.error, Colors.red),
                  _buildAlertItem('High demand: 150+ tokens for tomorrow', Icons.trending_up, Colors.blue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTokensTab() {
    var tokens = mockTokens.where((token) {
      if (_selectedShop != 'all' && token.shopId != _selectedShop) return false;
      if (_selectedStatus != 'all' && token.status != _selectedStatus) return false;
      return true;
    }).toList();

    return Column(
      children: [
        // Filters
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedStatus,
                  onChanged: (value) => setState(() => _selectedStatus = value!),
                  items: [
                    DropdownMenuItem(value: 'all', child: Text('All Status')),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'approved', child: Text('Approved')),
                    DropdownMenuItem(value: 'completed', child: Text('Completed')),
                    DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Token List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: tokens.length,
            itemBuilder: (context, index) {
              final token = tokens[index];
              return Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(token.status),
                    child: Text(
                      token.tokenNumber.substring(token.tokenNumber.length - 2),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text('${token.userName}'),
                  subtitle: Text('${token.rationCardNo} • ${token.date} ${token.timeSlot}'),
                  trailing: _buildStatusChip(token.status),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...token.items.map((item) => Text('• ${item['name']}: ${item['quantity']}')),
                          SizedBox(height: 8),
                          Text('Total Amount: ₹${token.totalAmount}'),
                          SizedBox(height: 12),
                          if (token.status == 'pending') _buildActionButtons(token),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPendingReviewTab() {
    final pendingTokens = mockTokens.where((token) =>
    token.status == 'pending' || token.adminNotes?.isNotEmpty == true).toList();

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: pendingTokens.length,
      itemBuilder: (context, index) {
        final token = pendingTokens[index];
        return Card(
          color: Colors.orange.shade50,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Token #${token.tokenNumber}', style: TextStyle(fontWeight: FontWeight.bold)),
                    _buildStatusChip(token.status),
                  ],
                ),
                SizedBox(height: 8),
                Text('User: ${token.userName}'),
                Text('Shop: ${token.shopName}'),
                Text('Date: ${token.date} ${token.timeSlot}'),
                if (token.adminNotes?.isNotEmpty == true)
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    padding: EdgeInsets.all(8),
                    color: Colors.red.shade100,
                    child: Text('Note: ${token.adminNotes}', style: TextStyle(color: Colors.red.shade800)),
                  ),
                SizedBox(height: 12),
                _buildActionButtons(token),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Token Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    // Add charts and analytics here
                    Text('Daily Token Trends'),
                    Text('Peak Hours Analysis'),
                    Text('Shop Performance Comparison'),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('System Health', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    _buildHealthIndicator('Stock Levels', 85, Colors.green),
                    _buildHealthIndicator('Token Processing', 92, Colors.green),
                    _buildHealthIndicator('User Satisfaction', 78, Colors.orange),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(String message, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(width: 8),
          Expanded(child: Text(message, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Chip(
      label: Text(status.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: _getStatusColor(status),
    );
  }

  Widget _buildActionButtons(Token token) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => _approveToken(token),
          icon: Icon(Icons.check, size: 16),
          label: Text('Approve'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
        ElevatedButton.icon(
          onPressed: () => _rejectToken(token),
          icon: Icon(Icons.close, size: 16),
          label: Text('Reject'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
        ElevatedButton.icon(
          onPressed: () => _reviewToken(token),
          icon: Icon(Icons.visibility, size: 16),
          label: Text('Review'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
      ],
    );
  }

  Widget _buildHealthIndicator(String title, int percentage, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Container(
            width: 100,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Text('$percentage%'),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'approved': return Colors.blue;
      case 'completed': return Colors.green;
      case 'rejected': return Colors.red;
      case 'cancelled': return Colors.grey;
      default: return Colors.grey;
    }
  }

  void _approveToken(Token token) {
    if (TokenService.canServeToken(token.id)) {
      TokenService.updateTokenStatus(token.id, 'approved');
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token ${token.tokenNumber} approved'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot approve - insufficient stock'), backgroundColor: Colors.red),
      );
    }
  }

  void _rejectToken(Token token) {
    TokenService.updateTokenStatus(token.id, 'rejected');
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Token ${token.tokenNumber} rejected'), backgroundColor: Colors.red),
    );
  }

  void _reviewToken(Token token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Token Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Token: ${token.tokenNumber}'),
            Text('User: ${token.userName}'),
            Text('Ration Card: ${token.rationCardNo}'),
            Text('Amount: ₹${token.totalAmount}'),
            SizedBox(height: 8),
            Text('Items:'),
            ...token.items.map((item) => Text('• ${item['name']}: ${item['quantity']}')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Close')),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }
}
