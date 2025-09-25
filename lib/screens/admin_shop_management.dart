import 'package:flutter/material.dart';
import '../data/mock_database.dart';

class AdminShopManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Shop Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: mockShops.length,
              itemBuilder: (context, index) {
                final shop = mockShops[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(Icons.store, color: Colors.blue),
                    title: Text(shop.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(shop.address),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}