import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/shop_model.dart'; // Import the Shop model

class AdminStockManagement extends StatefulWidget {
  @override
  _AdminStockManagementState createState() => _AdminStockManagementState();
}

class _AdminStockManagementState extends State<AdminStockManagement> {
  String _selectedShop = 'shop1';

  @override
  Widget build(BuildContext context) {
    final selectedShop = mockShops.firstWhere(
          (shop) => shop.id == _selectedShop,
      orElse: () => mockShops.first,
    );

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Shop Selection
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.store, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
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
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Stock Overview Cards
          _buildStockOverview(selectedShop),
          SizedBox(height: 20),

          // Stock Items List
          Expanded(
            child: ListView(
              children: [
                ...selectedShop.inventory.entries.map((entry) {
                  return _buildStockItemCard(entry.key, entry.value, selectedShop);
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockOverview(Shop shop) {
    final stats = _calculateStockStats(Map<String, Map<String, dynamic>>.from(shop.inventory));

    return Row(
      children: [
        _stockStatCard('Total Items', stats['totalItems'].toString(), Icons.inventory, Colors.blue),
        SizedBox(width: 12),
        _stockStatCard('Low Stock', stats['lowStock'].toString(), Icons.warning, Colors.orange),
        SizedBox(width: 12),
        _stockStatCard('Out of Stock', stats['outOfStock'].toString(), Icons.error, Colors.red),
      ],
    );
  }

  Widget _stockStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockItemCard(String item, Map<String, dynamic> details, Shop shop) {
    final current = details['current'] ?? 0;
    final max = details['max'] ?? 1;
    final percentage = (current / max * 100).toInt();

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Chip(
                  label: Text('${details['unit']}'),
                  backgroundColor: Colors.blue.shade50,
                ),
              ],
            ),
            SizedBox(height: 12),
            LinearProgressIndicator(
              value: current / max,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                  percentage > 50 ? Colors.green :
                  percentage > 25 ? Colors.orange : Colors.red
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$current / $max ${details['unit']}'),
                Text('${percentage}%', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: percentage > 50 ? Colors.green :
                    percentage > 25 ? Colors.orange : Colors.red
                )),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.remove, size: 18),
                  label: Text('Remove 10'),
                  onPressed: () => _updateStock(shop, item, current - 10),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.add, size: 18),
                  label: Text('Add 10'),
                  onPressed: () => _updateStock(shop, item, current + 10),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade50,
                    foregroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, int> _calculateStockStats(Map<String, Map<String, dynamic>> inventory) {
    int totalItems = inventory.length;
    int lowStock = 0;
    int outOfStock = 0;

    inventory.forEach((item, details) {
      final current = details['current'] ?? 0;
      final max = details['max'] ?? 1;

      if (current == 0) {
        outOfStock++;
      } else if (current / max < 0.2) {
        lowStock++;
      }
    });

    return {
      'totalItems': totalItems,
      'lowStock': lowStock,
      'outOfStock': outOfStock,
    };
  }

  void _updateStock(Shop shop, String item, int newQuantity) {
    if (newQuantity >= 0) {
      setState(() {
        shop.inventory[item]?['current'] = newQuantity;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$item stock updated to $newQuantity'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stock cannot be negative'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}