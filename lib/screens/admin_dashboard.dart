import 'package:flutter/material.dart';
import '../models/ration_card.dart';
import 'add_edit_ration_card.dart';
import 'admin_member_management.dart';
import 'admin_dealer_management.dart';
import 'admin_stock_management.dart';
import 'admin_analytics.dart';
import 'admin_complaint_management.dart';
import 'admin_message_center.dart';

class AdminDashboard extends StatefulWidget {
  final String adminId;
  final String adminName;

  const AdminDashboard({
    Key? key,
    required this.adminId,
    required this.adminName,
  }) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  final List<String> _appBarTitles = [
    'Admin Dashboard',
    'User Management',
    'Dealer Management',
    'Inventory Control',
    'System Analytics',
    'Districts',
    'Ration Cards',
    'Complaints',
    'Messages',
  ];

  // Kerala districts mock data
  final Map<String, Map<String, dynamic>> keralaDistricts = {
    'Thiruvananthapuram': {'shops': 450, 'cards': 125000, 'dealers': 450, 'population': 3301427},
    'Kollam': {'shops': 380, 'cards': 98000, 'dealers': 380, 'population': 2635375},
    'Pathanamthitta': {'shops': 220, 'cards': 52000, 'dealers': 220, 'population': 1197412},
    'Alappuzha': {'shops': 320, 'cards': 78000, 'dealers': 320, 'population': 2127789},
    'Kottayam': {'shops': 290, 'cards': 68000, 'dealers': 290, 'population': 1974551},
    'Idukki': {'shops': 180, 'cards': 42000, 'dealers': 180, 'population': 1108974},
    'Ernakulam': {'shops': 520, 'cards': 142000, 'dealers': 520, 'population': 3282388},
    'Thrissur': {'shops': 410, 'cards': 95000, 'dealers': 410, 'population': 3121200},
    'Palakkad': {'shops': 360, 'cards': 85000, 'dealers': 360, 'population': 2952254},
    'Malappuram': {'shops': 580, 'cards': 165000, 'dealers': 580, 'population': 4112920},
    'Kozhikode': {'shops': 450, 'cards': 128000, 'dealers': 450, 'population': 3249761},
    'Wayanad': {'shops': 150, 'cards': 35000, 'dealers': 150, 'population': 817420},
    'Kannur': {'shops': 380, 'cards': 92000, 'dealers': 380, 'population': 2523003},
    'Kasaragod': {'shops': 200, 'cards': 48000, 'dealers': 200, 'population': 1307375}
  };

  // Mock Ration Cards
  final List<RationCard> mockCards = [
    // RationCard(
    //     id: '1',
    //     cardNumber: 'RC1001',
    //     headOfFamily: 'John Doe',
    //     cardType: 'APL',
    //     district: 'Thiruvananthapuram',
    //     memberCount: 4,
    //     isActive: true),
    // RationCard(
    //     id: '2',
    //     cardNumber: 'RC1002',
    //     headOfFamily: 'Jane Smith',
    //     cardType: 'BPL',
    //     district: 'Kollam',
    //     memberCount: 3,
    //     isActive: true),
    // RationCard(
    //     id: '3',
    //     cardNumber: 'RC1003',
    //     headOfFamily: 'Ali Khan',
    //     cardType: 'PHH',
    //     district: 'Ernakulam',
    //     memberCount: 5,
    //     isActive: false),
  ];

  // Mock recent activities
  final List<Map<String, String>> mockActivities = [
    {'description': 'Added new ration card', 'user': 'Admin', 'timestamp': '2h ago'},
    {'description': 'Deactivated card RC1003', 'user': 'Admin', 'timestamp': '5h ago'},
    {'description': 'Updated dealer info', 'user': 'Admin', 'timestamp': '1d ago'},
  ];

