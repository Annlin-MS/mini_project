// lib/services/booking_service.dart
import 'package:flutter/material.dart';
import '../models/booking_window_model.dart';
import '../models/token_model.dart';
import '../data/mock_database.dart';

class BookingService {
  static List<BookingWindow> mockBookingWindows = [];

  // Create new booking window
  static BookingWindow createBookingWindow({
    required String dealerId,
    required String shopId,
    required DateTime date,
    required String session,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required int maxTokens,
  }) {
    final window = BookingWindow(
      id: 'window_${DateTime.now().millisecondsSinceEpoch}',
      dealerId: dealerId,
      shopId: shopId,
      date: date,
      session: session,
      startTime: startTime,
      endTime: endTime,
      maxTokens: maxTokens,
      createdAt: DateTime.now(),
    );

    mockBookingWindows.add(window);
    return window;
  }

  // Get active windows for a shop
  static List<BookingWindow> getActiveWindows(String shopId) {
    return mockBookingWindows.where((window) =>
    window.shopId == shopId &&
        window.isActive &&
        !window.isFull &&
        window.date.isAfter(DateTime.now().subtract(Duration(days: 1)))
    ).toList();
  }

  // Book token in a window
  static Token? bookTokenInWindow({
    required String bookingWindowId,
    required String userId,
    required String userName,
    required String rationCardNo,
    required String shopId,
    required List<Map<String, dynamic>> items,
  }) {
    final windowIndex = mockBookingWindows.indexWhere((w) => w.id == bookingWindowId);

    if (windowIndex == -1) return null;

    final window = mockBookingWindows[windowIndex];

    if (!window.isActive || window.isFull) return null;

    // Get shop and dealer details
    final shop = mockShops.firstWhere((s) => s.id == shopId);
    final dealer = mockDealers.firstWhere((d) => d.id == window.dealerId);

    // Create token
    final token = Token.create(
      userId: userId,
      userName: userName,
      rationCardNo: rationCardNo,
      shopId: shopId,
      shopName: shop.name,
      dealerId: window.dealerId,
      dealerName: dealer.name,
      date: '${window.date.day}/${window.date.month}/${window.date.year}',
      timeSlot: '${_formatTimeOfDay(window.startTime)} - ${_formatTimeOfDay(window.endTime)}',
      slotId: window.id,
      bookingWindowId: window.id,
      items: items,
      totalAmount: _calculateTotal(items),
      queuePosition: window.tokensBooked + 1,
    );

    // Update window
    window.tokensBooked++;
    if (window.isFull) {
      window.isActive = false;
    }

    mockBookingWindows[windowIndex] = window;
    mockTokens.add(token);

    return token;
  }

  static double _calculateTotal(List<Map<String, dynamic>> items) {
    double total = 0;
    for (var item in items) {
      final priceStr = item['price'].toString().replaceAll('₹', '').split('/')[0];
      final quantityStr = item['quantity'].toString().split(' ')[0];
      final price = double.tryParse(priceStr) ?? 0;
      final quantity = double.tryParse(quantityStr) ?? 0;
      total += price * quantity;
    }
    return total;
  }

  static String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  // Notify users about new window
  static void notifyUsers(BookingWindow window) {
    print('Notifying users about ${window.session} session on ${window.date}');
    print('${window.maxTokens} tokens available from ${_formatTimeOfDay(window.startTime)} to ${_formatTimeOfDay(window.endTime)}');
  }
}