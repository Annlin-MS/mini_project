class Payment {
  final String id;
  final String tokenId;
  final String userId;
  final String userName;
  final String rationCardNo;
  final double amount;
  final String paymentMethod; // cash, upi, card, wallet
  final String paymentStatus; // pending, completed, failed, refunded
  final String transactionId;
  final DateTime paymentDate;
  final String? upiReference;
  final String? bankReference;
  final String? paymentGateway; // razorpay, paytm, phonepe, etc.

  Payment({
    required this.id,
    required this.tokenId,
    required this.userId,
    required this.userName,
    required this.rationCardNo,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.transactionId,
    required this.paymentDate,
    this.upiReference,
    this.bankReference,
    this.paymentGateway,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tokenId': tokenId,
      'userId': userId,
      'userName': userName,
      'rationCardNo': rationCardNo,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'transactionId': transactionId,
      'paymentDate': paymentDate.toIso8601String(),
      'upiReference': upiReference,
      'bankReference': bankReference,
      'paymentGateway': paymentGateway,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      tokenId: map['tokenId'],
      userId: map['userId'],
      userName: map['userName'],
      rationCardNo: map['rationCardNo'],
      amount: map['amount'],
      paymentMethod: map['paymentMethod'],
      paymentStatus: map['paymentStatus'],
      transactionId: map['transactionId'],
      paymentDate: DateTime.parse(map['paymentDate']),
      upiReference: map['upiReference'],
      bankReference: map['bankReference'],
      paymentGateway: map['paymentGateway'],
    );
  }
}