  int get totalShops => keralaDistricts.values.map((e) => e['shops'] as int).reduce((a, b) => a + b);
  int get totalDealers => keralaDistricts.values.map((e) => e['dealers'] as int).reduce((a, b) => a + b);
  int get totalCards => keralaDistricts.values.map((e) => e['cards'] as int).reduce((a, b) => a + b);
  int get totalPopulation => keralaDistricts.values.map((e) => e['population'] as int).reduce((a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_currentIndex]),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () => setState(() => _currentIndex = 7)),
          IconButton(icon: const Icon(Icons.settings), onPressed: _showSettingsDialog),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex >= 5 ? 0 : _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Dealers'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stock'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.red.shade700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings, size: 40, color: Colors.red),
                ),
                const SizedBox(height: 10),
                Text(widget.adminName,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('System Administrator', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          _buildDrawerItem(Icons.location_city, 'Districts', 5),
          _buildDrawerItem(Icons.credit_card, 'Ration Cards', 6),
          _buildDrawerItem(Icons.support_agent, 'Complaints', 7),
          _buildDrawerItem(Icons.message, 'Messages', 8),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: _currentIndex == index ? Colors.red.shade700 : Colors.grey),
      title: Text(title),
      selected: _currentIndex == index,
      onTap: () {
        setState(() => _currentIndex = index);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildOverview();
      case 1:
        return AdminMemberManagement();
      case 2:
        return AdminDealerManagement();
      case 3:
        return AdminStockManagement();
      case 4:
        return AdminAnalytics();
      case 5:
        return _buildDistricts();
      case 6:
        return _buildRationCards();
      case 7:
        return AdminComplaintManagement();
      case 8:
        return AdminMessageCenter();
      default:
        return _buildOverview();
    }
  }

  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Welcome Card
        Card(
          color: Colors.red.shade50,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.admin_panel_settings, size: 40, color: Colors.red.shade700),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome, ${widget.adminName}!',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const Text('Kerala State Public Distribution System',
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
        const Text('Kerala State Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        // Statistics Cards
        Row(children: [
          _statCard('Total Shops', totalShops.toString(), Icons.storefront, Colors.orange),
          const SizedBox(width: 12),
          _statCard('Total Dealers', totalDealers.toString(), Icons.person, Colors.green),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          _statCard('Ration Cards', '${(totalCards / 100000).toStringAsFixed(1)}L', Icons.credit_card, Colors.purple),
          const SizedBox(width: 12),
          _statCard('Districts', '14', Icons.location_city, Colors.blue),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          _statCard('Population', '${(totalPopulation / 10000000).toStringAsFixed(1)}Cr', Icons.people, Colors.teal),
          const SizedBox(width: 12),
          _statCard('Coverage', '${((totalCards * 4.2 / totalPopulation) * 100).toStringAsFixed(1)}%', Icons.pie_chart, Colors.indigo),
        ]),

        const SizedBox(height: 20),
        const Text('Recent Activities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        Card(
          child: Column(
            children: mockActivities.map((activity) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.history, color: Colors.blue.shade700),
                ),
                title: Text(activity['description']!),
                subtitle: Text(activity['user']!),
                trailing: Text(activity['timestamp']!),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }

  Widget _buildDistricts() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: keralaDistricts.entries.map((district) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(district.key.substring(0, 2).toUpperCase(),
                    style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
              ),
              title: Text(district.key, style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('Shops: ${district.value['shops']} • Dealers: ${district.value['dealers']} • Cards: ${district.value['cards']}'),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRationCards() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: mockCards.map((card) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getCardColor(card.cardType),
                child: Text(card.cardNumber.substring(0, 2), style: const TextStyle(color: Colors.white)),
              ),
              title: Text(card.headOfFamily),
              subtitle: Text('Card: ${card.cardNumber} • Type: ${card.cardType} • Members: ${card.memberCount}'),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCardColor(String? cardType) {
    switch (cardType?.toLowerCase()) {
      case 'bpl':
        return Colors.pink.shade700;
      case 'apl':
        return Colors.blue.shade700;
      case 'aay':
        return Colors.orange.shade700;
      case 'phh':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: Icon(Icons.person), title: Text('Profile Settings')),
            ListTile(leading: Icon(Icons.security), title: Text('Security')),
            ListTile(leading: Icon(Icons.help), title: Text('Help & Support')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _logout() {
    // Mock logout
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('You are logged out (mock).'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}
