import 'package:flutter/material.dart';
import '../models/shop_model.dart';
import '../data/mock_database.dart';

class ShopTimeManagementPage extends StatefulWidget {
  final String dealerId;
  final String shopId;

  const ShopTimeManagementPage({
    Key? key,
    required this.dealerId,
    required this.shopId,
  }) : super(key: key);

  @override
  _ShopTimeManagementPageState createState() => _ShopTimeManagementPageState();
}

class _ShopTimeManagementPageState extends State<ShopTimeManagementPage> {
  late Shop _shop;
  late Map<String, dynamic> _openingHours;

  @override
  void initState() {
    super.initState();
    _shop = mockShops.firstWhere((shop) => shop.id == widget.shopId);
    _openingHours = Map.from(_shop.openingHours);
  }

  void _updateShopTimings() {
    final index = mockShops.indexWhere((shop) => shop.id == widget.shopId);
    if (index != -1) {
      final updatedShop = Shop(
        id: _shop.id,
        name: _shop.name,
        address: _shop.address,
        licenseNumber: _shop.licenseNumber,
        dealerId: _shop.dealerId,
        openingHours: _openingHours,
        inventory: _shop.inventory,
        dealerTimeSlots: _shop.dealerTimeSlots,
      );

      mockShops[index] = updatedShop;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Shop timings updated successfully!'), backgroundColor: Colors.green),
      );
    }
  }

  Widget _buildDayTimePicker(String day, Map<String, dynamic> hours) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: !(hours['closed'] ?? false),
                  onChanged: (value) {
                    setState(() {
                      _openingHours[day]['closed'] = !value!;
                    });
                  },
                ),
                Text(day[0].toUpperCase() + day.substring(1),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            if (!(hours['closed'] ?? false)) ...[
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildTimePicker('Opening Time', hours['open'] ?? '09:00', (time) {
                    setState(() { _openingHours[day]['open'] = time; });
                  })),
                  SizedBox(width: 16),
                  Expanded(child: _buildTimePicker('Closing Time', hours['close'] ?? '18:00', (time) {
                    setState(() { _openingHours[day]['close'] = time; });
                  })),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, String currentTime, ValueChanged<String> onTimeChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        SizedBox(height: 4),
        InkWell(
          onTap: () => _showTimePickerDialog(currentTime, onTimeChanged),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentTime, style: TextStyle(fontSize: 14)),
                Icon(Icons.access_time, size: 18, color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showTimePickerDialog(String currentTime, ValueChanged<String> onTimeChanged) {
    final timeParts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Colors.orange.shade700),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    ).then((pickedTime) {
      if (pickedTime != null) {
        final formattedTime = '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
        onTimeChanged(formattedTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Time Management'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.storefront, color: Colors.orange),
                title: Text(_shop.name),
                subtitle: Text(_shop.address),
              ),
            ),
            SizedBox(height: 20),
            Text('Shop Opening Hours', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildDayTimePicker('monday', _openingHours['monday']),
                  _buildDayTimePicker('tuesday', _openingHours['tuesday']),
                  _buildDayTimePicker('wednesday', _openingHours['wednesday']),
                  _buildDayTimePicker('thursday', _openingHours['thursday']),
                  _buildDayTimePicker('friday', _openingHours['friday']),
                  _buildDayTimePicker('saturday', _openingHours['saturday']),
                  _buildDayTimePicker('sunday', _openingHours['sunday']),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _updateShopTimings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('SAVE SHOP TIMINGS', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}