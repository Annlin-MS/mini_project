import 'package:flutter/material.dart';
import '../models/payment_model.dart';
import '../services/payment_service.dart';
import 'manual_cash_payment.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class PaymentOptionsPage extends StatefulWidget {
  final String userId;
  final String userName;
  final String rationCardNo;

  const PaymentOptionsPage({
    Key? key,
    required this.userId,
    required this.userName,
    required this.rationCardNo,
  }) : super(key: key);

  @override
  _PaymentOptionsPageState createState() => _PaymentOptionsPageState();
}

class _PaymentOptionsPageState extends State<PaymentOptionsPage> {
  final PaymentService _paymentService = PaymentService();

  void _startUpiPayment() {
    final payment = Payment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tokenId: 'token123',
      userId: widget.userId,
      userName: widget.userName,
      rationCardNo: widget.rationCardNo,
      amount: 100.0,
      paymentMethod: 'upi',
      paymentStatus: 'completed',
      transactionId: 'TXN123456',
      paymentDate: DateTime.now(),
      upiReference: 'upi-ref',
      bankReference: null,
      paymentGateway: 'razorpay',
    );
    _paymentService.addPayment(payment);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('UPI payment successful!')),
    );
  }

  void _openManualCashPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManualCashPayment(
          rationCardNo: widget.rationCardNo,
          dealerId: "dealer123",
          onPaymentAdded: (payment) {
            _paymentService.addPayment(payment);
            setState(() {});
          },
        ),
      ),
    );
  }

  Future<void> _downloadPdf() async {
    final pdf = pw.Document();

    final payments = _paymentService.getPaymentsByUserId(widget.userId);

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            children: [
              pw.Text('Payment History', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Date', 'Method', 'Amount', 'Status'],
                data: payments.map((payment) {
                  return [
                    payment.paymentDate.toLocal().toString().split(' ')[0],
                    payment.paymentMethod.toUpperCase(),
                    '₹${payment.amount.toStringAsFixed(2)}',
                    payment.paymentStatus,
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
      name: 'payment_history_${widget.userId}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final payments = _paymentService.getPaymentsByUserId(widget.userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Options & History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Download PDF',
            onPressed: _downloadPdf,
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: _startUpiPayment,
            child: const Text('Pay via UPI'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _openManualCashPayment,
            child: const Text('Manual Cash Payment'),
          ),
          const SizedBox(height: 20),
          const Text('Payment History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ...payments.map((payment) {
            return ListTile(
              title: Text('₹${payment.amount} - ${payment.paymentMethod.toUpperCase()}'),
              subtitle: Text('Date: ${payment.paymentDate.toLocal().toString().split(' ')[0]} \nStatus: ${payment.paymentStatus}'),
              trailing: payment.paymentMethod == 'cash' && payment.paymentStatus == 'pending'
                  ? const Text('Pending Approval', style: TextStyle(color: Colors.orange))
                  : payment.paymentStatus == 'completed'
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
              isThreeLine: true,
            );
          }).toList(),
        ],
      ),
    );
  }
}
