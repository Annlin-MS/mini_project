import 'package:flutter/material.dart';
import '../models/shop_model.dart';
import '../data/mock_database.dart';

class ShopTimingsDisplay extends StatelessWidget {
  final String shopId;

  const ShopTimingsDisplay({Key? key, required this.shopId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shop = mockShops.firstWhere((s) => s.id == shopId, orElse: () => mockShops.first);
    final openingHours = shop.openingHours;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Timings'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.storefront, color: Colors.green),
                title: Text(shop.name),
                subtitle: Text(shop.address),
              ),
            ),
            SizedBox(height: 20),
            Text('Opening Hours', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  for (var entry in openingHours.entries)
                    ListTile(
                      title: Text(entry.key[0].toUpperCase() + entry.key.substring(1)),
                      subtitle: entry.value['closed'] ?? false
                          ? Text('Closed', style: TextStyle(color: Colors.red))
                          : Text('${entry.value['open']} - ${entry.value['close']}'),
                      trailing: entry.value['closed'] ?? false
                          ? Icon(Icons.close, color: Colors.red)
                          : Icon(Icons.check_circle, color: Colors.green),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}