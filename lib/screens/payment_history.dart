import 'package:flutter/material.dart';
import '../models/payment_model.dart';

class PaymentHistoryPage extends StatelessWidget {
  final List<Payment> payments;

  const PaymentHistoryPage({Key? key, required this.payments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment History')),
      body: ListView.separated(
        padding: EdgeInsets.all(10),
        separatorBuilder: (_, __) => Divider(),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final p = payments[index];
          return ListTile(
            leading: Icon(
              p.paymentStatus.toLowerCase() == 'completed' ? Icons.check_circle : Icons.hourglass_top,
              color: p.paymentStatus.toLowerCase() == 'completed' ? Colors.green : Colors.orange,
            ),
            title: Text('₹${p.amount} via ${p.paymentMethod.toUpperCase()}'),
            subtitle: Text('Status: ${p.paymentStatus}\nDate: ${p.paymentDate.toLocal()}'),
            trailing: p.paymentGateway != null ? Text(p.paymentGateway!.toUpperCase()) : null,
            isThreeLine: true,
          );
        },
      ),
    );
  }
}
