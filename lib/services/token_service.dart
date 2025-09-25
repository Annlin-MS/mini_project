import 'package:flutter/material.dart';
import '../models/token_model.dart';
import '../models/booking_window_model.dart';
import '../data/mock_database.dart';

class TokenService {
  // ========== TOKEN MANAGEMENT METHODS ==========

  // Get all tokens for a shop
  static List<Token> getShopTokens(String shopId) {
    return mockTokens.where((token) => token.shopId == shopId).toList();
  }

  // Get today's tokens for a shop
  static List<Token> getTodayTokens(String shopId) {
    final today = DateTime.now();
    final todayFormatted = '${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}';

    return mockTokens.where((token) =>
    token.shopId == shopId && token.date == todayFormatted
    ).toList();
  }

  // Get tokens by status
  static List<Token> getTokensByStatus(String shopId, String status) {
    return getTodayTokens(shopId).where((token) => token.status == status).toList();
  }

  // Update token status
  static bool updateTokenStatus(String tokenId, String status) {
    final tokenIndex = mockTokens.indexWhere((t) => t.id == tokenId);
    if (tokenIndex != -1) {
      mockTokens[tokenIndex].status = status;
      return true;
    }
    return false;
  }

  // ========== STOCK MANAGEMENT METHODS ==========

  // Get stock alerts with booking window predictions
  static Map<String, dynamic> getStockAlerts(String shopId) {
    final shop = mockShops.firstWhere((s) => s.id == shopId);
    final inventory = Map<String, Map<String, dynamic>>.from(shop.inventory);

    // Get stock prediction based on booking windows
    final prediction = getStockPrediction(shopId);
    final expectedNeeds = prediction['expectedNeeds'] as Map<String, double>;

    final outOfStock = <String>[];
    final lowStock = <Map<String, dynamic>>[];
    final todayDistribution = <String, double>{};

    inventory.forEach((item, details) {
      final current = details['current'] ?? 0;
      final max = details['max'] ?? 1;
      final expectedNeed = expectedNeeds[item] ?? 0;

      // Track today's distribution
      final todayTokens = mockTokens.where((token) =>
      token.shopId == shopId &&
          token.status == 'completed' &&
          token.items.any((tItem) => tItem['name'] == item)
      ).length;

      todayDistribution[item] = (todayTokens * _getAverageQuantity(item)).toDouble();

      // Check stock status
      if (current == 0) {
        outOfStock.add(item);
      } else if (current < expectedNeed * 0.3) { // Less than 30% of expected need
        lowStock.add({
          'item': item,
          'current': current,
          'max': max,
          'expected': expectedNeed,
          'percentage': (current / expectedNeed * 100).toInt(),
        });
      }
    });

    return {
      'outOfStock': outOfStock,
      'lowStock': lowStock,
      'todayDistribution': todayDistribution,
      'stockPrediction': prediction,
    };
  }

  // Stock prediction based on booking windows
  static Map<String, dynamic> getStockPrediction(String shopId) {
    final today = DateTime.now();

    // Get today's booking windows for this shop
    final todayWindows = mockBookingWindows.where((window) =>
    (window as BookingWindow).shopId == shopId &&
        window.date.year == today.year &&
        window.date.month == today.month &&
        window.date.day == today.day
    ).toList();

    // Calculate expected tokens = sum of all window capacities
    final expectedTokens = todayWindows.fold(0, (sum, window) => sum + (window as BookingWindow).maxTokens);

    // Get actual booked tokens for today
    final todayFormatted = '${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}';
    final actualTokens = mockTokens.where((token) =>
    token.shopId == shopId && token.date == todayFormatted
    ).length;

    // Calculate expected stock needs based on average consumption
    final expectedNeeds = {
      'Rice': expectedTokens * 5.0,    // Average 5kg per token
      'Wheat': expectedTokens * 3.0,   // Average 3kg per token
      'Sugar': expectedTokens * 2.0,   // Average 2kg per token
      'Kerosene': expectedTokens * 3.0,// Average 3L per token
    };

    return {
      'expectedTokens': expectedTokens,
      'actualTokens': actualTokens,
      'expectedNeeds': expectedNeeds,
      'bookingWindows': todayWindows.length,
      'utilizationRate': expectedTokens > 0 ? (actualTokens / expectedTokens * 100) : 0,
      'windows': todayWindows.map((w) => {
        'session': (w as BookingWindow).session,
        'maxTokens': w.maxTokens,
        'bookedTokens': w.tokensBooked,
        'availableTokens': w.availableTokens,
        'isActive': w.isActive
      }).toList(),
    };
  }

  // Get expected distribution for planning
  static Map<String, double> getExpectedDistribution(String shopId, DateTime date) {
    // Get booking windows for the specific date
    final dateWindows = mockBookingWindows.where((window) =>
    (window as BookingWindow).shopId == shopId &&
        window.date.year == date.year &&
        window.date.month == date.month &&
        window.date.day == date.day
    ).toList();

    final expectedTokens = dateWindows.fold(0, (sum, window) => sum + (window as BookingWindow).maxTokens);

    return {
      'Rice': expectedTokens * 5.0,
      'Wheat': expectedTokens * 3.0,
      'Sugar': expectedTokens * 2.0,
      'Kerosene': expectedTokens * 3.0,
      'totalExpectedTokens': expectedTokens.toDouble(),
    };
  }

