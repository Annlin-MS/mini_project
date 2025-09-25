import '../models/payment_model.dart';

class PaymentService {
  final List<Payment> _paymentList = [];

  List<Payment> getPaymentsByUserId(String userId) {
    return _paymentList.where((p) => p.userId == userId).toList();
  }

  List<Payment> getPaymentsByDealerId(String dealerId) {
    return _paymentList.where((p) => p.tokenId == dealerId).toList();
  }

  void addPayment(Payment payment) {
    _paymentList.add(payment);
  }

  void updatePaymentStatus(String paymentId, String status) {
    int index = _paymentList.indexWhere((p) => p.id == paymentId);
    if (index != -1) {
      var p = _paymentList[index];
      _paymentList[index] = Payment(
        id: p.id,
        tokenId: p.tokenId,
        userId: p.userId,
        userName: p.userName,
        rationCardNo: p.rationCardNo,
        amount: p.amount,
        paymentMethod: p.paymentMethod,
        paymentStatus: status,
        transactionId: p.transactionId,
        paymentDate: p.paymentDate,
        upiReference: p.upiReference,
        bankReference: p.bankReference,
        paymentGateway: p.paymentGateway,
      );
    }
  }
}
