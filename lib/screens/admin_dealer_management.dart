import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/dealer_model.dart';

class AdminDealerManagement extends StatefulWidget {
  @override
  _AdminDealerManagementState createState() => _AdminDealerManagementState();
}

class _AdminDealerManagementState extends State<AdminDealerManagement> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final dealers = mockDealers;
    final filteredDealers = _searchQuery.isEmpty
        ? dealers
        : dealers.where((dealer) =>
    dealer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        dealer.shopName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        dealer.licenseNumber.contains(_searchQuery)).toList();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Dealers',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Statistics
            _buildDealerStatistics(dealers),
            SizedBox(height: 20),

            // Dealers List
            Expanded(
              child: filteredDealers.isEmpty
                  ? Center(child: Text('No dealers found'))
                  : ListView.builder(
                itemCount: filteredDealers.length,
                itemBuilder: (context, index) {
                  final dealer = filteredDealers[index];
                  return _buildDealerCard(dealer);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewDealer,
        backgroundColor: Colors.red.shade700,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDealerStatistics(List<Dealer> dealers) {
    final activeDealers = dealers.where((dealer) => dealer.status == 'active').length;
    final inactiveDealers = dealers.where((dealer) => dealer.status == 'inactive').length;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Total Dealers', dealers.length.toString(), Icons.business_center),
            _buildStatItem('Active', activeDealers.toString(), Icons.check_circle, Colors.green),
            _buildStatItem('Inactive', inactiveDealers.toString(), Icons.cancel, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, [Color? color]) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.grey, size: 24),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildDealerCard(Dealer dealer) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Icon(Icons.person, color: Colors.orange),
        ),
        title: Text(dealer.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dealer.shopName),
            Text('License: ${dealer.licenseNumber}'),
            Text('Status: ${dealer.status.toUpperCase()}',
                style: TextStyle(color: _getStatusColor(dealer.status))),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _editDealer(dealer),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteDealer(dealer),
            ),
          ],
        ),
        onTap: () => _showDealerDetails(dealer),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active': return Colors.green;
      case 'inactive': return Colors.orange;
      case 'suspended': return Colors.red;
      default: return Colors.grey;
    }
  }

  void _addNewDealer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Dealer'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'Name')),
              TextField(decoration: InputDecoration(labelText: 'Shop Name')),
              TextField(decoration: InputDecoration(labelText: 'License Number')),
              TextField(decoration: InputDecoration(labelText: 'Phone')),
              TextField(decoration: InputDecoration(labelText: 'Email')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add dealer logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Dealer added successfully')),
              );
            },
            child: Text('Add Dealer'),
          ),
        ],
      ),
    );
  }

  void _editDealer(Dealer dealer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Dealer'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'Name', hintText: dealer.name)),
              TextField(decoration: InputDecoration(labelText: 'Shop Name', hintText: dealer.shopName)),
              TextField(decoration: InputDecoration(labelText: 'License', hintText: dealer.licenseNumber)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Edit dealer logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Dealer updated successfully')),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteDealer(Dealer dealer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Dealer'),
        content: Text('Are you sure you want to delete ${dealer.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Delete dealer logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Dealer deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDealerDetails(Dealer dealer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Dealer Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Name', dealer.name),
              _buildDetailRow('Shop', dealer.shopName),
              _buildDetailRow('License', dealer.licenseNumber),
              _buildDetailRow('Phone', dealer.phone),
              _buildDetailRow('Email', dealer.email),
              _buildDetailRow('Address', dealer.address),
              _buildDetailRow('Status', dealer.status.toUpperCase()),
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
          Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}