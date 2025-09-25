import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/complaint_model.dart';
import '../models/dealer_model.dart';
import '../models/shop_model.dart';
import '../models/ration_card.dart';
import '../services/complaint_service.dart';
import 'admin_member_management.dart';
import 'admin_dealer_management.dart';
import 'admin_stock_management.dart';
import 'admin_analytics.dart';
import 'admin_message_center.dart';
import 'admin_complaint_management.dart';
import 'add_edit_ration_card.dart';

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

  // Kerala districts data - REPLACED mock Firebase queries
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

  // Calculate Kerala totals
  int get totalShops => keralaDistricts.values
      .map((district) => district['shops'] as int)
      .reduce((a, b) => a + b);

  int get totalCards => keralaDistricts.values
      .map((district) => district['cards'] as int)
      .reduce((a, b) => a + b);

  int get totalDealers => keralaDistricts.values
      .map((district) => district['dealers'] as int)
      .reduce((a, b) => a + b);

  int get totalPopulation => keralaDistricts.values
      .map((district) => district['population'] as int)
      .reduce((a, b) => a + b);

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
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('complaints')
                          .where('status', isEqualTo: 'pending')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox.shrink();
                        final count = snapshot.data!.docs.length;
                        return Text(
                          count > 99 ? '99+' : '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () => _navigateToComplaints(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(),
          ),
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
                Text(
                  widget.adminName,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'System Administrator',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const Text('Kerala State Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Kerala Statistics Cards
          Row(children: [
            _statCard('Total Shops', totalShops.toString(), Icons.storefront, Colors.orange),
            const SizedBox(width: 12),
            _statCard('Total Dealers', totalDealers.toString(), Icons.person, Colors.green),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            _statCard('Ration Cards', '${(totalCards / 100000).toStringAsFixed(1)}L',
                Icons.credit_card, Colors.purple),
            const SizedBox(width: 12),
            _statCard('Districts', '14', Icons.location_city, Colors.blue),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            _statCard('Population', '${(totalPopulation / 10000000).toStringAsFixed(1)}Cr',
                Icons.people, Colors.teal),
            const SizedBox(width: 12),
            _statCard('Coverage', '${((totalCards * 4.2 / totalPopulation) * 100).toStringAsFixed(1)}%',
                Icons.pie_chart, Colors.indigo),
          ]),

          const SizedBox(height: 20),

          // Districts Summary Card - FIXED CODE HERE
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('District Wise Distribution',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Top 5 Districts by Cards - CORRECTED VERSION
                  ...() {
                    // Convert to list and sort separately
                    var entries = keralaDistricts.entries.toList();
                    entries.sort((a, b) => (b.value['cards'] as int).compareTo(a.value['cards'] as int));

                    // Take top 5 and convert to widgets
                    return entries.take(5).map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w500)),
                          Row(
                            children: [
                              Text('${(entry.value['cards'] / 1000).toStringAsFixed(0)}K cards'),
                              const SizedBox(width: 8),
                              Text('${entry.value['shops']} shops',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ));
                  }(),

                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () => setState(() => _currentIndex = 5),
                      child: const Text('View All Districts →'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Recent Activities
          const SizedBox(height: 20),
          const Text('Recent Activities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('activities')
                .orderBy('timestamp', descending: true)
                .limit(5)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              final activities = snapshot.data!.docs;
              if (activities.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No recent activities'),
                  ),
                );
              }

              return Card(
                child: Column(
                  children: activities.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.history, color: Colors.blue.shade700),
                      ),
                      title: Text(data['description'] ?? 'Activity'),
                      subtitle: Text(data['user'] ?? 'System'),
                      trailing: Text(
                        _formatTimestamp(data['timestamp']),
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDistricts() {
    int totalCards = keralaDistricts.values
        .map((district) => district['cards'] as int)
        .reduce((a, b) => a + b);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kerala Districts (14)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Total: ${(totalCards / 100000).toStringAsFixed(1)}L Cards',
                  style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 16),

          ...keralaDistricts.entries.map((district) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  district.key.substring(0, 2).toUpperCase(),
                  style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(district.key, style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shops: ${district.value['shops']} • Dealers: ${district.value['dealers']}'),
                  Text('Cards: ${(district.value['cards'] / 1000).toStringAsFixed(0)}K • Population: ${(district.value['population'] / 100000).toStringAsFixed(1)}L'),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showDistrictDetails(district.key, district.value),
              isThreeLine: true,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildRationCards() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ration Card Management',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: _addNewRationCard,
                icon: const Icon(Icons.add),
                label: const Text('New Card'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('ration_cards')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final cards = snapshot.data!.docs;
              if (cards.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text('No ration cards found'),
                    ),
                  ),
                );
              }

              return Column(
                children: cards.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getCardColor(data['cardType']),
                        child: Text(
                          data['cardNumber']?.toString().substring(0, 2) ?? 'RC',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(data['headOfFamily'] ?? 'Unknown'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Card: ${data['cardNumber']} • Type: ${data['cardType']}'),
                          Text('Members: ${data['memberCount'] ?? 0} • District: ${data['district'] ?? 'N/A'}'),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (action) => _handleCardAction(action, doc),
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(value: 'view', child: Text('View Details')),
                          const PopupMenuItem(value: 'deactivate', child: Text('Deactivate')),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
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

  void _showDistrictDetails(String districtName, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.location_city, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Text(districtName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Total Shops:', '${data['shops']}'),
            _detailRow('Total Dealers:', '${data['dealers']}'),
            _detailRow('Ration Cards:', '${data['cards']}'),
            _detailRow('Population:', '${(data['population'] / 100000).toStringAsFixed(1)}L'),
            _detailRow('Coverage:', '${((data['cards'] * 4.2 / data['population']) * 100).toStringAsFixed(1)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.blue)),
        ],
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

  void _addNewRationCard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditRationCard()),
    );
  }

  // FIXED: Updated to properly handle RationCard objects
  void _handleCardAction(String action, DocumentSnapshot doc) {
    switch (action) {
      case 'edit':
        try {
          // Convert DocumentSnapshot to RationCard object with ID
          final data = doc.data() as Map<String, dynamic>;
          final rationCard = RationCard.fromMap(data, doc.id);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditRationCard(rationCard: rationCard),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading card: $e')),
          );
        }
        break;
      case 'view':
        _showCardDetails(doc);
        break;
      case 'deactivate':
        _deactivateCard(doc);
        break;
    }
  }

  void _showCardDetails(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Card Details - ${data['cardNumber']}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Head of Family:', data['headOfFamily'] ?? 'N/A'),
              _detailRow('Card Type:', data['cardType'] ?? 'N/A'),
              _detailRow('District:', data['district'] ?? 'N/A'),
              _detailRow('Members:', '${data['memberCount'] ?? 0}'),
              _detailRow('Status:', data['isActive'] == true ? 'Active' : 'Inactive'),
              _detailRow('Shop ID:', data['shopId'] ?? 'N/A'),
              _detailRow('Annual Income:', data['annualIncome'] != null ? '₹${data['annualIncome']}' : 'N/A'),
              _detailRow('Job:', data['job'] ?? 'N/A'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _deactivateCard(DocumentSnapshot doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Card'),
        content: const Text('Are you sure you want to deactivate this ration card?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await doc.reference.update({'isActive': false});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Card deactivated successfully')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deactivating card: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  void _navigateToComplaints() {
    setState(() => _currentIndex = 7);
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile Settings'),
            ),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Security'),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help & Support'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error signing out: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';

    DateTime dateTime;
    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else if (timestamp is String) {
      dateTime = DateTime.tryParse(timestamp) ?? DateTime.now();
    } else {
      return 'Unknown';
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
