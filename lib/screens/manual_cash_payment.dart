import 'package:flutter/material.dart';
import '../models/payment_model.dart';

class ManualCashPayment extends StatefulWidget {
  final String rationCardNo;
  final String dealerId;
  final Function(Payment) onPaymentAdded;

  const ManualCashPayment({
    Key? key,
    required this.rationCardNo,
    required this.dealerId,
    required this.onPaymentAdded,
  }) : super(key: key);

  @override
  State<ManualCashPayment> createState() => _ManualCashPaymentState();
}

class _ManualCashPaymentState extends State<ManualCashPayment> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final payment = Payment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tokenId: 'manual_cash_token',
        userId: widget.rationCardNo,
        userName: '',
        rationCardNo: widget.rationCardNo,
        amount: amount,
        paymentMethod: 'cash',
        paymentStatus: 'pending',
        transactionId: '', // Changed from null to empty string
        paymentDate: DateTime.now(),
        upiReference: null,
        bankReference: null,
        paymentGateway: null,
      );

      widget.onPaymentAdded(payment);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Manual cash payment recorded. Pending approval.'))
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Cash Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Ration Card No: ${widget.rationCardNo}'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Payment Amount',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter amount';
                  final n = double.tryParse(value);
                  if (n == null || n <= 0) return 'Enter valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