  // ========== TOKEN VALIDATION METHODS ==========

  // Check if a token can be served (stock available)
  static bool canServeToken(String tokenId) {
    final token = mockTokens.firstWhere((t) => t.id == tokenId);
    final shop = mockShops.firstWhere((s) => s.id == token.shopId);
    final inventory = Map<String, Map<String, dynamic>>.from(shop.inventory);

    for (var item in token.items) {
      final itemName = item['name'];
      final quantity = double.tryParse(item['quantity'].toString().split(' ')[0]) ?? 0;

      if (inventory.containsKey(itemName)) {
        final currentStock = inventory[itemName]!['current'] ?? 0;
        if (currentStock < quantity) {
          return false;
        }
      }
    }
    return true;
  }

  // ========== REPORTING METHODS ==========

  // Get token statistics
  static Map<String, dynamic> getTokenStatistics(String shopId, DateTime rangeStart, DateTime rangeEnd) {
    final allTokens = getShopTokens(shopId);
    final filteredTokens = allTokens.where((token) {
      final tokenDate = _parseTokenDate(token.date);
      return tokenDate.isAfter(rangeStart.subtract(Duration(days: 1))) &&
          tokenDate.isBefore(rangeEnd.add(Duration(days: 1)));
    }).toList();

    final statusCount = <String, int>{
      'pending': 0,
      'approved': 0,
      'completed': 0,
      'rejected': 0,
      'cancelled': 0,
    };

    for (var token in filteredTokens) {
      statusCount.update(token.status, (value) => value + 1, ifAbsent: () => 1);
    }

    final totalRevenue = filteredTokens.where((t) => t.status == 'completed')
        .fold(0.0, (sum, token) => sum + token.totalAmount);

    return {
      'totalTokens': filteredTokens.length,
      'statusCount': statusCount,
      'totalRevenue': totalRevenue,
      'averageTokenValue': filteredTokens.isNotEmpty ? totalRevenue / filteredTokens.length : 0,
      'completionRate': filteredTokens.isNotEmpty ?
      (statusCount['completed']! / filteredTokens.length * 100) : 0,
    };
  }

  // ========== MALPRACTICE REPORTING ==========

  static void reportMalpractice(String tokenId, String reporterId, String reason) {
    final tokenIndex = mockTokens.indexWhere((t) => t.id == tokenId);
    if (tokenIndex != -1) {
      mockTokens[tokenIndex].adminNotes = 'Malpractice reported by $reporterId: $reason';
    }
  }

  // ========== HELPER METHODS ==========

  // Parse token date string to DateTime
  static DateTime _parseTokenDate(String dateStr) {
    final parts = dateStr.split('/');
    return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }

  // Helper method to get average quantity per item
  static double _getAverageQuantity(String item) {
    switch (item) {
      case 'Rice': return 5.0;
      case 'Wheat': return 3.0;
      case 'Sugar': return 2.0;
      case 'Kerosene': return 3.0;
      default: return 1.0;
    }
  }

  // Get utilization rate for booking windows
  static double getWindowUtilizationRate(String shopId) {
    final today = DateTime.now();
    final todayWindows = mockBookingWindows.where((window) =>
    (window as BookingWindow).shopId == shopId &&
        window.date.year == today.year &&
        window.date.month == today.month &&
        window.date.day == today.day
    ).toList();

    if (todayWindows.isEmpty) return 0.0;

    final totalCapacity = todayWindows.fold(0, (sum, window) => sum + (window as BookingWindow).maxTokens);
    final totalBooked = todayWindows.fold(0, (sum, window) => sum + (window as BookingWindow).tokensBooked);

    return totalCapacity > 0 ? (totalBooked / totalCapacity * 100) : 0.0;
  }

  // Check if shop can accept more tokens today
  static bool canAcceptMoreTokens(String shopId) {
    final prediction = getStockPrediction(shopId);
    final expectedTokens = prediction['expectedTokens'] as int;
    final actualTokens = prediction['actualTokens'] as int;

    // Check if we have available capacity in booking windows
    final todayWindows = mockBookingWindows.where((window) =>
    (window as BookingWindow).shopId == shopId &&
        window.date.year == DateTime.now().year &&
        window.date.month == DateTime.now().month &&
        window.date.day == DateTime.now().day &&
        window.isActive &&
        !window.isFull
    ).toList();

    return todayWindows.isNotEmpty;
  }

  // Get recommended booking window capacities based on stock
  static Map<String, int> getRecommendedCapacities(String shopId) {
    final shop = mockShops.firstWhere((s) => s.id == shopId);
    final inventory = Map<String, Map<String, dynamic>>.from(shop.inventory);

    // Find the most limiting item
    var maxTokens = 9999; // Start with high number

    inventory.forEach((item, details) {
      final current = details['current'] ?? 0;
      final avgConsumption = _getAverageQuantity(item);

      if (avgConsumption > 0) {
        final itemCapacity = (current / avgConsumption).floor();
        if (itemCapacity < maxTokens) {
          maxTokens = itemCapacity;
        }
      }
    });

    // Distribute across sessions
    return {
      'morning': (maxTokens * 0.6).floor(), // 60% in morning
      'evening': (maxTokens * 0.4).floor(), // 40% in evening
      'total': maxTokens,
    };
  }
}