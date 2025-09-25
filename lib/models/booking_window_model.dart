import 'package:flutter/material.dart';

class BookingWindow {
  final String id;
  final String dealerId;
  final String shopId;
  final DateTime date;
  final String session; // 'morning' or 'evening'
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int maxTokens;
  int tokensBooked;
  bool isActive;
  final DateTime createdAt;

  BookingWindow({
    required this.id,
    required this.dealerId,
    required this.shopId,
    required this.date,
    required this.session,
    required this.startTime,
    required this.endTime,
    required this.maxTokens,
    this.tokensBooked = 0,
    this.isActive = true,
    required this.createdAt,
  });

  int get availableTokens => maxTokens - tokensBooked;
  bool get isFull => tokensBooked >= maxTokens;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dealerId': dealerId,
      'shopId': shopId,
      'date': date.toIso8601String(),
      'session': session,
      'startTime': '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
      'endTime': '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
      'maxTokens': maxTokens,
      'tokensBooked': tokensBooked,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BookingWindow.fromMap(Map<String, dynamic> map) {
    final startParts = (map['startTime'] as String).split(':');
    final endParts = (map['endTime'] as String).split(':');

    return BookingWindow(
      id: map['id'],
      dealerId: map['dealerId'],
      shopId: map['shopId'],
      date: DateTime.parse(map['date']),
      session: map['session'],
      startTime: TimeOfDay(hour: int.parse(startParts[0]), minute: int.parse(startParts[1])),
      endTime: TimeOfDay(hour: int.parse(endParts[0]), minute: int.parse(endParts[1])),
      maxTokens: map['maxTokens'],
      tokensBooked: map['tokensBooked'],
      isActive: map['isActive'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
