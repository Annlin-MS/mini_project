import 'package:flutter/foundation.dart';

class Token {
  final String id;
  final String userId;
  final String userName;
  final String rationCardNo;
  final String shopId;
  final String shopName;
  final String dealerId;
  final String dealerName;
  final String date;
  final String timeSlot;
  final String slotId;
  final String tokenNumber;
  String status;
  final List<Map<String, dynamic>> items;
  final DateTime createdAt;
  final double totalAmount;
  bool stockVerified;
  final String? paymentMethod;
  final String? paymentStatus;
  String? adminNotes;
  String? dealerNotes;
  final int queuePosition;
  final String bookingWindowId;

  Token({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rationCardNo,
    required this.shopId,
    required this.shopName,
    required this.dealerId,
    required this.dealerName,
    required this.date,
    required this.timeSlot,
    required this.slotId,
    required this.tokenNumber,
    required this.status,
    required this.items,
    required this.createdAt,
    required this.totalAmount,
    required this.stockVerified,
    this.paymentMethod,
    this.paymentStatus,
    this.adminNotes,
    this.dealerNotes,
    required this.queuePosition,
    required this.bookingWindowId,
  });

  // Factory method for creating new tokens
  factory Token.create({
    required String userId,
    required String userName,
    required String rationCardNo,
    required String shopId,
    required String shopName,
    required String dealerId,
    required String dealerName,
    required String date,
    required String timeSlot,
    required String slotId,
    required String bookingWindowId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required int queuePosition,
  }) {
    return Token(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      userName: userName,
      rationCardNo: rationCardNo,
      shopId: shopId,
      shopName: shopName,
      dealerId: dealerId,
      dealerName: dealerName,
      date: date,
      timeSlot: timeSlot,
      slotId: slotId,
      bookingWindowId: bookingWindowId,
      tokenNumber: 'T${DateTime.now().millisecondsSinceEpoch}',
      status: 'confirmed',
      items: items,
      createdAt: DateTime.now(),
      totalAmount: totalAmount,
      stockVerified: false,
      queuePosition: queuePosition,
    );
  }

  // Convert to map for serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'rationCardNo': rationCardNo,
      'shopId': shopId,
      'shopName': shopName,
      'dealerId': dealerId,
      'dealerName': dealerName,
      'date': date,
      'timeSlot': timeSlot,
      'slotId': slotId,
      'bookingWindowId': bookingWindowId,
      'tokenNumber': tokenNumber,
      'status': status,
      'items': items,
      'createdAt': createdAt.toIso8601String(),
      'totalAmount': totalAmount,
      'stockVerified': stockVerified,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'adminNotes': adminNotes,
      'dealerNotes': dealerNotes,
      'queuePosition': queuePosition,
    };
  }

  // Create from map for deserialization
  factory Token.fromMap(Map<String, dynamic> map) {
    return Token(
      id: map['id'],
      userId: map['userId'],
      userName: map['userName'],
      rationCardNo: map['rationCardNo'],
      shopId: map['shopId'],
      shopName: map['shopName'],
      dealerId: map['dealerId'],
      dealerName: map['dealerName'],
      date: map['date'],
      timeSlot: map['timeSlot'],
      slotId: map['slotId'],
      bookingWindowId: map['bookingWindowId'],
      tokenNumber: map['tokenNumber'],
      status: map['status'],
      items: List<Map<String, dynamic>>.from(map['items']),
      createdAt: DateTime.parse(map['createdAt']),
      totalAmount: map['totalAmount'],
      stockVerified: map['stockVerified'],
      paymentMethod: map['paymentMethod'],
      paymentStatus: map['paymentStatus'],
      adminNotes: map['adminNotes'],
      dealerNotes: map['dealerNotes'],
      queuePosition: map['queuePosition'],
    );
  }
}