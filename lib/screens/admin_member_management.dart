import 'package:flutter/material.dart';
import '../data/mock_database.dart'; // Import mockRationCards data here only
import '../models/ration_card.dart';
import 'admin_add_edit_member.dart';

class AdminMemberManagement extends StatefulWidget {
  @override
  _AdminMemberManagementState createState() => _AdminMemberManagementState();
}

class _AdminMemberManagementState extends State<AdminMemberManagement> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Color _getCardColorByIncome(int? income) {
    if (income == null) return Colors.grey.shade300;
    if (income < 25000) return Colors.yellow.shade700;
    if (income < 50000) return Colors.pink.shade200;
    if (income < 100000) return Colors.blue.shade300;
    return Colors.white;
  }

  List<Map<String, dynamic>> _getAllUserProfiles() {
    return mockRationCards.map((card) {
      return {
        'rationCard': card.cardNumber,
        'name': card.headOfFamily,
        'income': card.annualIncome,
        'type': card.cardType,
        'shopId': card.shopId,
        'totalMembers': card.familyMembers.length,
        'cardObject': card,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final users = _getAllUserProfiles();
    final filteredUsers = _searchQuery.isEmpty
        ? users
        : users.where((user) {
      final query = _searchQuery.toLowerCase();
      return (user['rationCard'] as String).toLowerCase().contains(query) ||
          (user['name'] as String).toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Family Members'),
        backgroundColor: Colors.red.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search members...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    onChanged: (value) => setState(() {
                      _searchQuery = value;
                    }),
                  ),
                ),
                SizedBox(width: 12),
                FloatingActionButton(
                  onPressed: _addMember,
                  mini: true,
                  backgroundColor: Colors.red.shade700,
                  child: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: filteredUsers.isEmpty
                  ? Center(child: Text('No members found.'))
                  : ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  final cardColor =
                  _getCardColorByIncome(user['income'] as int?);
                  return Card(
                    color: cardColor.withOpacity(0.2),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: cardColor,
                        child: Text(
                          (user['type'] as String).substring(0, 1),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(user['name']),
                      subtitle: Text(
                          'Card: ${user['rationCard']} • Members: ${user['totalMembers']} • Shop: ${user['shopId']}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) =>
                            _handleMenuAction(value, user),
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'view', child: Text('View')),
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action, Map<String, dynamic> user) {
    final card = user['cardObject'] as RationCard;
    switch (action) {
      case 'view':
        _showDetails(user);
        break;
      case 'edit':
        Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (_) => AdminAddEditMember(rationCard: card),
        ))
            .then((_) => setState(() {}));
        break;
      case 'delete':
        _confirmDelete(card);
        break;
    }
  }

  void _showDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Details for ${user['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Card Number: ${user['rationCard']}'),
            Text('Head: ${(user['cardObject'] as RationCard).headOfFamily}'),
            Text('Type: ${user['type']}'),
            Text('Shop: ${user['shopId']}'),
            Text('Annual Income: ${(user['income'] ?? 'N/A')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(RationCard card) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Delete card for ${card.headOfFamily} (${card.cardNumber})?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteCard(card);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteCard(RationCard card) {
    setState(() {
      mockRationCards.removeWhere((c) => c.cardNumber == card.cardNumber);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Card deleted successfully')));
  }

  void _addMember() {
    if (mockRationCards.isEmpty) return;

    Navigator.of(context)
        .push(MaterialPageRoute(
        builder: (_) => AdminAddEditMember(rationCard: mockRationCards.first)))
        .then((_) => setState(() {}));
  }
}
