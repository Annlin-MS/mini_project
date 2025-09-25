import 'package:flutter/material.dart';
// Import mock database for mockRationCards and mockShops only here
import '../data/mock_database.dart';
import '../models/ration_card.dart';
import '../models/shop_model.dart';

class AddEditRationCard extends StatefulWidget {
  final RationCard? rationCard;

  const AddEditRationCard({Key? key, this.rationCard}) : super(key: key);

  @override
  _AddEditRationCardState createState() => _AddEditRationCardState();
}

class _AddEditRationCardState extends State<AddEditRationCard> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cardNumberController;
  late TextEditingController _headNameController;
  int? _annualIncome;
  String? _job;
  String _cardType = 'BPL';
  Shop? _selectedShop;

  @override
  void initState() {
    super.initState();
    final card = widget.rationCard;
    _cardNumberController = TextEditingController(text: card?.cardNumber ?? '');
    _headNameController = TextEditingController(text: card?.headOfFamily ?? '');
    _annualIncome = card?.annualIncome;
    _job = card?.job;
    _cardType = card?.cardType ?? 'BPL';
    _selectedShop = card != null ? mockShops.firstWhere((s) => s.id == card.shopId, orElse: () => mockShops[0]) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rationCard == null ? 'Add Ration Card' : 'Edit Ration Card'),
        backgroundColor: Colors.red.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(labelText: 'Card Number'),
                validator: (val) => val == null || val.isEmpty ? 'Enter card number' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _headNameController,
                decoration: InputDecoration(labelText: 'Head of Family Name'),
                validator: (val) => val == null || val.isEmpty ? 'Enter head name' : null,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _cardType,
                decoration: InputDecoration(labelText: 'Card Type'),
                items: ['AAY', 'BPL', 'PHH', 'APL']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _cardType = value!),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<Shop>(
                value: _selectedShop,
                decoration: InputDecoration(labelText: 'Shop'),
                items: mockShops
                    .map((shop) => DropdownMenuItem(value: shop, child: Text(shop.name)))
                    .toList(),
                onChanged: (shop) => setState(() => _selectedShop = shop),
              ),
              SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Annual Income'),
                initialValue: _annualIncome?.toString(),
                onChanged: (val) => _annualIncome = int.tryParse(val),
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: 'Job/Occupation'),
                initialValue: _job,
                onChanged: (val) => _job = val,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
                child: Text(widget.rationCard == null ? 'Add Card' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate() && _selectedShop != null) {
      final newCard = RationCard(
        cardNumber: _cardNumberController.text.trim(),
        cardType: _cardType,
        shopId: _selectedShop!.id,
        headOfFamily: _headNameController.text.trim(),
        familyMembers: widget.rationCard?.familyMembers ?? [],
        issueDate: DateTime.now(),
        expiryDate: DateTime.now().add(Duration(days: 365 * 5)),
        annualIncome: _annualIncome,
        job: _job,
      );

      if (widget.rationCard == null) {
        mockRationCards.add(newCard);
      } else {
        final idx = mockRationCards.indexWhere((c) => c.cardNumber == widget.rationCard!.cardNumber);
        if (idx != -1) {
          mockRationCards[idx] = newCard;
        }
      }

      Navigator.of(context).pop(newCard);
    }
  }
}
